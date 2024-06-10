import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/presensi_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/providers/presensi_provider.dart';
import 'package:sisko_v5/services/presensi_service.dart';

class DetailPresensiOpen extends StatefulWidget {
  const DetailPresensiOpen({super.key});

  @override
  State<DetailPresensiOpen> createState() => _DetailPresensiOpenState();
}

class _DetailPresensiOpenState extends State<DetailPresensiOpen> {
  String todayformat = '';
  String todayformatform = '';
  bool isLoading = false;
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
      throw Exception('Gagal mengambil data dari sqlite');
    }
  }

  Future<void> loadListSiswa(String kodeKelas) async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final lists = await PresensiService().getKelasOpen(
          id: id,
          tokenss: tokenss.substring(0, 30),
          kodeKelas: kodeKelas,
        );

        setState(() {
          _listSiswa = lists
              .map((siswa) => PresensiKelasOpenModel(
                    namaLengkap: siswa.namaLengkap,
                    nis: siswa.nis,
                    absen: _getfullAbsen(siswa.absen ?? 'Hadir'),
                    shortAbsen: siswa.absen ?? 'H',
                  ))
              .toList();
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('gagal load list $e');
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
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskoid;
    String? tokenss = currentUser?.tokenss;
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
          Container(
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
                  await PresensiService().addPresensi(
                      id: id!,
                      tokenss: tokenss!,
                      action: 'edit',
                      tanggal: todayformatform,
                      nis: nis,
                      jenisAbsen: jenisAbsen,
                      mode: 'presensi');
                  scaffold.showSnackBar(
                    SnackBar(
                      content: const Text('Absen berhasil disimpan'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        // ignore: use_build_context_synchronously
                        bottom:
                            // ignore: use_build_context_synchronously
                            MediaQuery.of(context).size.height - 150,
                        left: 15,
                        right: 15,
                      ),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    context
                        .read<PresensiProvider>()
                        .refresh(id: id, tokenss: tokenss);
                    Navigator.of(context).pop();
                  });
                  setState(() {
                    isLoading = false;
                  });
                } catch (e) {
                  throw Exception(e);
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildList() {
    double width = MediaQuery.of(context).size.width;
    if (_listSiswa.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _listSiswa.length,
        itemBuilder: (context, index) {
          final listsSiswa = _listSiswa[index];

          return Column(
            children: [
              ListTile(
                onTap: () {
                  showModalBottomSheet(
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
                                    activeColor: Colors.blue,
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
                                    activeColor: Colors.blue,
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
                                    activeColor: Colors.blue,
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
                                    activeColor: Colors.blue,
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
                                    activeColor: Colors.blue,
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
                    style: const TextStyle(
                        color: Color.fromARGB(255, 121, 120, 120))),
              ),
              const Divider(
                thickness: 0.1,
              ),
            ],
          );
        },
      );
    }
  }
}
