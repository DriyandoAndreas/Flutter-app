import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/uks_model.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/uks_provider.dart';
import 'package:app5/services/uks_service.dart';

class ListUks extends StatefulWidget {
  const ListUks({super.key});

  @override
  State<ListUks> createState() => _ListUksState();
}

class _ListUksState extends State<ListUks> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadList();
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<UksProvider>().initList(id: id, tokenss: tokenss);
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Kesehatan(UKS)"),
      ),
      body: RefreshIndicator.adaptive(
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
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<UksProvider>(
      builder: (context, uks, child) {
        if (uks.list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: uks.hasMore ? uks.list.length + 1 : uks.list.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < uks.list.length) {
                final ukss = uks.list[index];
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final isAuthorized = user.currentuser.siskokode == ukss.nip;

                bool gr = false;
                String kp = ukss.kodePegawai ?? '';

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
                                    Navigator.pushNamed(
                                        context,
                                        gr
                                            ? '/form-uks-edit-gr'
                                            : '/form-uks-edit',
                                        arguments: ukss);
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.yellow.shade600,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _deleteBerita(context, ukss);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(ukss))
                        : buildListTile(ukss),
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

  Widget buildListTile(ukss) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == ukss.nip;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-uks', arguments: ukss);
      },
      title: Text(ukss.namaLengkap ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ukss.diagnosa ?? '',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(ukss.paraf ?? ''),
        ],
      ),
      trailing: isAuthorized
          ? const Icon(
              Icons.edit_note,
            )
          : const Icon(Icons.arrow_forward_ios),
    );
  }

  Future<void> _deleteBerita(BuildContext context, UksModel ukss) async {
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
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await UksService().deleteUks(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      kdPeriksa: ukss.kdPeriksa ?? '',
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        // ignore: use_build_context_synchronously
                        content: Text(
                          'Berhasil dihapus',
                          style: TextStyle(
                              // ignore: use_build_context_synchronously
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
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
