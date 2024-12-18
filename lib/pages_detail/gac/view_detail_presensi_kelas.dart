import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/presensi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/presensi_provider.dart';
import 'package:app5/services/presensi_service.dart';

class DetailPresensiOpen extends StatefulWidget {
  const DetailPresensiOpen({super.key});

  @override
  State<DetailPresensiOpen> createState() => _DetailPresensiOpenState();
}

class _DetailPresensiOpenState extends State<DetailPresensiOpen> {
  String todayformat = '';
  String todayformatform = '';
  bool isLoading = false;
  bool noData = false;
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<PresensiKelasOpenModel> _listSiswa = [];

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    initdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initdata() async {
    await loadUser();
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      PresensiModel presensi =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as PresensiModel;
      var kodeKelas = presensi.kodeKelas;

      await loadListSiswa(kodeKelas!);
    }
  }

  Future<void> loadUser() async {
    try {
      List<SqliteUserModel> users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> loadListSiswa(String kodeKelas) async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        // ignore: use_build_context_synchronously
        await context
            .read<PresensiProvider>()
            .initKelasOpen(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
        // ignore: use_build_context_synchronously
        var datas = context.read<PresensiProvider>().listKelasOpen;
        setState(() {
          _listSiswa = datas
              .map((siswa) => PresensiKelasOpenModel(
                    namaLengkap: siswa.namaLengkap,
                    nis: siswa.nis,
                    absen: _getfullAbsen(siswa.absen ?? 'Hadir'),
                    shortAbsen: siswa.absen ?? 'H',
                    statusLogin: siswa.statusLogin ?? '',
                    file: siswa.file ?? '',
                    keterangan: siswa.keterangan ?? '',
                  ))
              .toList();
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      return;
    }
  }

  void updateAbsen(PresensiKelasOpenModel siswa, String? value) {
    setState(() {
      siswa.absen = value!;
      siswa.shortAbsen = _getshortAbsen(value);
    });
  }

  String _getfullAbsen(String absen) {
    switch (absen) {
      case 'H':
        return 'Hadir';
      case 'S':
        return 'Sakit';
      case 'I':
        return 'Ijin';
      case 'A':
        return 'Alpha';
      case 'T':
        return 'Terlambat';
      default:
        return 'Hadir'; // Default to 'H' for 'Hadir'
    }
  }

  String _getshortAbsen(String absen) {
    switch (absen) {
      case 'Hadir':
        return 'H';
      case 'Sakit':
        return 'S';
      case 'Ijin':
        return 'I';
      case 'Alpha':
        return 'A';
      case 'Terlambat':
        return 'T';
      default:
        return 'H';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime todayform = DateTime.now();
    todayformat = DateFormat("EEE d MMM yyyy").format(today);
    todayformatform = DateFormat("yyyy-MM-dd").format(todayform);
    final PresensiModel presensi =
        ModalRoute.of(context)!.settings.arguments as PresensiModel;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Presensi'),
              Text(
                presensi.namaKelas!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        todayformat,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: const Center(
                            child: Text(
                          "H",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                        child: const Center(
                            child: Text("S",
                                style: TextStyle(color: Colors.white))),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow.shade600),
                        child: const Center(
                            child: Text("I",
                                style: TextStyle(color: Colors.white))),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: const Center(
                            child: Text("A",
                                style: TextStyle(color: Colors.white))),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.brown),
                        child: const Center(
                            child: Text(
                          "T",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.1,
          ),
          Expanded(
            child: buildList(),
          ),
          _listSiswa.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      List<String> nis =
                          _listSiswa.map((siswa) => siswa.nis!).toList();
                      List<String> jenisAbsen =
                          _listSiswa.map((siswa) => siswa.shortAbsen!).toList();

                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final user = Provider.of<SqliteUserProvider>(context,
                            listen: false);
                        var id = user.currentuser.siskonpsn;
                        var tokenss = user.currentuser.tokenss;
                        if (id != null && tokenss != null) {
                          await PresensiService().addPresensi(
                              id: id,
                              tokenss: tokenss,
                              action: 'edit',
                              tanggal: todayformatform,
                              nis: nis,
                              jenisAbsen: jenisAbsen,
                              mode: 'presensi');

                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Absen berhasil disimpan',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            // ignore: use_build_context_synchronously
                            context
                                .read<PresensiProvider>()
                                .refresh(id: id, tokenss: tokenss);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          });
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } catch (e) {
                        return;
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget buildList() {
    return Consumer<PresensiProvider>(
      builder: (context, kelasOpen, child) {
        if (kelasOpen.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (kelasOpen.listKelasOpen.isEmpty) {
          return const Center(
            child: Text('Tidak ada data siswa pada kelas ini'),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _listSiswa.length,
            itemBuilder: (context, index) {
              final listsSiswa = _listSiswa[index];
              var pemohon = 'Orang tua';
              var isOrtu = false;
              var isSakit = false;
              if (listsSiswa.shortAbsen == 'S') {
                isSakit = true;
              }
              if (listsSiswa.statusLogin == 'a' ||
                  listsSiswa.statusLogin == 'i' ||
                  listsSiswa.statusLogin == 'o' ||
                  listsSiswa.statusLogin == 's') {
                isOrtu = true;
              }
              switch (listsSiswa.statusLogin) {
                case 'a':
                  pemohon = 'Ayah';
                  break;
                case 'i':
                  pemohon = 'Ibu';
                  break;
                case 'o':
                  pemohon = 'Orang Tua';
                  break;
                case 's':
                  pemohon = 'Siswa';
                  break;
                default:
              }
              return Column(
                children: [
                  isOrtu
                      ? Slidable(
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              isSakit
                                  ? SlidableAction(
                                      onPressed: (context) async {
                                        Navigator.pushNamed(
                                            context, '/view-surat-sakit',
                                            arguments: listsSiswa);
                                      },
                                      label: 'Lihat Surat Sakit',
                                      icon: Icons.visibility,
                                      backgroundColor: Colors.grey.shade600,
                                    )
                                  : SlidableAction(
                                      onPressed: (context) async {
                                        null;
                                      },
                                      icon: Icons.visibility,
                                      backgroundColor: Colors.grey.shade600,
                                    ),
                            ],
                          ),
                          child:
                              buildListTileOrtu(listsSiswa, pemohon, isSakit))
                      : buildListTile(listsSiswa),
                  const Divider(
                    thickness: 0.1,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildListTile(listsSiswa) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 300,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        RadioListTile<String>(
                          title: const Text('Hadir'),
                          value: 'Hadir',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Sakit'),
                          value: 'Sakit',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Ijin'),
                          value: 'Ijin',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Alpha'),
                          value: 'Alpha',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Terlambat'),
                          value: 'Terlambat',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }).then((selectedStatus) {
          if (selectedStatus != null) {
            setState(() {
              listsSiswa.absen = selectedStatus;
            });
          }
        });
      },
      title: Text(
        listsSiswa.nis!,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        listsSiswa.namaLengkap!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(listsSiswa.absen ?? '',
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
    );
  }

  Widget buildListTileOrtu(listsSiswa, pemohon, isSakit) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 300,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        RadioListTile<String>(
                          title: Text('${listsSiswa.absen}'),
                          value: '${listsSiswa.absen}',
                          groupValue: listsSiswa.absen,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (String? value) {
                            updateAbsen(listsSiswa, value);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }).then((selectedStatus) {
          if (selectedStatus != null) {
            setState(() {
              listsSiswa.absen = selectedStatus;
            });
          }
        });
      },
      title: Text(
        listsSiswa.nis!,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listsSiswa.namaLengkap!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${listsSiswa.keterangan}-$pemohon',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              const SizedBox(
                width: 8,
              ),
              isSakit
                  ? Icon(
                      Icons.mail,
                      size: 20,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
      trailing: Text(listsSiswa.absen ?? '',
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
    );
  }
}
