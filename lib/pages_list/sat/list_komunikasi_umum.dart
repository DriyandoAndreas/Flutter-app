import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListKomunikasiUmum extends StatelessWidget {
  const SatListKomunikasiUmum({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<SatKomunikasiProvider>()
          .getListUmum(id: id, tokenss: tokenss);
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(child: Consumer<SatKomunikasiProvider>(
            builder: (context, data, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.listUmum.length,
                itemBuilder: (context, index) {
                  final datas = data.listUmum[index];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/view-komunikasi-sat',
                            arguments: datas,
                          );
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(datas.mapel ?? ''),
                            Text(
                              datas.namapembimbing ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              datas.bahasan ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            )
                          ],
                        ),
                        trailing: Text(
                          datas.tanggal ?? '',
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
          ))
        ],
      ),
    );
  }
}
