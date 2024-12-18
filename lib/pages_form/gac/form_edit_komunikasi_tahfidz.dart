import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class FormEditKomunikasiTahfidz extends StatefulWidget {
  const FormEditKomunikasiTahfidz({super.key});

  @override
  State<FormEditKomunikasiTahfidz> createState() =>
      _FormEditKomunikasiTahfidzState();
}

class _FormEditKomunikasiTahfidzState extends State<FormEditKomunikasiTahfidz> {
  TextEditingController bahasan = TextEditingController();
  TextEditingController juz = TextEditingController();
  TextEditingController surat = TextEditingController();
  TextEditingController ayat = TextEditingController();
  TextEditingController ayatTo = TextEditingController();
  TextEditingController sampai = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController nilai = TextEditingController();
  TextEditingController catatan = TextEditingController();
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late ViewKomunikasiTahfidzModel viewdata;
  late List<SqliteUserModel> _users = [];

  late List<bool> isCheckedListSiswaDefault = [];
  late List<bool> isCheckedListSiswaKelompok = [];
  late List<bool> isCheckedList = [];

  List<String> list = <String>['Al Qur\'an', 'Hadist', 'Tahsin/Tajwid'];
  List<String> listJenisHafalan = <String>[
    'Sabaq',
    'Sabqi',
    'Manzil',
    'Ziyadah',
    'Muraja\'ah'
  ];
  List<String> listMetode = <String>['Klasikal', 'Privat'];
  String dropItem = 'Al Qur\'an';
  String dropJenisHafalan = 'Sabaq';
  String dropMetode = 'Klasikal';
  List<String> nis = [];
  int selectedJenis = 1;
  int selectedJenisHafalan = 1;
  int selectedMetode = 1;
  DateTime? _selectedDate;
  bool isKelas = false;
  bool isKelompok = false;
  bool isbyKelas = false;
  bool isbyKelompok = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUsers();
    await _loadView();
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

  Future<void> _loadView() async {
    try {
      final user = _users.isNotEmpty ? _users.first : null;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        KomunikasiTahfidzModel tahfidz =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments
                as KomunikasiTahfidzModel;
        var idc = tahfidz.idTahfidz;
        var id = user?.siskonpsn;
        var tokenss = user?.tokenss;

        if (id != null && tokenss != null && idc != null) {
          await context.read<KomunikasiProvider>().initViewTahfidz(
              id: id, tokenss: tokenss.substring(0, 30), param2: idc);

          // ignore: use_build_context_synchronously
          var datas = context.read<KomunikasiProvider>().viewData;

          setState(() {
            _selectedDate = DateTime.parse(datas.tanggal ?? '');
            juz.text = datas.juz ?? '';
            surat.text = datas.surat ?? '';
            ayat.text = datas.ayat ?? '';
            ayatTo.text = datas.ayatTo ?? '';
            jumlah.text = datas.jumlah ?? '';
            nilai.text = datas.nilai ?? '';
            bahasan.text = datas.catatan ?? '';
            catatan.text = datas.catatanKel ?? '';
            nis.add(datas.nis ?? '');
          });
        }
      }
    } catch (e) {
      return;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return DateFormat('yyyy-MM-dd').format(date);
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

  @override
  Widget build(BuildContext context) {
    KomunikasiTahfidzModel tahfidz =
        // ignore: use_build_context_synchronously
        ModalRoute.of(context)!.settings.arguments as KomunikasiTahfidzModel;
    var idc = tahfidz.idTahfidz;
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
                      if (dropItem == 'Al Qur\'an') {
                        selectedJenis = 1;
                      } else if (dropItem == 'Hadist') {
                        selectedJenis = 2;
                      } else if (dropItem == 'Tahsin/Tajwid') {
                        selectedJenis = 3;
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
              const Text('Jenis Hafalan'),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropJenisHafalan,
                  isExpanded: true,
                  items: listJenisHafalan
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropJenisHafalan = value!;
                      if (dropJenisHafalan == 'Sabaq') {
                        selectedJenisHafalan = 1;
                      } else if (dropJenisHafalan == 'Sabqi') {
                        selectedJenisHafalan = 2;
                      } else if (dropJenisHafalan == 'Manzil') {
                        selectedJenisHafalan = 3;
                      } else if (dropJenisHafalan == 'Ziyadah') {
                        selectedJenisHafalan = 4;
                      } else if (dropJenisHafalan == 'Muraja\'ah') {
                        selectedJenisHafalan = 5;
                      }
                    });
                  },
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Metode'),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropMetode,
                  isExpanded: true,
                  items:
                      listMetode.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropMetode = value!;
                      if (dropMetode == 'Klasikal') {
                        selectedJenisHafalan = 1;
                      } else if (dropMetode == 'Privat') {
                        selectedJenisHafalan = 2;
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
              const Text('Juz'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: juz,
                  decoration: const InputDecoration.collapsed(
                      hintText: '1', hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Surat'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: surat,
                  decoration: const InputDecoration.collapsed(
                      hintText: '...',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Ayat'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: ayat,
                  decoration: const InputDecoration.collapsed(
                      hintText: '1', hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Ayat To'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: ayatTo,
                  decoration: const InputDecoration.collapsed(
                      hintText: '...',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Sampai'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: sampai,
                  decoration: const InputDecoration.collapsed(
                      hintText: '1', hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Jumlah'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: jumlah,
                  decoration: const InputDecoration.collapsed(
                      hintText: '1', hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Nilai'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  controller: nilai,
                  decoration: const InputDecoration.collapsed(
                      hintText: '...',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                    final scaffold = ScaffoldMessenger.of(context);
                    final currentUser = _users.isNotEmpty ? _users.first : null;
                    String? id = currentUser?.siskonpsn;
                    String? tokenss = currentUser?.tokenss;
                    String? kodePegawai = currentUser?.siskokode ?? '';

                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (id != null && tokenss != null && idc != null) {
                        await KomunikasiService().editKomunikasiTahfidz(
                          id: id,
                          tokenss: tokenss,
                          action: 'edit',
                          tab: 'tahfidz',
                          nis: nis,
                          jenis: selectedJenis.toString(),
                          metode: dropMetode.toLowerCase(),
                          jenisHafalan: dropJenisHafalan.toLowerCase(),
                          juz: juz.text,
                          surat: surat.text,
                          ayat: ayat.text,
                          ayatTo: ayatTo.text,
                          jumlah: jumlah.text,
                          nilai: nilai.text,
                          tanggal: _formatDate(_selectedDate),
                          catatan: bahasan.text,
                          catatanKel: catatan.text,
                          kodePegawai: kodePegawai,
                          idc: idc,
                        );
                        scaffold.showSnackBar(
                          SnackBar(
                            backgroundColor:
                                // ignore: use_build_context_synchronously
                                Theme.of(context).colorScheme.primary,
                            content: Text('Berhasil disimpan',
                                style: TextStyle(
                                    // ignore: use_build_context_synchronously
                                    color:
                                        // ignore: use_build_context_synchronously
                                        Theme.of(context).colorScheme.primary)),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          // ignore: use_build_context_synchronously
                          context.read<KomunikasiProvider>().refreshListTahfidz(
                              id: id, tokenss: tokenss.substring(0, 30));
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
