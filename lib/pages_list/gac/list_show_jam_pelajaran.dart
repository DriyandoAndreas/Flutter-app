import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/jadwal_model.dart';
import 'package:app5/providers/jadwal_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/jadwal_service.dart';

class ListShowJamPelajaran extends StatefulWidget {
  const ListShowJamPelajaran({super.key});

  @override
  State<ListShowJamPelajaran> createState() => _ListShowJamPelajaranState();
}

class _ListShowJamPelajaranState extends State<ListShowJamPelajaran> {
  JadwalService jadwalService = JadwalService();
  String? _selectedMengajar;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initData();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async {
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      JadwalKelaslModel kelas =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
      var kodeKelas = kelas.kodeKelas;
      await _loadList(kodeKelas!);
      await _loadMengajar(kodeKelas);
    }
  }

  Future<void> _loadList(String param3) async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<JadwalProvider>().initJadwalHarian(
              id: id,
              tokenss: tokenss.substring(0, 30),
              param3: param3,
            );
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _loadMengajar(String param3) async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<JadwalProvider>().initMengajar(
              id: id,
              tokenss: tokenss.substring(0, 30),
              param3: param3,
            );
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _refreshList() async {
    try {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        JadwalKelaslModel kelas =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
        var kodeKelas = kelas.kodeKelas;

        final user = Provider.of<SqliteUserProvider>(context, listen: false);
        var id = user.currentuser.siskonpsn;
        var tokenss = user.currentuser.tokenss;
        if (id != null && tokenss != null) {
          context.read<JadwalProvider>().refreshDetailJadwal(
                id: id,
                tokenss: tokenss.substring(0, 30),
                param3: kodeKelas ?? '',
              );
        }
      }
    } catch (e) {
      return;
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

  Future<void> addJadwalHarian(BuildContext context, String? kodeKelas,
      String? kodeMengajar, String day, String hour) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anda Ingin mengubah Jadwal?'),
          content: const Text('Apakah Anda Ingin Jadwal Ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                String jadwal = '$kodeKelas][$day][$hour';
                if (id != null && tokenss != null) {
                  try {
                    showLoadingDialog(context);
                    await JadwalService().addJadwal(
                      id: id,
                      tokenss: tokenss.substring(0, 30),
                      action: 'jadwal',
                      jdwl: jadwal,
                      kodeMengajar: kodeMengajar ?? '',
                    );
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).colorScheme.primary,
                        content: Text('Berhasil di ubah',
                            style: TextStyle(
                                // ignore: use_build_context_synchronously
                                color:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();

                    // ignore: use_build_context_synchronously
                    context.read<JadwalProvider>().initJadwalHarian(
                          id: id,
                          tokenss: tokenss.substring(0, 30),
                          param3: kodeKelas ?? '',
                        );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
  }

  Future<void> deleteJadwalHarian(BuildContext context, String? kodeKelas,
      String? kodeMengajar, String day, String hour) async {
    final scaffold = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anda Ingin Hapus?'),
          content: const Text('Apakah Anda Ingin Hapus Ini?'),
          actions: [
            TextButton(
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                String jadwal = '$kodeKelas][$day][$hour';
                if (id != null && tokenss != null) {
                  try {
                    showLoadingDialog(context);
                    await JadwalService().addJadwal(
                        id: id,
                        tokenss: tokenss.substring(0, 30),
                        action: 'jadwal',
                        jdwl: jadwal,
                        kodeMengajar: '');
                    scaffold.showSnackBar(
                      SnackBar(
                        // ignore: use_build_context_synchronously
                        backgroundColor:
                            // ignore: use_build_context_synchronously
                            Theme.of(context).colorScheme.primary,
                        content: Text('Berhasil di hapus',
                            style: TextStyle(
                                // ignore: use_build_context_synchronously
                                color:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    context.read<JadwalProvider>().initJadwalHarian(
                          id: id,
                          tokenss: tokenss.substring(0, 30),
                          param3: kodeKelas ?? '',
                        );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
  }

  String getDayname(String day) {
    const dayNames = {
      '1': 'Senin',
      '2': 'Selasa',
      '3': 'Rabu',
      '4': 'Kamis',
      '5': 'Jumat',
      '6': 'Sabtu',
      '7': 'Minggu'
    };
    return dayNames[day] ?? '';
  }

  void showMapel(String kkelas, day, hour, jadwals) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(8),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      addJadwalHarian(
                          context, kkelas, _selectedMengajar, day, hour);
                    },
                    child: const Text('Done'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jadwals.listMengajar.length,
                      itemBuilder: (BuildContext context, int index) {
                        final mengajars = jadwals.listMengajar[index];
                        return Column(
                          children: [
                            RadioListTile<String>(
                              title: Text(mengajars.namaPelajaran ?? ''),
                              value: mengajars.kodeMengajar ?? '',
                              groupValue: _selectedMengajar,
                              onChanged: (String? value) {
                                setModalState(() {
                                  _selectedMengajar = value;
                                });
                                setState(() {
                                  _selectedMengajar = value;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    JadwalKelaslModel kelas =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
    var namakelas = kelas.namaKelas;
    var semester = kelas.semester;
    String? kodePegawai = user.currentuser.siskokode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Jadwal'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$namakelas',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '$semester',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshList,
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [Expanded(child: buildList(kodePegawai))],
            )),
      ),
    );
  }

  Widget buildList(kodePegawai) {
    return Consumer<JadwalProvider>(
      builder: (context, jadwals, child) {
        var kkelas = '';
        if (ModalRoute.of(context)!.settings.arguments != null) {
          JadwalKelaslModel kelas =
              // ignore: use_build_context_synchronously
              ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
          kkelas = kelas.kodeKelas!;
        }
        if (jadwals.listJadwalHarian.isEmpty) {
          return emptyList(kodePegawai, kkelas, jadwals);
        } else {
          return filledList(kodePegawai, kkelas, jadwals);
        }
      },
    );
  }

  Widget emptyList(kodePegawai, kkelas, jadwals) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (context, dayIndex) {
        String day = (dayIndex + 1).toString();
        String dayName = getDayname(day);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: Text(dayName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...List.generate(8, (hourIndex) {
              String hour = (hourIndex + 1).toString();

              return Container(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        showMapel(kkelas, day, hour, jadwals);
                      },
                      title: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('[Kosong]'),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
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
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget filledList(kodePegawai, kkelas, jadwals) {
    List<DetailJadwalHarian>? details =
        context.read<JadwalProvider>().listJadwalHarian;
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (context, dayIndex) {
        String day = (dayIndex + 1).toString();
        String dayName = getDayname(day);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: Text(dayName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...List.generate(8, (hourIndex) {
              String hour = (hourIndex + 1).toString();
              DetailJadwalHarian detail = details.firstWhere(
                (d) => d.kodeHariJam == '${day}_$hour',
                orElse: () => DetailJadwalHarian(
                    kodePljrn: null,
                    kodeMengajar: null,
                    thnAj: null,
                    semester: null,
                    kodeHariJam: null,
                    kodeKelas: null,
                    namaPljrn: null,
                    namaPengajar: null),
              );
              final user =
                  Provider.of<SqliteUserProvider>(context, listen: false);
              final isAuthorized =
                  user.currentuser.siskokode == detail.kodePegawai;

              return Container(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  children: [
                    isAuthorized
                        ? Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    deleteJadwalHarian(context, kkelas,
                                        _selectedMengajar, day, hour);
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade800,
                                ),
                              ],
                            ),
                            child: buildListTile(detail, day, hour, kodePegawai,
                                kkelas, jadwals))
                        : buildListTile(
                            detail, day, hour, kodePegawai, kkelas, jadwals),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget buildListTile(detail, day, hour, kodePegawai, kkelas, jadwals) {
    return Consumer<JadwalProvider>(
      builder: (context, provider, child) {
        DetailJadwalHarian updatedDetail = provider.listJadwalHarian.firstWhere(
          (d) => d.kodeHariJam == '${day}_$hour',
          orElse: () => DetailJadwalHarian(
              kodePljrn: '',
              kodeMengajar: '',
              thnAj: '',
              semester: '',
              kodeHariJam: '',
              kodeKelas: '',
              namaPljrn: '',
              namaPengajar: ''),
        );
        return ListTile(
          onTap: updatedDetail.kodeMengajar == ''
              ? () {
                  showMapel(kkelas, day, hour, jadwals);
                }
              : null,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              updatedDetail.namaPljrn == '' && updatedDetail.kodeMengajar == ''
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('[Kosong]'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                      ],
                    )
                  : Text(updatedDetail.namaPljrn ?? '')
            ],
          ),
          subtitle: Text(updatedDetail.namaPengajar ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              updatedDetail.kodePegawai == kodePegawai
                  ? Card(
                      color: Colors.blue,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Jam ke-$hour',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    )
                  : updatedDetail.namaPljrn != ''
                      ? Card(
                          color: Colors.red,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Jam ke-$hour',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ),
                        )
                      : Card(
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
        );
      },
    );
  }
}
