import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/uks_provider.dart';

class SatListUks extends StatelessWidget {
  const SatListUks({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskoid;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatUksProvider>().getList(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Kesehatan (UKS)')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Consumer<SatUksProvider>(
          builder: (context, data, child) {
            return ListView.builder(
              itemCount: data.ukssiswa.length,
              itemBuilder: (context, index) {
                final uks = data.ukssiswa[index];
                return Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(uks.diagnosa ?? ''),
                          Text(uks.tanggalperiksa ?? ''),
                          Text(
                            uks.keterangan ?? '',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
