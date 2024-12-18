import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class ListKomunikasiUmum extends StatefulWidget {
  const ListKomunikasiUmum({super.key});

  @override
  State<ListKomunikasiUmum> createState() => _ListKomunikasiUmumState();
}

class _ListKomunikasiUmumState extends State<ListKomunikasiUmum> {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];

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
    await _loadList();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _loadList() async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id !=null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initListUmum(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadList();
    }
  }

  Future<void> _refreshList() async {
    try {
      await _loadList();
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: buildList(),
      ),
    );
  }

  Widget buildList() {
    return Consumer<KomunikasiProvider>(
      builder: (context, listKomunikasi, child) {
        if (listKomunikasi.listUmum.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listKomunikasi.hasMore
                ? listKomunikasi.listUmum.length + 1
                : listKomunikasi.listUmum.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < listKomunikasi.listUmum.length) {
                final listUmum = listKomunikasi.listUmum[index];
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final isAuthorized =
                    user.currentuser.siskokode == listUmum.kodePegawai;
                return Column(
                  children: [
                    isAuthorized
                        ? Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
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
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget buildListTile(KomunikasiUmumModel listUmum) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == listUmum.kodePegawai;
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
      title: Text(
        listUmum.mapel ?? '',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listUmum.namaSiswa ?? '',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            listUmum.bahasan ?? '',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                listUmum.tanggal ?? '',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              Text(
                listUmum.jmlKomen != '' ? '${listUmum.jmlKomen} comment' : '',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          isAuthorized
              ? Icon(
                  Icons.edit_note,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
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
                final id = _users.isNotEmpty ? _users.first.siskonpsn : null;
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
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: Text('Berhasil dihapus',
                            style: TextStyle(
                                color:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _refreshList();
                  } catch (e) {
                    return;
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
