import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/konseling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/konseling_service.dart';

class ListKonseling extends StatefulWidget {
  const ListKonseling({super.key});

  @override
  State<ListKonseling> createState() => _ListKonselingState();
}

class _ListKonselingState extends State<ListKonseling> {
  final _scrollController = ScrollController();
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      initdata();
      _isInit = false;
    }
  }

  Future<void> initdata() async {
    try {
      await _loadList();
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
        context
            .read<KonselingProvider>()
            .initList(id: id, tokenss: tokenss.substring(0, 30));
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
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KonselingProvider>()
            .refresh(id: id, tokenss: tokenss.substring(0, 30));
      }
    } catch (e) {
      return;
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat.yMMMMd('id_ID').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Konseling'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: Column(
          children: [
            Expanded(
              child: buildList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form-konseling');
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.grey.shade600,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<KonselingProvider>(
      builder: (context, konseling, child) {
        if (konseling.list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: konseling.list.length,
            itemBuilder: (context, index) {
              final konselings = konseling.list[index];
              int nilai = int.parse(konselings.nilai!);
              final user =
                  Provider.of<SqliteUserProvider>(context, listen: false);
              final isAuthorized =
                  user.currentuser.siskokode == konselings.kodePegawai;
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
                                      context, '/form-edit-konseling',
                                      arguments: konselings);
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.yellow.shade600,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteKonseling(context, konselings);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red.shade800,
                              ),
                            ],
                          ),
                          child: buildListTile(konselings, nilai),
                        )
                      : buildListTile(konselings, nilai),
                  const Divider(
                    thickness: 0.1,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildListTile(konselings, int nilai) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final isAuthorized = user.currentuser.siskokode == konselings.kodePegawai;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-konseling', arguments: konselings);
      },
      title: Text(konselings.nama!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(konselings.namaKelas ?? ''),
          Text(
            konselings.kasus ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          Text(
            konselings.petugas ?? '',
            style: const TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: nilai < 0 ? Colors.red : Colors.green,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                formatDate(konselings.tanggal!),
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
          isAuthorized
              ? const Icon(
                  Icons.edit_note,
                )
              : const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Future<void> _deleteKonseling(BuildContext context, konseling) async {
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
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await KonselingService().deleteKonseling(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      idc:
                          '${konseling.nis}|${konseling.kodePegawai}|${konseling.tanggalJam}',
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).colorScheme.primary,
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
