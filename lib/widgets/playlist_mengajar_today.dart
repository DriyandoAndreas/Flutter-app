import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/playlist_mengajar_provider_today.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/playlist_mengajar_service.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistMengajarToday extends StatefulWidget {
  const PlaylistMengajarToday({super.key});

  @override
  State<PlaylistMengajarToday> createState() => _PlaylistMengajarTodayState();
}

class _PlaylistMengajarTodayState extends State<PlaylistMengajarToday> {
  _urlLuncer(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      throw Exception('could not launch the $url');
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Agar tidak bisa di-dismiss ketika klik di luar modal
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    final timeline = Provider.of<PlaylistMengajarProviderToday>(context);

    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;

    if (id != null && tokenss != null) {
      timeline.getTodayTimeLine(id: id, tokenss: tokenss, interval: 0);
    }
    DateTime today = DateTime.now();

    String formattedToday = DateFormat('EEEE, d MMMM y', 'id_ID').format(today);

    var todaytimelines = timeline.timeline;

    var colortoday = Colors.green;

    var daytoday = 'Hari ini';

    return playListData(
      todaytimelines,
      colortoday,
      formattedToday,
      daytoday,
    );
  }

  Widget alertActionKonfirmasi(
    data,
    context,
  ) {
    var today = DateTime.now();
    var datatanggal = DateTime.parse(data.tanggal);

    bool isSameDate = today.year == datatanggal.year &&
        today.month == datatanggal.month &&
        today.day == datatanggal.day;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isSameDate
            ? TextButton(
                onPressed: () async {
                  final user =
                      Provider.of<SqliteUserProvider>(context, listen: false);
                  PlaylistMengajarService service = PlaylistMengajarService();
                  var id = user.currentuser.siskonpsn;
                  var tokenss = user.currentuser.tokenss;
                  var action = 'update-aka-status-op';
                  var status = 'Mulai';
                  var kodeakademik = data.kodeakademik;
                  var idakademik = data.idakademik;
                  try {
                    if (id != null && tokenss != null) {
                      showLoadingDialog(context);
                      await service.updateStatus(
                        id: id,
                        tokenss: tokenss,
                        status: status,
                        action: action,
                        kodeakademik: kodeakademik ?? '',
                        idakademik: idakademik ?? '',
                      );

                      Navigator.pop(context);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } catch (e) {
                    return;
                  }
                },
                child: const Text("Mulai"),
              )
            : const SizedBox.shrink(),
        TextButton(
          onPressed: () async {
            final user =
                Provider.of<SqliteUserProvider>(context, listen: false);
            PlaylistMengajarService service = PlaylistMengajarService();
            var id = user.currentuser.siskonpsn;
            var tokenss = user.currentuser.tokenss;
            var action = 'update-aka-status-op';
            var status = 'Batal';
            var kodeakademik = data.kodeakademik;
            var idakademik = data.idakademik;
            try {
              if (id != null && tokenss != null) {
                showLoadingDialog(context);
                await service.updateStatus(
                  id: id,
                  tokenss: tokenss,
                  status: status,
                  action: action,
                  kodeakademik: kodeakademik ?? '',
                  idakademik: idakademik ?? '',
                );

                Navigator.pop(context);
              }
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } catch (e) {
              return;
            }
          },
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActionMulai(
    data,
    context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            final user =
                Provider.of<SqliteUserProvider>(context, listen: false);
            PlaylistMengajarService service = PlaylistMengajarService();
            var id = user.currentuser.siskonpsn;
            var tokenss = user.currentuser.tokenss;
            var action = 'update-aka-status-op';
            var status = 'Selesai';
            var kodeakademik = data.kodeakademik;
            var idakademik = data.idakademik;
            try {
              if (id != null && tokenss != null) {
                showLoadingDialog(context);
                await service.updateStatus(
                  id: id,
                  tokenss: tokenss,
                  status: status,
                  action: action,
                  kodeakademik: kodeakademik ?? '',
                  idakademik: idakademik ?? '',
                );

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } catch (e) {
              return;
            }
          },
          child: const Text("Selesai"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/form-persiapan-akademik',
                arguments: <String, dynamic>{
                  'id_akademik': data.idakademik,
                  'kode_akademik': data.kodeakademik,
                  'tahun_ajaran': data.tahunajaran,
                  'semester': data.semester,
                  'nama_kelas': data.namakelas,
                  'nama_pelajaran': data.namapelajaran,
                  'nama_lengkap': data.namalengkap,
                  'tanggal': data.tanggal,
                  'mulai': data.mulai,
                  'selesai': data.selesai,
                  'index': 2,
                });
          },
          child: const Text("Presensi"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActionSelesai(
    data,
    context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/form-persiapan-akademik',
                arguments: <String, dynamic>{
                  'id_akademik': data.idakademik,
                  'kode_akademik': data.kodeakademik,
                  'tahun_ajaran': data.tahunajaran,
                  'semester': data.semester,
                  'nama_kelas': data.namakelas,
                  'nama_pelajaran': data.namapelajaran,
                  'nama_lengkap': data.namalengkap,
                  'tanggal': data.tanggal,
                  'mulai': data.mulai,
                  'selesai': data.selesai,
                  'index': 3,
                });
          },
          child: const Text("Laporan"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActions(
    String status,
    data,
    context,
  ) {
    switch (status) {
      case 'Konfirmasi':
        return alertActionKonfirmasi(
          data,
          context,
        );
      case 'Mulai':
        return alertActionMulai(
          data,
          context,
        );
      case 'Selesai':
        return alertActionSelesai(
          data,
          context,
        );
      default:
        return alertActionKonfirmasi(
          data,
          context,
        );
    }
  }

  Future<void> update(
    data,
    context,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${data.namapelajaran} ${data.namakelas}'),
          content: const Text('Update status mengajar'),
          actions: [
            TextButton(
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                PlaylistMengajarService service = PlaylistMengajarService();
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                var action = 'update-aka-status-op';
                var status = 'Konfirmasi';
                var kodeakademik = data.kodeakademik;
                var idakademik = data.idakademik;
                try {
                  if (id != null && tokenss != null) {
                    showLoadingDialog(context);
                    await service.updateStatus(
                      id: id,
                      tokenss: tokenss,
                      status: status,
                      action: action,
                      kodeakademik: kodeakademik ?? '',
                      idakademik: idakademik ?? '',
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } catch (e) {
                  return;
                }
              },
              child: const Text('Konfirmasi'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            )
          ],
        );
      },
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
                      'Anda belum memiliki agenda mengajar pada hari $formattedToday')
                  : Text(
                      'Anda memiliki ${provider.length} agenda mengajar $daylowercase'),
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
                    double absen = double.parse(data.absenht ?? '');
                    double totalabsen = double.parse(data.absen ?? '');
                    var persentase = absen / totalabsen * 100;

                    return Column(
                      children: [
                        TimelineTile(
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
                                        color: Colors.green.shade400,
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
                                                                  .shade400
                                                              : data.status ==
                                                                      'Selesai'
                                                                  ? Colors.blue
                                                                      .shade400
                                                                  : Colors.grey
                                                                      .shade800),
                                                  onPressed: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data.namapelajaran ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Card(
                                                            color: data.status ==
                                                                    'Konfirmasi'
                                                                ? Colors.amber
                                                                    .shade400
                                                                : data.status ==
                                                                        'Mulai'
                                                                    ? Colors
                                                                        .green
                                                                        .shade400
                                                                    : data.status ==
                                                                            'Selesai'
                                                                        ? Colors
                                                                            .blue
                                                                            .shade400
                                                                        : Colors
                                                                            .grey
                                                                            .shade800,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                data.status ==
                                                                        'Konfirmasi'
                                                                    ? 'Konfirmasi'
                                                                    : data.status ==
                                                                            'Mulai'
                                                                        ? 'Mulai'
                                                                        : data.status ==
                                                                                'Selesai'
                                                                            ? 'Selesai'
                                                                            : 'Batal',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      content: data.status ==
                                                              'Konfirmasi'
                                                          ? const Text(
                                                              'Mulai Mengajar?')
                                                          : data.status ==
                                                                  'Mulai'
                                                              ? const Text(
                                                                  'Selesai Mengajar?')
                                                              : data.status ==
                                                                      'Selesai'
                                                                  ? const Text(
                                                                      'Buat laporan mengajar')
                                                                  : const Text(
                                                                      'Mulai Mengajar?'),
                                                      actions: <Widget>[
                                                        data.status ==
                                                                'Konfirmasi'
                                                            ? alertActions(
                                                                'Konfrimasi',
                                                                data,
                                                                context,
                                                              )
                                                            : data.status ==
                                                                    'Mulai'
                                                                ? alertActions(
                                                                    'Mulai',
                                                                    data,
                                                                    context,
                                                                  )
                                                                : data.status ==
                                                                        'Selesai'
                                                                    ? alertActions(
                                                                        'Selesai',
                                                                        data,
                                                                        context,
                                                                      )
                                                                    : alertActions(
                                                                        '',
                                                                        data,
                                                                        context,
                                                                      )
                                                      ],
                                                    ),
                                                  ),
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
                                                            await update(
                                                              data,
                                                              context,
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : IconButton(
                                                          iconSize: 32,
                                                          onPressed: () async {
                                                            await update(
                                                              data,
                                                              context,
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .pending_outlined,
                                                          ),
                                                        ),
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
                                      data.absen != '0' && data.absenht != '0'
                                          ? Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.people_outline),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                        '${data.absenht}/${data.absen} ${persentase.toStringAsFixed(0)}%')
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      //  Text("persiapan siswa: "),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          data.wagroup != ''
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
                                          data.zoomlink != ''
                                              ? TextButton(
                                                  onPressed: () {
                                                    _urlLuncer(
                                                        data.zoomlink ?? '');
                                                  },
                                                  child: const Column(
                                                    children: [
                                                      Icon(
                                                        Icons.link,
                                                        color: Colors.grey,
                                                      ),
                                                      Text("Online Meeting"),
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
}
