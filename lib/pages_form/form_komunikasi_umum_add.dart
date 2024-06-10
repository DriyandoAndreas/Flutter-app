import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/komunikasi_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/komunikasi_service.dart';

class FormKomunikasiUmumAdd extends StatefulWidget {
  const FormKomunikasiUmumAdd({super.key});

  @override
  State<FormKomunikasiUmumAdd> createState() => _FormKomunikasiUmumAddState();
}

class _FormKomunikasiUmumAddState extends State<FormKomunikasiUmumAdd>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<ListKomunikasiMapelModel> _listMapel = [];
  late List<ListKomunikasiEkskulModel> _listEkskul = [];
  late List<ListKomunikasiKelasModel> _listKelas = [];
  late List<ListKomunikasiKelompokModel> _listKelompok = [];
  late List<ListKomunikasiSiswaModel> _listSiswa = [];
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
  final int _limit = 30;
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
    await _loadMapel(_limit);
    await _loadEkskul(_limit);
    await _loadKelas(_limit);
    await _loadKelomok();
    await _loadSiswaDefault();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
  Future<void> _loadMapel(int limit) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getMapel(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listMapel = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  //show modal mapel
  void _showMapel() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_listMapel.isEmpty) {
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
                    itemCount: _listMapel.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _listMapel.length) {
                        final mapel = _listMapel[index];
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
                      } else if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
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

  Future<void> _loadEkskul(int limit) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getEkskul(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listEkskul = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  void _showEkskul() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_listEkskul.isEmpty) {
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
                    itemCount: _listEkskul.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _listEkskul.length) {
                        final ekskul = _listEkskul[index];
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
                      } else if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
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

  //load kelas
  Future<void> _loadKelas(int limit) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getKelas(
          id: id,
          tokenss: tokenss.substring(0, 30),
          limit: limit,
        );
        setState(() {
          _listKelas = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  // show modal kelas
  void _showKelas() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_listKelas.isEmpty) {
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
                    itemCount: _listKelas.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _listKelas.length) {
                        final kelas = _listKelas[index];
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
                      } else if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
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

//load kelompok
  Future<void> _loadKelomok() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getKelompok(
          id: id,
          tokenss: tokenss.substring(0, 30),
        );
        setState(() {
          _listKelompok = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  // show modal kelompok
  void _showKelompok() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_listKelompok.isEmpty) {
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
                    itemCount: _listKelompok.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _listKelompok.length) {
                        final kelompok = _listKelompok[index];
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
                      } else if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
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

  //load siswa
  Future<void> _loadSiswa(String? kodeKelas) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await KomunikasiService().getSiswa(
          id: id,
          tokenss: tokenss.substring(0, 30),
          kodeKelas: kodeKelas ?? '',
        );
        setState(() {
          _listSiswa = paginatedList;
          _isLoading = false;
          _selectedSiswa.clear(); // clear the list before filling it
          isCheckedList = List.generate(_listSiswa.length, (index) {
            bool isChecked = true; // default to true
            if (isChecked) {
              _selectedSiswa.add(_listSiswa[index].nis ?? '');
            }
            return isChecked;
          });
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  //load all siswa
  Future<void> _loadSiswaDefault() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
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
      throw Exception('Failed to load list $e');
    }
  }

  //load siswa by kelompok
  Future<void> _loadKelompokSiswa(String? idKelompok) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
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
      throw Exception('Failed to load list $e');
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
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_listSiswa.isEmpty) {
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
                        itemCount: _listSiswa.length,
                        itemBuilder: (BuildContext context, int index) {
                          final siswa = _listSiswa[index];
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
  }

  //show all siswa
  void _showSiswaDefault() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
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
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                  if (_selectedKelas != null) {
                    await _loadSiswa(_selectedKelas);
                    _showSiswa();
                  } else if (_selectedKelompok != null) {
                    await _loadKelompokSiswa(_selectedKelompok);
                    _showKelompokSiswa();
                  }
                },
                // ignore: unnecessary_string_interpolations
                child: _selectedKelas == null && _selectedKelompok == null
                    ? Text(_getSelectedSiswaText(_selectedSiswaDefault))
                    : _selectedSiswa.isNotEmpty
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
                      hintText: 'Isi pokok bahasan',
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
                    final scaffold = ScaffoldMessenger.of(context);
                    final currentUser = _users.isNotEmpty ? _users.first : null;
                    String? id = currentUser?.siskoid;
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
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await KomunikasiService().addKomunikasiUmum(
                        id: id!,
                        tokenss: tokenss!,
                        action: 'add',
                        tab: 'umum',
                        nis: nis,
                        jenis: selectedJenis.toString(),
                        kodeP: kodeP,
                        kodeE: kodeE,
                        tanggal: _formatDate(_selectedDate),
                        bahasan: bahasan.text,
                        catatanKel: catatan.text,
                        kodePegawai: kodePegawai ?? '',
                      );
                      scaffold.showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil disimpan'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
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
