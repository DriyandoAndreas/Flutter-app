import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/teras_sekolah_model.dart';
import 'package:app5/providers/berita_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/berita_service.dart';

class ListTerasSekolah extends StatefulWidget {
  const ListTerasSekolah({
    super.key,
  });

  @override
  State<ListTerasSekolah> createState() => _ListTerasSekolahState();
}

class _ListTerasSekolahState extends State<ListTerasSekolah> {
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
      return;
    }
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<BeritaProvider>().initInfinite(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
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
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<BeritaProvider>().refresh(
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
        title: const Text('Teras Sekolah'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, '/form-teras-sekolah');
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
    return Consumer<BeritaProvider>(
      builder: (context, berita, child) {
        if (berita.infinitelist.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: berita.hasMore
                ? berita.infinitelist.length + 1
                : berita.infinitelist.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < berita.infinitelist.length) {
                final terasSekolah =
                    berita.infinitelist[index]; // Perubahan di sini
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final isAuthorized =
                    user.currentuser.siskokode == terasSekolah.penginput;
                return Column(
                  children: [
                    isAuthorized
                        ? Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    Navigator.pushNamed(
                                        context, '/form-edit-berita',
                                        arguments: terasSekolah);
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.yellow.shade600,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteBerita(context, terasSekolah);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(terasSekolah))
                        : buildListTile(terasSekolah),
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

  Widget buildListTile(terasSekolah) {
    DateTime date = DateTime.parse(terasSekolah.tgl ?? '');
    String dateFormat = DateFormat.yMMMMd('id_ID').format(date);
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == terasSekolah.penginput;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-teras-sekolah',
            arguments: terasSekolah);
      },
      title: Text(
        terasSekolah.judul ?? '',
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            terasSekolah.post ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          Text(
            terasSekolah.pembuat ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ],
      ),
      leading: Image.network(
        terasSekolah.image,
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
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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

  Future<void> _deleteBerita(
      BuildContext context, TerasSekolahModel terasSekolah) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus berita?'),
          content: const Text('Apakah Anda yakin ingin menghapus berita?'),
          actions: [
            TextButton(
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await BeritaService().deleteBerita(
                      id: id,
                      tokenss: tokenss,
                      action: 'del',
                      idc: terasSekolah.kode ?? '',
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        content: Text('Berita berhasil dihapus',
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
