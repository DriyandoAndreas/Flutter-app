import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class FormKomunikasiUmumAdd extends StatefulWidget {
  const FormKomunikasiUmumAdd({super.key});

  @override
  State<FormKomunikasiUmumAdd> createState() => _FormKomunikasiUmumAddState();
}

class _FormKomunikasiUmumAddState extends State<FormKomunikasiUmumAdd> {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<ListKomunikasiSiswaModel> _listSiswaKelompok = [];
  late List<ListKomunikasiSiswaModel> _listSiswaDefault = [];
  late List<bool> isCheckedListSiswaDefault = [];
  late List<bool> isCheckedListSiswaKelompok = [];
  late List<bool> isCheckedList = [];
  final List<String> _selectedSiswa = [];
  final List<String> _selectedKelompokSiswa = [];
  final List<String> _selectedSiswaDefault = [];

  TextEditingController bahasan = TextEditingController();
  TextEditingController catatan = TextEditingController();

  String? _selectedMapel;
  String? _selectedEkskul;
  String? _selectedKelompok;
  String? _selectedOption;
  String? _selectedKelas;

  DateTime? _selectedDate;
  bool isKelas = false;
  bool isKelompok = false;
  bool isLoading = false;
  int selectedJenis = 1;
  bool _isLoading = false;

  List<String> list = <String>['Mata Pelajaran', 'Ekstrakurikuler'];
  String dropItem = 'Mata Pelajaran';

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadMapel();
    await _loadEkskul();
    await _loadKelas();
    await _loadKelompok();
    await _loadSiswaDefault();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
                brightness: context.watch<ThemeSwitchProvider>().isDark
                    ? Brightness.dark
                    : Brightness.light,
                colorScheme: context.watch<ThemeSwitchProvider>().isDark
                    ? ColorScheme.dark(
                        surface: Colors.grey.shade900, primary: Colors.white)
                    : const ColorScheme.light(
                        surface: Colors.white, primary: Colors.black),
                dialogBackgroundColor:
                    context.watch<ThemeSwitchProvider>().isDark
                        ? Colors.black
                        : Colors.white),
            child: child!);
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //load mapel
  Future<void> _loadMapel() async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initListMapel(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  //show modal mapel
  void _showMapel() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listMapel, child) {
            if (listMapel.listMapel.isEmpty) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listMapel.hasMore
                            ? listMapel.listMapel.length + 1
                            : listMapel.listMapel.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < listMapel.listMapel.length) {
                            final mapel = listMapel.listMapel[index];
                            return RadioListTile<String>(
                              title: Text(mapel.namaMapel ?? ''),
                              value: mapel.kodeMapel ?? '',
                              groupValue: _selectedMapel,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedMapel = value!;
                                });
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
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
    );
  }

  Future<void> _loadEkskul() async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initListEkskul(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  void _showEkskul() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listEkskul, child) {
            if (listEkskul.listEkskul.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listEkskul.hasMore
                            ? listEkskul.listEkskul.length + 1
                            : listEkskul.listEkskul.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < listEkskul.listEkskul.length) {
                            final ekskul = listEkskul.listEkskul[index];
                            return RadioListTile<String>(
                              title: Text(ekskul.ekskul ?? ''),
                              value: ekskul.ekskul ?? '',
                              groupValue: _selectedEkskul,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedEkskul = value!;
                                });
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
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
    );
  }

  //load kelas
  Future<void> _loadKelas() async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initListKelas(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  // show modal kelas
  void _showKelas() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listKelas, child) {
            if (listKelas.listKelas.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listKelas.hasMore
                            ? listKelas.listKelas.length + 1
                            : listKelas.listKelas.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < listKelas.listKelas.length) {
                            final kelas = listKelas.listKelas[index];
                            return RadioListTile<String>(
                              title: Text(kelas.namaKelas ?? ''),
                              value: kelas.kodeKelas ?? '',
                              groupValue: _selectedKelas,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedKelas = value!;
                                });
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
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
    );
  }

