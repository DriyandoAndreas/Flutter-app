import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListPolling extends StatelessWidget {
  const SatListPolling({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatPollingProvider>().getList(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Polling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<SatPollingProvider>(
          builder: (context, value, child) {
            if (value.list.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: value.list.length,
                itemBuilder: (context, index) {
                  var datas = value.list[index];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/view-polling-sat',
                              arguments: datas);
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
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
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
                      ),
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
    );
  }
}
