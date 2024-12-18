import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/jadwal_service.dart';

class ListMapel extends StatefulWidget {
  const ListMapel({super.key});

  @override
  State<ListMapel> createState() => _ListMapelState();
}

class _ListMapelState extends State<ListMapel> {
  final _scrollController = ScrollController();
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initData();
      _isInit = false;
    }
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
        context.read<JadwalProvider>().initList(
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
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<JadwalProvider>().refresh(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
      }
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
    return Consumer<JadwalProvider>(
      builder: (context, mapel, child) {
        if (mapel.listMapel.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: mapel.hasMore
                ? mapel.listMapel.length + 1
                : mapel.listMapel.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < mapel.listMapel.length) {
                final mapels = mapel.listMapel[index];
                var mengajar = mapels.sudahMengajar;
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
                                    _deleteMengajar(context, mapels);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(mapels))
                        : buildListTile(mapels),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else if (index == mapel.listMapel.length) {
                return const SizedBox.shrink();
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget buildListTile(mapels) {
    var mengajar = mapels.sudahMengajar;
    bool isMengajar = false;
    if (mengajar == '1') {
      isMengajar = true;
    }
    return ListTile(
      onTap: isMengajar
          ? null
          : () {
              _addMengajar(context, mapels);
            },
      title: Text(mapels.namaPelajaran!),
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

  Future<void> _deleteMengajar(BuildContext context, mapels) async {
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
                    await JadwalService().deleteMengajar(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      tab: 'mengajar',
                      kodePelajaran: mapels.kodePelajaran!,
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).colorScheme.primary,
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

  Future<void> _addMengajar(BuildContext context, mapels) async {
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
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await JadwalService().addMengajar(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'add',
                      tab: 'mengajar',
                      kodePelajaran: mapels.kodePelajaran!,
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).colorScheme.primary,
                        // ignore: use_build_context_synchronously
                        content: Text(
                          'Berhasil ditambahkan',
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