//load kelompok
  Future<void> _loadKelompok() async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<KomunikasiProvider>()
            .initInfinitListKelompok(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  // show modal kelompok
  void _showKelompok() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listKelompok, child) {
            if (listKelompok.listKelompok.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listKelompok.listKelompok.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < listKelompok.listKelompok.length) {
                            final kelompok = listKelompok.listKelompok[index];
                            return RadioListTile<String>(
                              title: Text(kelompok.namaKelompok ?? ''),
                              value: kelompok.idKelompok ?? '',
                              groupValue: _selectedKelompok,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedKelompok = value!;
                                });
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
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
    );
  }

  //load siswa
  Future<void> _loadSiswa(String? kodeKelas) async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        context.read<KomunikasiProvider>().initInfinitListSiswa(
            id: id, tokenss: tokenss, kodeKelas: kodeKelas!);

        final siswa = Provider.of<KomunikasiProvider>(context, listen: false);
        setState(() {
          _selectedSiswa.clear();
          isCheckedList = List.generate(
            siswa.listSiswa.length,
            (index) {
              bool isChecked = true;
              if (isChecked) {
                _selectedSiswa.add(siswa.listSiswa[index].nis ?? '');
              }
              return isChecked;
            },
          );
        });
      }
    } catch (e) {
      return;
    }
  }

  //load all siswa
  Future<void> _loadSiswaDefault() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getAllSiswa(
          id: id,
          tokenss: tokenss.substring(0, 30),
        );
        setState(() {
          _listSiswaDefault = paginatedList;
          _isLoading = false;
          _selectedSiswaDefault.clear();
          isCheckedListSiswaDefault =
              List.generate(_listSiswaDefault.length, (index) {
            bool isChecked = true; // default to true
            if (isChecked) {
              _selectedSiswaDefault.add(_listSiswaDefault[index].nis ?? '');
            }
            return isChecked;
          });
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      return;
    }
  }

  //load siswa by kelompok
  Future<void> _loadKelompokSiswa(String? idKelompok) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getSiswaKelompok(
          id: id,
          tokenss: tokenss.substring(0, 30),
          idKelompok: idKelompok ?? '',
        );
        setState(() {
          _listSiswaKelompok = paginatedList;
          _isLoading = false;
          _selectedKelompokSiswa.clear();
          isCheckedListSiswaKelompok =
              List.generate(_listSiswaKelompok.length, (index) {
            bool isChecked = true; // default to true
            if (isChecked) {
              _selectedKelompokSiswa.add(_listSiswaKelompok[index].nis ?? '');
            }
            return isChecked;
          });
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      return;
    }
  }

  //get selected siswa
  String _getSelectedSiswaText(List<String> siswa) {
    if (siswa.isEmpty) {
      return 'Pilih siswa';
    } else if (siswa.length == 1) {
      return siswa.first;
    } else {
      return '${siswa.first}...';
    }
  }

  //show siswa by kelas
  void _showSiswa() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listSiswa, child) {
            isCheckedList = List.generate(
              listSiswa.listSiswa.length,
              (index) {
                bool isChecked = true;
                if (isChecked) {
                  _selectedSiswa.add(listSiswa.listSiswa[index].nis ?? '');
                  return isChecked;
                }
              },
            );
            if (listSiswa.listSiswa.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8),
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ListView.builder(
                            itemCount: listSiswa.hasMore
                                ? listSiswa.listSiswa.length + 1
                                : listSiswa.listSiswa.length,
                            itemBuilder: (BuildContext context, int index) {
                              final siswa = listSiswa.listSiswa[index];
                              return CheckboxListTile(
                                title: Text(siswa.namaSiswa ?? ''),
                                value: isCheckedList[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedList[index] = value ?? false;
                                    if (value == true) {
                                      _selectedSiswa.add(siswa.nis ?? '');
                                    } else {
                                      _selectedSiswa.remove(siswa.nis);
                                    }
                                    this.setState(() {});
                                  });
                                },
                              );
                            },
                          );
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
    );
  }

  //show all siswa
  void _showSiswaDefault() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_listSiswaDefault.isEmpty) {
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
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return ListView.builder(
                        itemCount: _listSiswaDefault.length,
                        itemBuilder: (BuildContext context, int index) {
                          final siswa = _listSiswaDefault[index];
                          return CheckboxListTile(
                            title: Text(siswa.namaSiswa ?? ''),
                            value: isCheckedListSiswaDefault[index],
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedListSiswaDefault[index] =
                                    value ?? false;
                                if (value == true) {
                                  _selectedSiswaDefault.add(siswa.nis ?? '');
                                } else {
                                  _selectedSiswaDefault.remove(siswa.nis);
                                }
                                this.setState(() {});
                              });
                            },
                          );
                        },
                      );
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

