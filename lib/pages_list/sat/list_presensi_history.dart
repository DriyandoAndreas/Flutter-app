import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/presensi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListPresensiHistory extends StatelessWidget {
  const SatListPresensiHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    var kode = user.currentuser.siskokode;
    if (id != null && tokenss != null && kode != null) {
      context
          .read<SatPresensiProvider>()
          .getpresensihistory(id: id, tokenss: tokenss, kode: kode);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(
                width: 8,
              ),
              Text(
                '60 Hari Terakhir',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.2,
        ),
        Expanded(
          child: Consumer<SatPresensiProvider>(
            builder: (context, history, child) {
              if (history.datahistory.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.datahistory.length,
                  itemBuilder: (context, index) {
                    final datas = history.datahistory[index];
                    final date = DateFormat('yyyy-MM-dd').parse(datas.tanggal!);
                    bool isSunday = false;
                    if (date.weekday == DateTime.sunday) {
                      isSunday = true;
                    }
                    return ListTile(
                      title: Text(datas.tanggal!,
                          style: TextStyle(
                            color: isSunday ? Colors.grey : Colors.black,
                            fontWeight:
                                isSunday ? FontWeight.normal : FontWeight.w400,
                          )),
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }
}
