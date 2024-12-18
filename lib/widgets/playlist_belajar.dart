import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/playlist_belajar_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class SatPlayListBelajar extends StatelessWidget {
  const SatPlayListBelajar({super.key});

  _urlLuncer(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      throw Exception('could not launch the $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.watch<SatPlayListBelajarProvider>().watchplaylist(
            id: id,
            tokenss: tokenss,
          );
    }
    return playList(
      context,
    );
  }

  Widget playListData(provider, color, formattedToday, day) {
    String days = day;
    String daylowercase = days.toLowerCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TimelineTile(
            isFirst: true,
            alignment: TimelineAlign.manual,
            beforeLineStyle: LineStyle(color: color.shade400),
            indicatorStyle: IndicatorStyle(color: color.shade400),
            startChild: Text(day),
            lineXY: 0.2,
            endChild: Padding(
              padding: const EdgeInsets.all(4),
              child: provider.isEmpty
                  ? Text(
                      'Kamu belum memiliki agenda belajar pada hari $formattedToday')
                  : Text(
                      'kamu memiliki ${provider.length} agenda belajar $daylowercase'),
            ),
          ),
          provider.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.length,
                  itemBuilder: (context, index) {
                    var data = provider[index];
                    bool isLast = index == provider.length - 1;
                    bool haswa = data.wagroup != null;
                    var warnakehadiran = Colors.grey;
                    var statuskehadiran = 'Belum Presensi';
                    switch (data.absen) {
                      case 'H':
                        warnakehadiran = Colors.green;
                        statuskehadiran = 'Hadir';
                        break;
                      case 'S':
                        warnakehadiran = Colors.blue;
                        statuskehadiran = 'Sakit';
                        break;
                      case 'I':
                        warnakehadiran = Colors.amber;
                        statuskehadiran = 'Ijin';
                        break;
                      case 'A':
                        warnakehadiran = Colors.red;
                        statuskehadiran = 'Alpha';
                        break;
                      case 'T':
                        warnakehadiran = Colors.brown;
                        statuskehadiran = 'Terlambat';
                        break;
                      default:
                        warnakehadiran = Colors.grey;
                        statuskehadiran = 'Belum Presensi';
                    }
                    return Column(
                      children: [
                        TimelineTile(
                          // isFirst: true,
                          beforeLineStyle: LineStyle(color: color.shade400),
                          indicatorStyle: IndicatorStyle(color: color.shade400),
                          alignment: TimelineAlign.manual,
                          lineXY: 0.2,
                          isLast: isLast,
                          startChild:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            data.status == 'Konfirmasi'
                                ? Icon(
                                    Icons.flag_outlined,
                                    color: Colors.amber.shade400,
                                  )
                                : data.status == 'Mulai'
                                    ? Icon(
                                        Icons.play_arrow,
                                        color: Colors.green.shade600,
                                      )
                                    : data.status == 'Selesai'
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.blue.shade400,
                                          )
                                        : data.status == 'SUKSES'
                                            ? Icon(Icons.star_outline_sharp,
                                                color: Colors.green.shade800)
                                            : data.status == 'Batal'
                                                ? Icon(Icons.close,
                                                    color: Colors.red.shade800)
                                                : const SizedBox.shrink(),
                            data.status == 'Mulai'
                                ? Text(
                                    '${data.mulaipukul?.substring(0, 5)} ${data.selesai?.substring(0, 5)}')
                                : data.status == 'Selesai' ||
                                        data.status == 'SUKSES'
                                    ? Text(
                                        '${data.mulaipukul?.substring(0, 5)} ${data.selesaipukul?.substring(0, 5)}')
                                    : Text(
                                        '${data.mulai?.substring(0, 5)} ${data.selesai?.substring(0, 5)}'),
                          ]),
                          endChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //const Text("Hari ini"),
                              Card(
                                color: Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data.namapelajaran ?? ''),
                                          data.status != '' &&
                                                  data.status != 'SUKSES' &&
                                                  data.status != 'Batal'
                                              ? TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: data
                                                                  .status ==
                                                              'Konfirmasi'
                                                          ? Colors
                                                              .amber.shade400
                                                          : data.status ==
                                                                  'Mulai'
                                                              ? Colors.green
                                                                  .shade600
                                                              : data.status ==
                                                                      'Selesai'
                                                                  ? Colors.blue
                                                                      .shade400
                                                                  : Colors.grey
                                                                      .shade800),
                                                  onPressed: () {
                                                    null;
                                                  },
                                                  child: Text(
                                                    data.status == 'Konfirmasi'
                                                        ? 'Konfirmasi'
                                                        : data.status == 'Mulai'
                                                            ? 'Mulai'
                                                            : data.status ==
                                                                    'Selesai'
                                                                ? 'Selesai'
                                                                : 'Batal',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : data.status == 'SUKSES'
                                                  ? TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade800),
                                                      onPressed: () {
                                                        null;
                                                      },
                                                      child: const Text(
                                                        'SUKSES',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : data.status == 'Batal'
                                                      ? TextButton(
                                                          style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade800),
                                                          onPressed: () async {
                                                            // await update(
                                                            //   data,
                                                            //   context,
                                                            // );
                                                            null;
                                                          },
                                                          child: const Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                        ],
                                      ),
                                      // Text(data.namapelajaran ?? ''),
                                      Text(data.namakelas ?? ''),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      data.halpersiapan != '' &&
                                              data.halpersiapan != null &&
                                              data.status != 'SUKSES'
                                          ? Text(
                                              "Materi persiapan: ${data.halpersiapan}")
                                          : data.status == 'SUKSES'
                                              ? Text('Materi: ${data.materi}')
                                              : const SizedBox.shrink(),
                                      data.tugassiswa != '' &&
                                              data.tugassiswa != null &&
                                              data.status != 'SUKSES'
                                          ? Text(
                                              "Persiapan: ${data.tugassiswa}")
                                          : data.status == 'SUKSES' &&
                                                  data.tugaspr != '' &&
                                                  data.tugaspr != null
                                              ? Text('PR: ${data.tugaspr}')
                                              : const SizedBox.shrink(),
                                      data.status == 'SUKSES' &&
                                              data.hambatankendala != '' &&
                                              data.hambatankendala != null
                                          ? Text(
                                              'Kendala: ${data.hambatankendala}')
                                          : const SizedBox.shrink(),
                                      data.status == 'SUKSES' &&
                                              data.persiapanberikutnya != '' &&
                                              data.persiapanberikutnya != null
                                          ? Text(
                                              'Persiapan berikutnya: ${data.persiapanberikutnya}')
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Card(
                                          color: warnakehadiran,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  statuskehadiran,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          haswa
                                              ? TextButton(
                                                  onPressed: () {
                                                    _urlLuncer(
                                                        data.wagroup ?? '');
                                                  },
                                                  child: const Column(
                                                    children: [
                                                      Icon(
                                                        Icons.chat,
                                                        color: Colors.blue,
                                                      ),
                                                      Text("Kelas"),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget playList(
    context,
  ) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime dayAfterTomorrow = today.add(const Duration(days: 2));

    String formattedToday = DateFormat('EEEE, d MMMM y', 'id_ID').format(today);
    String formattedTomorrow =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(tomorrow);
    String formattedDayAfterTomorrow =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(dayAfterTomorrow);
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Playlist Belajar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sat-list-akademik');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(8)),
                        backgroundColor: Colors.white,
                      ),
                      child: Consumer<SatPlayListBelajarProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            children: [
                              provider.today.isEmpty &&
                                      provider.tommorrowtimeline.isEmpty &&
                                      provider.tommorrowaftertimeline.isEmpty
                                  ? const Icon(Icons.list, color: Colors.black)
                                  : const Icon(Icons.list, color: Colors.black),
                              const SizedBox(width: 8),
                              provider.today.isEmpty &&
                                      provider.tommorrowtimeline.isEmpty &&
                                      provider.tommorrowaftertimeline.isEmpty
                                  ? const Text(
                                      'Selengkapnya',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : const Text(
                                      'Selengkapnya',
                                      style: TextStyle(color: Colors.black),
                                    )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Consumer<SatPlayListBelajarProvider>(
                builder: (context, provider, child) {
                  var todayprovider = provider.today;
                  var tomorrowprovider = provider.tommorrowtimeline;
                  var tomorrowafterprovider = provider.tommorrowaftertimeline;
                  var colortoday = Colors.green;
                  var colortommorrow = Colors.amber;
                  var colortommorrowafter = Colors.red;
                  var daytoday = 'Hari ini';
                  var daybesok = 'Besok';
                  var daylusa = 'Lusa';
                  return Column(
                    children: [
                      playListData(
                          todayprovider, colortoday, formattedToday, daytoday),
                      playListData(tomorrowprovider, colortommorrow,
                          formattedTomorrow, daybesok),
                      playListData(tomorrowafterprovider, colortommorrowafter,
                          formattedDayAfterTomorrow, daylusa),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
