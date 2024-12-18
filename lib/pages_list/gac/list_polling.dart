import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/polling_service.dart';
// import 'package:app5/utils/theme.dart';

class ListPolling extends StatefulWidget {
  const ListPolling({super.key});

  @override
  State<ListPolling> createState() => _ListPollingState();
}

class _ListPollingState extends State<ListPolling> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  Future<void> initData() async {
    await loadData();
  }

  Future<void> loadData() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<PollingProvider>().getList(id: id, tokenss: tokenss);
    }
  }

  Future<void> _onrefresh() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Polling"),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onrefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<PollingProvider>(
              builder: (context, value, child) {
                if (value.list.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.list.length,
                    itemBuilder: (context, index) {
                      var datas = value.list[index];
                      return Column(
                        children: [
                          Slidable(
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.pushNamed(
                                          context, '/form-edit-polling',
                                          arguments: datas);
                                    },
                                    icon: Icons.edit,
                                    backgroundColor: Colors.yellow.shade600,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      _deletePolling(datas);
                                    },
                                    icon: Icons.delete,
                                    backgroundColor: Colors.red.shade800,
                                  ),
                                ],
                              ),
                              child: buildListTile(datas)),
                          const Divider(
                            thickness: 0.1,
                          )
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.grey.shade600,
        onPressed: () {
          Navigator.pushNamed(context, '/form-polling');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildListTile(datas) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/view-polling', arguments: datas);
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            datas.namapolling ?? '',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            datas.pertanyaan ?? '',
          ),
          Text(
            datas.peserta ?? '',
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: Colors.blue.shade400,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                '${datas.tanggalselesai}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }

  Future<void> _deletePolling(datas) async {
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
                final PollingService service = PollingService();
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                if (id != null && tokenss != null) {
                  try {
                    await service.deletePolling(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'del',
                      idc: datas.kodepolling ?? '',
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
                    loadData();
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
