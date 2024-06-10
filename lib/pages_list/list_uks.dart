import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/models/uks_model.dart';
import 'package:sisko_v5/services/uks_service.dart';

class ListUks extends StatefulWidget {
  const ListUks({super.key});

  @override
  State<ListUks> createState() => _ListUksState();
}

class _ListUksState extends State<ListUks> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<UksModel> _uksList = [];
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
        final paginatedList = await UksService().getList(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _uksList = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load news');
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Kesehatan(UKS)"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/uks-list-kelas');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget buildList() {
    if (_isLoading && _uksList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_uksList.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _uksList.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < _uksList.length) {
            final uks = _uksList[index];
            final currentUser = _users.isNotEmpty ? _users.first : null;
            final isAuthorized = currentUser?.siskokode == uks.nip;

            bool gr = false;
            String kp = uks.kodePegawai ?? '';

            if (kp.contains('GR') || kp.contains('KR')) {
              gr = true;
            }
            return Column(
              children: [
                isAuthorized
                    ? Slidable(
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.pushNamed(context,
                                    gr ? '/form-uks-edit-gr' : '/form-uks-edit',
                                    arguments: uks);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.yellow.shade600,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _deleteBerita(context, uks);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red.shade800,
                            ),
                          ],
                        ),
                        child: buildListTile(uks))
                    : buildListTile(uks),
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

  Widget buildListTile(uks) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    final isAuthorized = currentUser?.siskokode == uks.nip;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-uks', arguments: uks);
      },
      title: Text(uks.namaLengkap ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            uks.diagnosa ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(uks.paraf ?? ''),
        ],
      ),
      trailing: isAuthorized
          ? const Icon(
              Icons.edit_note,
            )
          : const Icon(Icons.arrow_forward_ios),
    );
  }

  Future<void> _deleteBerita(BuildContext context, UksModel uks) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data?'),
          content: const Text('Apakah Anda yakin ingin menghapus data?'),
          actions: [
            TextButton(
              onPressed: () async {
                final id = _users.isNotEmpty ? _users.first.siskoid : null;
                final tokenss = _users.isNotEmpty ? _users.first.tokenss : null;
                if (id != null && tokenss != null) {
                  try {
                    await UksService().deleteUks(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      kdPeriksa: uks.kdPeriksa ?? '',
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
