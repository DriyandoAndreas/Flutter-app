import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/perpus_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListPerpus extends StatelessWidget {
  const SatListPerpus({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatPerpusProvider>().getList(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Perpustakaan'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Consumer<SatPerpusProvider>(
          builder: (context, data, child) {
            return ListView.builder(
              itemCount: data.list.length,
              itemBuilder: (context, index) {
                final datas = data.list[index];
                return Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(datas.judul ?? ''),
                          datas.selesihtgl != '0'
                              ? const Text(
                                  'Aktif',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                )
                              : const Text(
                                  'Tidak aktif',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                          Text(
                            datas.tglpinjam ?? '',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          Text(
                            datas.tglkembali ?? '',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ],
                      ),
                      trailing: Text(
                        datas.callnumber ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    const Divider(
                      thickness: 0.1,
                    )
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
