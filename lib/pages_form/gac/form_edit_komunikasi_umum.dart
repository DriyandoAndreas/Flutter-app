import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

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
  late List<bool> isCheckedListSiswaDefault = [];
  late List<bool> isCheckedListSiswaKelompok = [];
  late List<bool> isCheckedList = [];
  late final List<String> _selectedSiswaDefault = [listUmum.nis!];

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
    await _loadMapel();
    await _loadEkskul();
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
      initialDate: _selectedDate,
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
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      context: context,
      builder: (BuildContext context) {
        return Consumer<KomunikasiProvider>(
          builder: (context, listMapel, child) {
            if (listMapel.listMapel.isEmpty) {
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
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
                child: Text(_formatDate(_selectedDate),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
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
                  child: Text(_getSelectedSiswaText(_selectedSiswaDefault),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary))),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Pokok Bahasan'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                    try {
                      final scaffold = ScaffoldMessenger.of(context);
                      final currentUser =
                          _users.isNotEmpty ? _users.first : null;
                      var id = currentUser?.siskonpsn;
                      var tokenss = currentUser?.tokenss;
                      var kodePegawai = currentUser?.siskokode;
                      final kodemapel = Provider.of<KomunikasiProvider>(context,
                          listen: false);
                      var datamapel = kodemapel.listMapel.firstWhere(
                        (element) {
                          return element.namaMapel == _selectedMapel;
                        },
                      );
                      if (id != null &&
                          tokenss != null &&
                          kodePegawai != null) {
                        String kodeP = '';
                        String kodeE = '';
                        List<String> nis = [];
                        if (_selectedSiswaDefault.isNotEmpty) {
                          nis = _selectedSiswaDefault;
                        }
                        if (selectedJenis == 1) {
                          kodeP = datamapel.kodeMapel ?? '';
                        } else {
                          kodeE = _selectedEkskul ?? '';
                        }
                        setState(() {
                          isLoading = true;
                        });

                        await KomunikasiService().editKomunikasiUmum(
                          id: id,
                          tokenss: tokenss.substring(0, 30),
                          action: 'edit',
                          tab: 'umum',
                          nis: nis,
                          jenis: selectedJenis.toString(),
                          kodeP: kodeP,
                          kodeE: kodeE,
                          tanggal: _formatDate(_selectedDate),
                          bahasan: bahasan.text,
                          catatanKel: catatan.text,
                          kodePegawai: kodePegawai,
                          idUmum: listUmum.idUmum ?? '',
                        );
                        scaffold.showSnackBar(
                          SnackBar(
                            backgroundColor:
                                // ignore: use_build_context_synchronously
                                Theme.of(context).colorScheme.primary,
                            content: Text('Berhasil diedit',
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
