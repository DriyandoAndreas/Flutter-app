import 'package:flutter/material.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/jadwal_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/jadwal_service.dart';

class ListShowJamPelajaran extends StatefulWidget {
  const ListShowJamPelajaran({super.key});

  @override
  State<ListShowJamPelajaran> createState() => _ListShowJamPelajaranState();
}

class _ListShowJamPelajaranState extends State<ListShowJamPelajaran> {
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  JadwalService jadwalService = JadwalService();
  late Future<void> initDataFuture;
  Future<List<DetailJadwalHarian>>? futureJadwal;
  late List<ListMengajarModel> _listMengajar = [];
  late List<bool> isCheckedList = [];
  bool _isLoading = false;
  String? selectedMengajar;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    initDataFuture = _initData();
    initMengajar();
  }

  Future<void> initMengajar() async {
    await _loadUsers();
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      JadwalKelaslModel kelas =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
      var kodeKelas = kelas.kodeKelas;

      await _loadMengajar(kodeKelas!);
    }
  }

  Future<void> _initData() async {
    await _loadUsers();
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

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      throw Exception('Failed to fetch data from SQLite');
    }
  }

  Future<void> _loadList(String? param3) async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        var response = await jadwalService.getListJadwalHarian(
          id: id,
          tokenss: tokenss,
          param3: param3 ?? '',
        );

        setState(() {
          futureJadwal = Future.value(response.isNotEmpty ? response : []);
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  Future<void> _loadMengajar(String param3) async {
    try {
      setState(() {
        _isLoading = true; // Set loading state
      });
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final listMengajar = await JadwalService().getListMengajar(
          id: id,
          tokenss: tokenss,
          param3: param3,
        );
        setState(() {
          _listMengajar = listMengajar;
          isCheckedList = List<bool>.filled(listMengajar.length, false);

          _isLoading = false; // Unset loading state
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Unset loading state
      });
      throw Exception('Failed to load list $e');
    }
  }

  Future<void> _refreshList() async {
    try {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        JadwalKelaslModel kelas =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as JadwalKelaslModel;
        var kodeKelas = kelas.kodeKelas;

        await _loadList(kodeKelas!);
      }
    } catch (e) {
      throw Exception('Failed to reload $e');
    } finally {}
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
                final id = _users.isNotEmpty ? _users.first.siskoid : null;
                final tokenss = _users.isNotEmpty ? _users.first.tokenss : null;
                String jadwal = '$kodeKelas][$day][$hour';
                if (id != null && tokenss != null) {
                  try {
                    await JadwalService().addJadwal(
                        id: id,
                        tokenss: tokenss.substring(0, 30),
                        action: 'jadwal',
                        jdwl: jadwal,
                        kodeMengajar: kodeMengajar ?? '');
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil di ubah'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin:
                            EdgeInsets.only(bottom: 150, left: 15, right: 15),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _refreshList();
                  } catch (e) {
                    throw Exception('$e');
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

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? kodePegawai = currentUser?.siskokode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Jadwal'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<void>(
          future: initDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (futureJadwal == null) {
              return ListView.builder(
                itemCount: 7,
                itemBuilder: (context, dayIndex) {
                  String day = (dayIndex + 1).toString();
                  String dayName = '';
                  switch (day) {
                    case '1':
                      dayName = 'Senin';
                      break;
                    case '2':
                      dayName = 'Selasa';
                      break;
                    case '3':
                      dayName = 'Rabu';
                      break;
                    case '4':
                      dayName = 'Kamis';
                      break;
                    case '5':
                      dayName = 'Jumat';
                      break;
                    case '6':
                      dayName = 'Sabtu';
                      break;
                    case '7':
                      dayName = 'Minggu';
                      break;
                    default:
                  }
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
                          color: Colors.grey.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  var kkelas = '';
                                  if (ModalRoute.of(context)!
                                          .settings
                                          .arguments !=
                                      null) {
                                    JadwalKelaslModel kelas =
                                        // ignore: use_build_context_synchronously
                                        ModalRoute.of(context)!
                                            .settings
                                            .arguments as JadwalKelaslModel;
                                    var kodeKelas = kelas.kodeKelas;
                                    kkelas = kodeKelas!;
                                  }
                                  // _showMengajar();
                                  showModalBottomSheet(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (BuildContext context) {
                                      if (_isLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (_listMengajar.isEmpty) {
                                        return const Center(
                                          child: Text('No data available'),
                                        );
                                      } else {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          height: 400,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      _listMengajar.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    if (index <
                                                        _listMengajar.length) {
                                                      final mengajar =
                                                          _listMengajar[index];
                                                      return RadioListTile<
                                                          String>(
                                                        title: Text(mengajar
                                                                .namaPelajaran ??
                                                            ''),
                                                        value: mengajar
                                                                .kodeMengajar ??
                                                            '',
                                                        groupValue:
                                                            selectedMengajar,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedMengajar =
                                                                value!;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          addJadwalHarian(
                                                              context,
                                                              kkelas,
                                                              selectedMengajar,
                                                              day,
                                                              hour);
                                                        },
                                                      );
                                                    } else if (_isLoading) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
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
                                              color: Colors.white,
                                              fontSize: 11),
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
            return FutureBuilder<List<DetailJadwalHarian>>(
              future: futureJadwal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                }

                List<DetailJadwalHarian>? details = snapshot.data;
                return ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, dayIndex) {
                    String day = (dayIndex + 1).toString();
                    String dayName = '';
                    switch (day) {
                      case '1':
                        dayName = 'Senin';
                        break;
                      case '2':
                        dayName = 'Selasa';
                        break;
                      case '3':
                        dayName = 'Rabu';
                        break;
                      case '4':
                        dayName = 'Kamis';
                        break;
                      case '5':
                        dayName = 'Jumat';
                        break;
                      case '6':
                        dayName = 'Sabtu';
                        break;
                      case '7':
                        dayName = 'Minggu';
                        break;
                      default:
                    }
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
                          DetailJadwalHarian detail = details!.firstWhere(
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
                          return Container(
                            color: Colors.grey.shade100,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: detail.kodeMengajar == null
                                      ? () {
                                          var kkelas = '';
                                          // ignore: use_build_context_synchronously
                                          if (ModalRoute.of(context)!
                                                  .settings
                                                  .arguments !=
                                              null) {
                                            JadwalKelaslModel kelas =
                                                // ignore: use_build_context_synchronously
                                                ModalRoute.of(context)!
                                                        .settings
                                                        .arguments
                                                    as JadwalKelaslModel;
                                            var kodeKelas = kelas.kodeKelas;
                                            kkelas = kodeKelas!;
                                          }
                                          showModalBottomSheet(
                                            // ignore: use_build_context_synchronously
                                            context: context,
                                            builder: (BuildContext context) {
                                              if (_isLoading) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (_listMengajar
                                                  .isEmpty) {
                                                return const Center(
                                                  child:
                                                      Text('No data available'),
                                                );
                                              } else {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  height: 400,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _listMengajar
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            if (index <
                                                                _listMengajar
                                                                    .length) {
                                                              final mengajar =
                                                                  _listMengajar[
                                                                      index];
                                                              return RadioListTile<
                                                                  String>(
                                                                title: Text(
                                                                    mengajar.namaPelajaran ??
                                                                        ''),
                                                                value: mengajar
                                                                        .kodeMengajar ??
                                                                    '',
                                                                groupValue:
                                                                    selectedMengajar,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    selectedMengajar =
                                                                        value!;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                  addJadwalHarian(
                                                                      context,
                                                                      kkelas,
                                                                      selectedMengajar,
                                                                      day,
                                                                      hour);
                                                                },
                                                              );
                                                            } else if (_isLoading) {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        }
                                      : null,
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      detail.namaPljrn != null
                                          ? Text(detail.namaPljrn!)
                                          : const Row(
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
                                    ],
                                  ),
                                  subtitle: Text(detail.namaPengajar ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      detail.kodePegawai == kodePegawai
                                          ? Card(
                                              color: Colors.blue,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  'Jam ke-$hour',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            )
                                          : detail.namaPljrn != null
                                              ? Card(
                                                  color: Colors.red,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text(
                                                      'Jam ke-$hour',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11),
                                                    ),
                                                  ),
                                                )
                                              : Card(
                                                  color: Colors.grey,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text(
                                                      'Jam ke-$hour',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11),
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
              },
            );
          },
        ),
      ),
    );
  }
}
