// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/akademik_service.dart';

class ListAkademik extends StatefulWidget {
  const ListAkademik({super.key});

  @override
  State<ListAkademik> createState() => _ListAkademikState();
}

class _ListAkademikState extends State<ListAkademik> {
  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadData();
  }

  Future<void> _loadUsers() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      user.fetchUser();
    } catch (e) {
      return;
    }
  }

  Future<void> _loadData() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;

      if (id != null && tokenss != null) {
        if (mounted) {
          await context
              .read<AkademikProvider>()
              .getAkademik(id: id, tokenss: tokenss);
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _refreshList() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<AkademikProvider>().refresh(
            id: id,
            tokenss: tokenss.substring(0, 30),
          );
    }
  }

  Color _hexToColor(String? hexColor) {
    hexColor = hexColor?.toUpperCase().replaceAll('#', '');
    if (hexColor?.length == 6) {
      hexColor = 'FF$hexColor';
    }
    // Validate hex string length
    if (hexColor?.length != 8) {
      return Colors.white;
    }
    try {
      return Color(int.parse(hexColor ?? '', radix: 16));
    } catch (e) {
      return Colors.white;
    }
  }

  String _getMonthName(String? monthNumber) {
    if (monthNumber == null || monthNumber.isEmpty) {
      return "0";
    }
    int monthIndex = int.tryParse(monthNumber) ?? -1;

    if (monthIndex < 1 || monthIndex > 12) {
      return "0";
    }
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return monthNames[monthIndex - 1];
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 32,
            onPressed: () {
              _refreshList();
            },
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Akademik"),
      ),
      body: Consumer<AkademikProvider>(
        builder: (context, provider, child) {
          if (provider.list == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (provider.list?.data?.isEmpty ?? true) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: provider.list!.data!.map((tahunData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${tahunData.tahun}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tahunData.data!.map((bulanData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  _getMonthName(bulanData.bulan!),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // TODO: overflow di ios/layar kecil dari 600px
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 700,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bulanData.data!.length,
                                  itemBuilder: (context, index) {
                                    var tanggalData = bulanData.data![index];
                                    int month =
                                        int.parse(bulanData.bulan ?? '0');
                                    int year =
                                        int.parse(tahunData.tahun ?? '0');
                                    DateTime parsedDate = DateTime(year, month,
                                        int.parse(tanggalData.tanggal ?? ''));
                                    DateTime today = DateTime.now();

                                    String displayText = parsedDate.year ==
                                                today.year &&
                                            parsedDate.month == today.month &&
                                            parsedDate.day == today.day
                                        ? 'Today'
                                        : DateFormat(
                                                'EEEE, dd MMMM yyyy', 'id_ID')
                                            .format(parsedDate);

                                    return Container(
                                      width: 320,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryFixed,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayText,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: SizedBox(
                                                  height: 640,
                                                  child:
                                                      buildList(tanggalData)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget buildList(tanggalData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tanggalData.data!.length,
      itemBuilder: (context, detailIndex) {
        var detailData = tanggalData.data![detailIndex];
        double absen = double.parse(detailData.absenht ?? '0');
        double totalabsen = double.parse(detailData.absen ?? '0');
        double persentase = absen / totalabsen * 100;
        String? hexcolor = detailData.warna?.replaceAll('#', '');

        if (hexcolor == '' || hexcolor == null) {
          if (detailData.kodekelas!.startsWith('00')) {
            hexcolor = '9bb192';
          } else if (detailData.kodekelas!.startsWith('0A')) {
            hexcolor = 'd8e08c';
          } else if (detailData.kodekelas!.startsWith('0B')) {
            hexcolor = 'c47ba3';
          } else if (detailData.kodekelas!.startsWith('01')) {
            hexcolor = 'ed4854';
          } else if (detailData.kodekelas!.startsWith('02')) {
            hexcolor = 'f8c48e';
          } else if (detailData.kodekelas!.startsWith('03')) {
            hexcolor = 'eb5bd8';
          } else if (detailData.kodekelas!.startsWith('04')) {
            hexcolor = 'ffe834';
          } else if (detailData.kodekelas!.startsWith('05')) {
            hexcolor = 'f2883b';
          } else if (detailData.kodekelas!.startsWith('06')) {
            hexcolor = 'c7b859';
          } else if (detailData.kodekelas!.startsWith('07')) {
            hexcolor = 'e9f62f';
          } else if (detailData.kodekelas!.startsWith('08')) {
            hexcolor = 'f9c432';
          } else if (detailData.kodekelas!.startsWith('09')) {
            hexcolor = '9aef20';
          } else if (detailData.kodekelas!.startsWith('10')) {
            hexcolor = 'f17c30';
          } else if (detailData.kodekelas!.startsWith('11')) {
            hexcolor = '75f144';
          } else if (detailData.kodekelas!.startsWith('12')) {
            hexcolor = 'ed462f';
          } else if (detailData.kodekelas!.startsWith('13')) {
            hexcolor = 'f17c30';
          }
          // Tambahkan if-else untuk kode kelas lainnya jika diperlukan
        }
        Color color = _hexToColor(hexcolor ?? 'A9A9A9');

        return Column(
          children: [
            Opacity(
              opacity: detailData.isactive == '1' ? 1 : 0.5,
              child: Card(
                shadowColor: Theme.of(context).colorScheme.tertiary,
                color: Theme.of(context).colorScheme.onPrimary,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        color: color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  color: detailData.isactive == '1' &&
                                          detailData.mulaipukul != ''
                                      ? Colors.green
                                      : Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      detailData.isactive == '1' &&
                                              detailData.mulaipukul != ''
                                          ? detailData.mulaipukul!
                                          : detailData.mulai!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  color: detailData.isactive == '1' &&
                                              detailData.status == 'Selesai' ||
                                          detailData.status == 'SUKSES'
                                      ? Colors.blue
                                      : Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      detailData.isactive == '1' &&
                                                  detailData.status ==
                                                      'Selesai' ||
                                              detailData.status == 'SUKSES' &&
                                                  detailData.selesaipukul != ''
                                          ? detailData.selesaipukul!
                                          : detailData.selesai!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            detailData.isactive == '1'
                                ? IconButton(
                                    iconSize: 32,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/form-persiapan-akademik',
                                          arguments: <String, dynamic>{
                                            'id_akademik':
                                                detailData.idakademik,
                                            'kode_akademik':
                                                detailData.kodeakademik,
                                            'tahun_ajaran':
                                                detailData.tahunajaran,
                                            'semester': detailData.semester,
                                            'nama_kelas': detailData.namakelas,
                                            'nama_pelajaran':
                                                detailData.namapelajaran,
                                            'nama_lengkap':
                                                detailData.namalengkap,
                                            'tanggal': detailData.tanggal,
                                            'mulai': detailData.mulai,
                                            'selesai': detailData.selesai,
                                          });
                                    },
                                    icon: Icon(
                                      Icons.pending,
                                      color: detailData.isactive == '1'
                                          ? Colors.white
                                          : Colors.black,
                                    ))
                                : IconButton(
                                    color: detailData.isactive == '1'
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                    iconSize: 32,
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('SISKO'),
                                            content: const Text(
                                                'Lanjutkan membuat agenda akademik ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  final user = Provider.of<
                                                          SqliteUserProvider>(
                                                      context,
                                                      listen: false);
                                                  var id = user
                                                      .currentuser.siskonpsn;
                                                  var tokenss =
                                                      user.currentuser.tokenss;

                                                  if (id != null &&
                                                      tokenss != null) {
                                                    try {
                                                      showLoadingDialog(
                                                          context);
                                                      await AkademikService()
                                                          .addAkademik(
                                                        id: id,
                                                        tokenss: tokenss,
                                                        action: 'add',
                                                        kodemengajar: detailData
                                                                .kodemengajar ??
                                                            '',
                                                        kodepelajaran: detailData
                                                                .kodepelajaran ??
                                                            '',
                                                        kodekelas: detailData
                                                                .kodekelas ??
                                                            '',
                                                        tanggal: detailData
                                                                .tanggal ??
                                                            '',
                                                        mulai:
                                                            detailData.mulai ??
                                                                '',
                                                        selesai: detailData
                                                                .selesai ??
                                                            '',
                                                        jamke:
                                                            detailData.jamke ??
                                                                '',
                                                        jumlahjam: detailData
                                                                .jumlahjam ??
                                                            '',
                                                        faslitiaslain: '',
                                                        komputer: '',
                                                        menitjam: '',
                                                        proyektor: '',
                                                        idlokasi: '0',
                                                      );
                                                      context
                                                          .read<
                                                              AkademikProvider>()
                                                          .getAkademik(
                                                              id: id,
                                                              tokenss: tokenss);
                                                      Navigator.of(context)
                                                          .pop();
                                                    
                                                      // ignore: use_build_cont ext_synchron ously, use_build_context_synchronously, use_build_context_synchronously, use_build_context_synchronously
                                                      final scaffold =
                                                          ScaffoldMessenger.of(
                                                              context);
                                                      scaffold.showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          content: Text(
                                                              'Berhasil ditambahkan',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary)),
                                                        ),
                                                      );

                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      return;
                                                    }
                                                  }
                                                },
                                                child: const Text('Ya'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Tidak'),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          detailData.namapelajaran!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          detailData.namakelas!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      detailData.absen != '' &&
                              detailData.absenht != '' &&
                              detailData.absen != '0' &&
                              detailData.absenht != '0'
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.people_alt_outlined),
                                      Text(
                                          '${detailData.absenht}/${detailData.absen} ${persentase.toStringAsFixed(0)}%')
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      detailData.status == 'SUKSES'
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailData.materi != ''
                                      ? Text('Materi : ${detailData.materi}')
                                      : const SizedBox.shrink(),
                                  detailData.tugas != ''
                                      ? Text('Tugas : ${detailData.tugas}')
                                      : const SizedBox.shrink(),
                                  detailData.hambatan != ''
                                      ? Text(
                                          'Hambatan : ${detailData.hambatan}')
                                      : const SizedBox.shrink(),
                                  detailData.persiapanselanjutnya != ''
                                      ? Text(
                                          'Persiapan Selanjutnya : ${detailData.persiapanselanjutnya}')
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      detailData.isactive == '1'
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailData.deskripsimenarik != ''
                                      ? Text(
                                          'Materi Persiapan: ${detailData.deskripsimenarik ?? ''}')
                                      : const SizedBox.shrink(),
                                  detailData.halpersiapan != ''
                                      ? Text(
                                          'Persiapan Siswa: ${detailData.halpersiapan ?? ''}')
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      detailData.isactive == '1'
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  detailData.status == 'SUKSES'
                                      ? const Card(
                                          color: Colors.green,
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'SUKSES',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : detailData.status == 'Selesai'
                                          ? const Card(
                                              color: Colors.blue,
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Selesai',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : detailData.status == 'Mulai'
                                              ? Card(
                                                  color: Colors.green.shade800,
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Mulai',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : detailData.status ==
                                                      'Konfirmasi'
                                                  ? const Card(
                                                      color: Colors.amber,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          'Konfirmasi',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : detailData.status == 'Batal'
                                                      ? const Card(
                                                          color: Colors.red,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Text(
                                                              'Batal',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                  IconButton(
                                      iconSize: 32,
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('SISKO'),
                                              content: const Text(
                                                  'Yakin akan menghapus data ini?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    final user = Provider.of<
                                                            SqliteUserProvider>(
                                                        context,
                                                        listen: false);
                                                    AkademikService service =
                                                        AkademikService();
                                                    var id = user
                                                        .currentuser.siskonpsn;
                                                    var tokenss = user
                                                        .currentuser.tokenss;

                                                    if (id != null &&
                                                        tokenss != null) {
                                                      try {
                                                        showLoadingDialog(
                                                            context);
                                                        await service
                                                            .delAkademik(
                                                          id: id,
                                                          tokenss: tokenss,
                                                          action: 'del',
                                                          idakademik: detailData
                                                                  .idakademik ??
                                                              '',
                                                        );
                                                        context
                                                            .read<
                                                                AkademikProvider>()
                                                            .getAkademik(
                                                                id: id,
                                                                tokenss:
                                                                    tokenss);
                                                        Navigator.of(context)
                                                            .pop();
                                                        
                                                        final scaffold =
                                                            ScaffoldMessenger
                                                                .of(context);
                                                        scaffold.showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                            content: Text(
                                                                'Berhasil dihapus',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary)),
                                                          ),
                                                        );

                                                        Navigator.of(context)
                                                            .pop();
                                                      } catch (e) {
                                                        return;
                                                      }
                                                    }
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Tidak'),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                      )),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      },
    );
  }
}
