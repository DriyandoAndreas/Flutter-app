import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/komunikasi_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/komunikasi_service.dart';

class ListKomunikasiUmum extends StatefulWidget {
  const ListKomunikasiUmum({super.key});

  @override
  State<ListKomunikasiUmum> createState() => _ListKomunikasiUmumState();
}

class _ListKomunikasiUmumState extends State<ListKomunikasiUmum>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<KomunikasiUmumModel> _listUmum = [];
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
        final paginatedList = await KomunikasiService().getList(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listUmum = paginatedList;
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
    if (_isLoading && _listUmum.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_listUmum.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _listUmum.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _listUmum.length) {
            final listUmum = _listUmum[index];
            final currentUser = _users.isNotEmpty ? _users.first : null;
            final isAuthorized = currentUser?.siskokode == listUmum.kodePegawai;
            return Column(
              children: [
                isAuthorized
                    ? Slidable(
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                // TODO: edit form
                                Navigator.pushNamed(
                                    context, '/form-edit-komunikasi-umum',
                                    arguments: listUmum);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.yellow.shade600,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _deleteKomunikasi(context, listUmum);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red.shade800,
                            ),
                          ],
                        ),
                        child: buildListTile(listUmum))
                    : buildListTile(listUmum),
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

  Widget buildListTile(KomunikasiUmumModel listUmum) {
    if (listUmum.jmlKomen == '0') {
      listUmum.jmlKomen = '';
    } else {
      listUmum.jmlKomen;
    }
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-komunikasi-umum',
            arguments: listUmum);
      },
      title: Text(listUmum.mapel ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(listUmum.namaSiswa ?? ''),
          Text(listUmum.bahasan ?? ''),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(listUmum.tanggal ?? ''),
              Text(listUmum.jmlKomen != ''
                  ? '${listUmum.jmlKomen} comment'
                  : ''),
            ],
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Future<void> _deleteKomunikasi(
      BuildContext context, KomunikasiUmumModel listUmum) async {
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
                    await KomunikasiService().deleteKomunikasi(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      tab: 'umum',
                      idc: listUmum.idUmum ?? '',
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
}
