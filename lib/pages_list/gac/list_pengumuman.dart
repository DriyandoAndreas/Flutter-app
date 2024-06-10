import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/models/pengumuman_model.dart';
import 'package:sisko_v5/providers/pengumuman_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';
import 'package:sisko_v5/services/pengumuman_service.dart';

class ListPengumuman extends StatefulWidget {
  const ListPengumuman({super.key});

  @override
  State<ListPengumuman> createState() => _ListPengumumanState();
}

class _ListPengumumanState extends State<ListPengumuman>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      user.fetchUser();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String id = user.currentuser.siskoid.toString();
      String tokenss = user.currentuser.tokenss.toString();
      if (user.currentuser.siskoid != null &&
          user.currentuser.tokenss != null) {
        context
            .read<PengumumanProvider>()
            .initInfinite(id: id, tokenss: tokenss.substring(0, 30));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadList();
    }
  }

  Future<void> _refreshList() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    String id = user.currentuser.siskoid.toString();
    String tokenss = user.currentuser.tokenss.toString();
    if (user.currentuser.siskoid != null && user.currentuser.tokenss != null) {
      context.read<PengumumanProvider>().refresh(
            id: id,
            tokenss: tokenss.substring(0, 30),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Pengumuman'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/form-pengumuman');
        },
        backgroundColor: Colors.grey.shade600,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<PengumumanProvider>(
      builder: (context, pengumuman, child) {
        if (pengumuman.infinitelist.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: pengumuman.hasMore
                ? pengumuman.infinitelist.length + 1
                : pengumuman.infinitelist.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < pengumuman.infinitelist.length) {
                final pengumumans = pengumuman.infinitelist[index];

                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final isAuthorized =
                    user.currentuser.siskokode == pengumumans.penginput;
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
                                        context, '/form-edit-pengumuman',
                                        arguments: pengumumans);
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.yellow.shade600,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteBerita(context, pengumumans);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(pengumumans))
                        : buildListTile(pengumumans),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget buildListTile(pengumumans) {
    DateTime date = DateTime.parse(pengumumans.tgl ?? '');
    String dateFormat = DateFormat.yMMMMd('id_ID').format(date);
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == pengumumans.penginput;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-pengumuman',
            arguments: pengumumans);
      },
      title: Text(
        pengumumans.judul ?? '',
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pengumumans.post ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color.fromARGB(255, 121, 120, 120)),
          ),
          Text(
            pengumumans.pembuat ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 121, 120, 120)),
          ),
        ],
      ),
      leading: Image.network(
        pengumumans.image ?? '',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image, size: 60);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dateFormat,
            style: const TextStyle(color: Color.fromARGB(255, 121, 120, 120)),
          ),
          const SizedBox(
            width: 8,
          ),
          isAuthorized
              ? const Icon(
                  Icons.edit_note,
                  color: Color.fromARGB(255, 121, 120, 120),
                )
              : const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 121, 120, 120),
                ),
        ],
      ),
    );
  }

  Future<void> _deleteBerita(
      BuildContext context, PengumumanModel terasSekolah) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengumuman?'),
          content: const Text('Apakah Anda yakin ingin menghapus pengumuman?'),
          actions: [
            TextButton(
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final id = user.currentuser.siskoid;
                final tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await PengumumanService().deletePengumuman(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      idc: terasSekolah.kode ?? '',
                    );
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Pengumuman berhasil dihapus'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
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
