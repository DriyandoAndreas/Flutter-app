import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/jadwal_model.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListJadwalPelajaran extends StatelessWidget {
  const SatListJadwalPelajaran({super.key});

  String getDayname(String day) {
    const dayNames = {
      '1': 'Senin',
      '2': 'Selasa',
      '3': 'Rabu',
      '4': 'Kamis',
      '5': 'Jumat',
    };
    return dayNames[day] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<SatJadwalProvider>().getList(id: id, tokenss: tokenss);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(child: buildList()),
        ],
      ),
    );
  }

  Widget buildList() {
    return Consumer<SatJadwalProvider>(builder: (context, jadwals, child) {
      if (jadwals.list.isEmpty) {
        return emptyList();
      } else {
        var data = jadwals.list;
        return filledList(context, data);
      }
    });
  }

  Widget emptyList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, dayindex) {
        String day = (dayindex + 1).toString();
        String dayName = getDayname(day);
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: Text(
              dayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(8, (hourIndex) {
            String hour = (hourIndex + 1).toString();
            return Container(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(children: [
                ListTile(
                  onTap: () {},
                  title: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('[Kosong]'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: Colors.grey,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'Jam ke-$hour',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 0.1),
              ]),
            );
          }),
        ]);
      },
    );
  }

  Widget filledList(context, data) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, dayindex) {
          String day = (dayindex + 1).toString();
          String dayName = getDayname(day);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: Text(
                    dayName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: 0.1),
                ...List.generate(8, (hourIndex) {
                  String hour = (hourIndex + 1).toString();
                  SatJadwalModel jadwalModel = data.firstWhere(
                      (j) => j.jam == '$day-$hour',
                      orElse: () =>
                          SatJadwalModel(jam: null, namapelajaran: '-'));
                  return Column(
                    children: [
                      ListTile(
                        title: Text(jadwalModel.namapelajaran ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: jadwalModel.namapelajaran != '-'
                                  ? Colors.blue
                                  : Colors.grey,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  'Jam ke-$hour',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.1),
                    ],
                  );
                }),
              ]);
        });
  }
}
