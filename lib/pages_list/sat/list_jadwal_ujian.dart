import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListJadwalUjian extends StatelessWidget {
  const SatListJadwalUjian({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatJadwalProvider>().getUjian(id: id, tokenss: tokenss);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Consumer<SatJadwalProvider>(builder: (context, list, child) {
            if (list.ujian.isEmpty) {
              return const Center(
                child: SizedBox.shrink(),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.ujian.length,
                itemBuilder: (context, index) {
                  final data = list.ujian[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.namapelajaran ?? ''),
                            Text(
                              '${data.hari}, ${data.tanggal}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(data.keterangan ?? '',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                          ],
                        ),
                        // trailing: Icon(
                        //   Icons.arrow_forward_ios,
                        //   color: Theme.of(context).colorScheme.tertiary,
                        // ),
                      ),
                      const Divider(
                        thickness: 0.1,
                      )
                    ],
                  );
                },
              );
            }
          })
        ],
      ),
    );
  }
}
