import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/komunikasi_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/komunikasi_service.dart';

class FormEditKomunikasiUmum extends StatefulWidget {
  const FormEditKomunikasiUmum({super.key});

  @override
  State<FormEditKomunikasiUmum> createState() => _FormEditKomunikasiUmumState();
}

class _FormEditKomunikasiUmumState extends State<FormEditKomunikasiUmum>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late KomunikasiUmumModel listUmum;

  late List<SqliteUserModel> _users = [];
  late List<ListKomunikasiMapelModel> _listMapel = [];
  late List<ListKomunikasiEkskulModel> _listEkskul = [];
  late List<bool> isCheckedListSiswaDefault = [];
  late List<bool> isCheckedListSiswaKelompok = [];
  late List<bool> isCheckedList = [];
  late List<String> _selectedSiswaDefault = [listUmum.nis!];

  late TextEditingController bahasan =
      TextEditingController(text: listUmum.bahasan);
  late TextEditingController catatan =
      TextEditingController(text: listUmum.catatanKel);

  late String? _selectedMapel = listUmum.mapel;
  String? _selectedEkskul;

  late DateTime? _selectedDate = DateTime.parse(listUmum.tanggal!);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listUmum =
        ModalRoute.of(context)!.settings.arguments as KomunikasiUmumModel;
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadMapel(_limit);
    await _loadEkskul(_limit);
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

  //get selected siswa
  String _getSelectedSiswaText(List<String> siswa) {
    if (siswa.isEmpty) {
      return 'Pilih siswa';
    } else if (siswa.length == 1) {
      return siswa.first;
    } else {
      return siswa.first;
    }
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
              TextButton(
                  onPressed: null,
                  // ignore: unnecessary_string_interpolations
                  child: Text(_getSelectedSiswaText(_selectedSiswaDefault))),
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
                    if (_selectedSiswaDefault.isNotEmpty) {
                      nis = _selectedSiswaDefault;
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
                      await KomunikasiService().editKomunikasiUmum(
                        id: id!,
                        tokenss: tokenss!,
                        action: 'edit',
                        tab: 'umum',
                        nis: nis,
                        jenis: selectedJenis.toString(),
                        kodeP: kodeP,
                        kodeE: kodeE,
                        tanggal: _formatDate(_selectedDate),
                        bahasan: bahasan.text,
                        catatanKel: catatan.text,
                        kodePegawai: kodePegawai ?? '',
                        idUmum: listUmum.idUmum ?? '',
                      );
                      scaffold.showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil diedit'),
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