// show siswa by kelompok
  void _showKelompokSiswa() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_listSiswaKelompok.isEmpty) {
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
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return ListView.builder(
                        itemCount: _listSiswaKelompok.length,
                        itemBuilder: (BuildContext context, int index) {
                          final siswa = _listSiswaKelompok[index];
                          return CheckboxListTile(
                            title: Text(siswa.namaSiswa ?? ''),
                            value: isCheckedListSiswaKelompok[index],
                            onChanged: (bool? value) {
                              setState(() {
                                isCheckedListSiswaKelompok[index] =
                                    value ?? false;
                                if (value == true) {
                                  _selectedKelompokSiswa.add(siswa.nis ?? '');
                                } else {
                                  _selectedKelompokSiswa.remove(siswa.nis);
                                }
                                this.setState(() {});
                              });
                            },
                          );
                        },
                      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Komunikasi'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jenis'),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropItem,
                  isExpanded: true,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropItem = value!;
                      if (dropItem == 'Mata Pelajaran') {
                        selectedJenis = 1;
                      } else {
                        selectedJenis = 2;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                onPressed: () {
                  if (selectedJenis == 1) {
                    _showMapel();
                  } else {
                    _showEkskul();
                  }
                },
                child: Text(selectedJenis == 1
                    ? '${_selectedMapel ?? 'Pilih Mata Pelajaran'} '
                    : '${_selectedEkskul ?? 'Pilih Ekstrakurikuler'} '),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Tanggal'),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(_formatDate(_selectedDate)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              Column(
                children: [
                  RadioListTile(
                    title: const Text('By Kelas'),
                    value: 'By Kelas',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                        isKelas = true;
                        isKelompok = false;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('By Kelompok'),
                    value: 'By Kelompok',
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value!;
                        isKelas = false;
                        isKelompok = true;
                      });
                    },
                  ),
                ],
              ),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                onPressed: () async {
                  if (!isKelas && !isKelompok) {
                    _showSiswaDefault();
                  } else if (isKelas) {
                    _showKelas();
                  } else if (isKelompok) {
                    _showKelompok();
                  }
                },
                child: !isKelas && !isKelompok
                    ? const Text('Pilih Siswa')
                    : Text(isKelas
                        // ignore: unnecessary_string_interpolations
                        ? '${_selectedKelas ?? 'Pilih Kelas'}'
                        // ignore: unnecessary_string_interpolations
                        : '${_selectedKelompok ?? 'Pilih Kelompok'}'),
              ),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                onPressed: () async {
                  switch (_selectedOption) {
                    case 'By Kelas':
                      if (_selectedKelas != null) {
                        await _loadSiswa(_selectedKelas);
                        _showSiswa();
                      }
                      break;
                    case 'By Kelompok':
                      if (_selectedKelompok != null) {
                        await _loadKelompokSiswa(_selectedKelompok);
                        _showKelompokSiswa();
                      }
                      break;
                    default:
                  }
                },
                // ignore: unnecessary_string_interpolations
                child: _selectedKelas == null && _selectedKelompok == null
                    ? Text(_getSelectedSiswaText(_selectedSiswaDefault))
                    : isKelas
                        ? Text(_getSelectedSiswaText(_selectedSiswa))
                        : Text(_getSelectedSiswaText(_selectedKelompokSiswa)),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Pokok Bahasan'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: bahasan,
                  decoration: const InputDecoration(
                      hintText: 'Isi pokok bahasan',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Catatan Kelas / Kelompok'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: catatan,
                  decoration: const InputDecoration(
                      hintText: 'Isi Catatan',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    try {
                      final scaffold = ScaffoldMessenger.of(context);
                      final currentUser =
                          _users.isNotEmpty ? _users.first : null;
                      String? id = currentUser?.siskonpsn;
                      String? tokenss = currentUser?.tokenss;
                      String? kodePegawai = currentUser?.siskokode;
                      String kodeP = '';
                      String kodeE = '';
                      List<String> nis = [];
                      if (_selectedSiswa.isNotEmpty) {
                        nis = _selectedSiswa;
                      } else {
                        nis = _selectedKelompokSiswa;
                      }
                      if (selectedJenis == 1) {
                        kodeP = _selectedMapel ?? '';
                      } else {
                        kodeE = _selectedEkskul ?? '';
                      }
                      if (id != null &&
                          tokenss != null &&
                          kodePegawai != null) {
                        if (_selectedMapel == null) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Pilih mapel / ekskul',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                        } else if (_selectedDate == null) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Pilih tanggal',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                        } else if (bahasan.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Isi bahasan',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                        } else if (catatan.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Isi catatan',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          await KomunikasiService().addKomunikasiUmum(
                            id: id,
                            tokenss: tokenss.substring(0, 30),
                            action: 'add',
                            tab: 'umum',
                            nis: nis,
                            jenis: selectedJenis.toString(),
                            kodeP: kodeP,
                            kodeE: kodeE,
                            tanggal: _formatDate(_selectedDate),
                            bahasan: bahasan.text,
                            catatanKel: catatan.text,
                            kodePegawai: kodePegawai,
                          );
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Berhasil disimpan',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            // ignore: use_build_context_synchronously
                            context.read<KomunikasiProvider>().refreshListUmum(
                                id: id, tokenss: tokenss.substring(0, 30));
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          });
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    } catch (e) {
                      return;
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
