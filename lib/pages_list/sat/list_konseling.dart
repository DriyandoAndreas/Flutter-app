import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/konseling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListKonseling extends StatefulWidget {
  const SatListKonseling({super.key});

  @override
  State<SatListKonseling> createState() => _SatListKonselingState();
}

class _SatListKonselingState extends State<SatListKonseling> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatKonselingProvider>().getList(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Koseling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<SatKonselingProvider>(
          builder: (context, datalist, child) {
            return ListView.builder(
              itemCount: datalist.list.length,
              itemBuilder: (context, index) {
                final datas = datalist.list[index];
                int nilai = int.parse(datas.nilai!);
                bool isMinus = false;
                if (nilai < 0) {
                  isMinus = true;
                }
                return Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            datas.kasus ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${datas.tanggaljam}-${datas.pegawai}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          Text(
                            '${datas.penanganan}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isMinus ? Colors.red : Colors.blue),
                        child: Center(
                          child: Text(
                            datas.nilai ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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
