import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/jadwal_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/jadwal_service.dart';

class ListMapel extends StatefulWidget {
  const ListMapel({super.key});

  @override
  State<ListMapel> createState() => _ListMapelState();
}

class _ListMapelState extends State<ListMapel> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<JadwalModel> _listMapel = [];
  int _limit = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _scrollController.addListener(_loadMoreItems);
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadList(_limit);
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      throw Exception('Failed to fetch data from SQLite');
    }
  }

  Future<void> _loadList(int limit) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await JadwalService().getListMapel(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listMapel = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _limit += 10;
      _loadList(_limit).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _refreshList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _loadList(_limit);
    } catch (e) {
      throw Exception('Failed to reload');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: buildList(),
      ),
    );
  }

  Widget buildList() {
    if (_isLoading && _listMapel.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_listMapel.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _listMapel.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _listMapel.length) {
            final mapel = _listMapel[index];
            var mengajar = mapel.sudahMengajar;
            bool isMengajar = false;
            if (mengajar == '1') {
              isMengajar = true;
            }
            return Column(
              children: [
                isMengajar
                    ? Slidable(
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _deleteMengajar(context, mapel);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red.shade800,
                            ),
                          ],
                        ),
                        child: buildListTile(mapel))
                    : buildListTile(mapel),
                const Divider(
                  thickness: 0.1,
                ),
              ],
            );
          } else if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
    }
  }

  Widget buildListTile(mapel) {
    var mengajar = mapel.sudahMengajar;
    bool isMengajar = false;
    if (mengajar == '1') {
      isMengajar = true;
    }
    return ListTile(
      onTap: isMengajar
          ? null
          : () {
              _addMengajar(context, mapel);
            },
      title: Text(mapel.namaPelajaran!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isMengajar
              ? Card(
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                      'im teching',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                )
              : const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Future<void> _deleteMengajar(BuildContext context, JadwalModel mapel) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus data ini?'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                final id = _users.isNotEmpty ? _users.first.siskoid : null;
                final tokenss = _users.isNotEmpty ? _users.first.tokenss : null;
                if (id != null && tokenss != null) {
                  try {
                    await JadwalService().deleteMengajar(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      tab: 'mengajar',
                      kodePelajaran: mapel.kodePelajaran!,
                    );
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil dihapus'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin:
                            EdgeInsets.only(bottom: 150, left: 15, right: 15),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _refreshList();
                  } catch (e) {
                    throw Exception('$e');
                  }
                }
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            )
          ],
        );
      },
    );
  }

  Future<void> _addMengajar(BuildContext context, JadwalModel mapel) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mengajar'),
          content: const Text('Anda ingin mengajar pelajaran ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                final id = _users.isNotEmpty ? _users.first.siskoid : null;
                final tokenss = _users.isNotEmpty ? _users.first.tokenss : null;
                if (id != null && tokenss != null) {
                  try {
                    await JadwalService().addMengajar(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'add',
                      tab: 'mengajar',
                      kodePelajaran: mapel.kodePelajaran!,
                    );
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil ditambahkan'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin:
                            EdgeInsets.only(bottom: 150, left: 15, right: 15),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _refreshList();
                  } catch (e) {
                    throw Exception('$e');
                  }
                }
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            )
          ],
        );
      },
    );
  }
}
