import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class ListKomunikasiTahfidz extends StatefulWidget {
  const ListKomunikasiTahfidz({super.key});

  @override
  State<ListKomunikasiTahfidz> createState() => _ListKomunikasiTahfidzState();
}

class _ListKomunikasiTahfidzState extends State<ListKomunikasiTahfidz> {
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
      if (id!=null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initListTahfidz(id: id, tokenss: tokenss);
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
      builder: (context, listTahfidz, child) {
        if (listTahfidz.listTahfidz.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listTahfidz.hasMore
                ? listTahfidz.listTahfidz.length + 1
                : listTahfidz.listTahfidz.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < listTahfidz.listTahfidz.length) {
                final dataTahfidz = listTahfidz.listTahfidz[index];
                final currentUser = _users.isNotEmpty ? _users.first : null;
                final isAuthorized =
                    currentUser?.siskokode == dataTahfidz.kodePegawai;
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
                                        '/form-edit-komunikasi-tahfidz',
                                        arguments: dataTahfidz);
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.yellow.shade600,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteTahfidz(context, dataTahfidz);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(dataTahfidz))
                        : buildListTile(dataTahfidz),
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

  Widget buildListTile(KomunikasiTahfidzModel dataTahfidz) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == dataTahfidz.kodePegawai;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-komunikasi-tahfidz',
            arguments: dataTahfidz);
      },
      title: Text(dataTahfidz.jenisHafalan ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dataTahfidz.namaSiswa ?? ''),
          Text(
            dataTahfidz.catatan ?? '',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dataTahfidz.tanggal ?? '',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
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

  Future<void> _deleteTahfidz(
      BuildContext context, KomunikasiTahfidzModel dataTahfidz) async {
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
                    await KomunikasiService().deleteTahfidz(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      tab: 'tahfidz',
                      idc: dataTahfidz.idTahfidz ?? '',
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: Text('Berhasil dihapus',
                            style: TextStyle(
                                // ignore: use_build_context_synchronously
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
