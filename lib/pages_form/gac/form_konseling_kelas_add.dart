import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/konseling_model.dart';
import 'package:app5/providers/kelas_provider.dart';
import 'package:app5/providers/konseling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/konseling_service.dart';

class FormKonselingAdd extends StatefulWidget {
  const FormKonselingAdd({super.key});

  @override
  State<FormKonselingAdd> createState() => _FormKonselingAddState();
}

class _FormKonselingAddState extends State<FormKonselingAdd> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  bool isLoading = false;
  bool _isInit = true;
  String? _selectedSiswa;
  String? _selectedPoin;
  TextEditingController kasus = TextEditingController();
  TextEditingController penanganan = TextEditingController();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      initdata();
      _isInit = false;
    }
  }

  Future<void> initdata() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      ShowKelasModel kelas = args as ShowKelasModel;
      var kodeKelas = kelas.kodeKelas;

      await loadListkelas(kodeKelas ?? '');
      await loadPoin();
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Pilih waktu Konseling';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> loadListkelas(String kodeKelas) async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if (id!=null && tokenss != null) {
        if (ModalRoute.of(context)!.settings.arguments != null) {
          ShowKelasModel kelas =
              // ignore: use_build_context_synchronously
              ModalRoute.of(context)!.settings.arguments as ShowKelasModel;
          var kodeKelas = kelas.kodeKelas;
          context.read<KelasProvider>().infiniteLoadKelasOpens(
                id: id,
                tokenss: tokenss.substring(0, 30),
                kodeKelas: kodeKelas ?? '',
              );
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> loadPoin() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if (id!=null && tokenss != null) {
        context.read<KonselingProvider>().initPoin(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
      }
    } catch (e) {
      return;
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        ShowKelasModel kelas =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as ShowKelasModel;
        var kodeKelas = kelas.kodeKelas;
        loadListkelas(kodeKelas ?? '');
      }
    }
  }

  void _showSiswaModal() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8),
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: Consumer<KelasProvider>(
                  builder: (context, kelasOpen, child) {
                    if (kelasOpen.infiniteListKelasOpen.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: kelasOpen.hasMore
                            ? kelasOpen.infiniteListKelasOpen.length + 1
                            : kelasOpen.infiniteListKelasOpen.length,
                        itemBuilder: (BuildContext context, int index) {
                          final siswa = kelasOpen.infiniteListKelasOpen[index];
                          return RadioListTile<String>(
                            title: Text('[${siswa.nis}] ${siswa.namaLengkap}'),
                            value: siswa.nis ?? '',
                            groupValue: _selectedSiswa,
                            onChanged: (value) {
                              setState(() {
                                _selectedSiswa = value;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPoin() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8),
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: Consumer<KonselingProvider>(
                  builder: (context, poin, child) {
                    if (poin.listPoin.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: poin.listPoin.length,
                        itemBuilder: (BuildContext context, int index) {
                          final poins = poin.listPoin[index];
                          return RadioListTile<String>(
                            title: Text('[${poins.nilai}]-${poins.deskripsi!}'),
                            value: poins.kodeScore!,
                            groupValue: _selectedPoin,
                            onChanged: (value) {
                              setState(() {
                                _selectedPoin = value;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    String? id = user.currentuser.siskonpsn;
    String? tokenss = user.currentuser.tokenss;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Konseling"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tanggal'),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(_formatDate(_selectedDate)),
                ),
                const Divider(thickness: 0.1),
                const Text('Waktu/Jam'),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(_formatTime(_selectedTime)),
                ),
                const Divider(thickness: 0.1),
                const Text('Pilih siswa'),
                TextButton(
                  onPressed: _showSiswaModal,
                  child: Text(_selectedSiswa ?? 'Nama Siswa'),
                ),
                const Divider(thickness: 0.1),
                const Text('Permasalahan/Prestasi'),
                SizedBox(
                  height: 150,
                  child: TextFormField(
                    focusNode: _focusNode2,
                    textInputAction: TextInputAction.done,
                    controller: kasus,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Jelaskan keadaannya',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onFieldSubmitted: (_) {
                      _focusNode2.unfocus();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Penanganan'),
                SizedBox(
                  height: 150,
                  child: TextFormField(
                    focusNode: _focusNode3,
                    textInputAction: TextInputAction.done,
                    controller: penanganan,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Jelaskan penangannya',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onFieldSubmitted: (_) {
                      _focusNode3.unfocus();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Poin'),
                TextButton(
                  onPressed: _showPoin,
                  child: Text(_selectedPoin ?? 'Pilih jenis poin'),
                ),
                const Divider(thickness: 0.1),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        final scaffold = ScaffoldMessenger.of(context);
                        if (id!=null && tokenss != null) {
                          if (_selectedDate == null) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text('Tanggal tidak boleh kosong',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else if (_selectedTime == null) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text('Waktu tidak boleh kosong',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else if (_selectedSiswa == null) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text('Silahkan pilh siswa',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else if (kasus.text.isEmpty) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text(
                                    'Permasalahan/Prestasi tidak boleh kosong',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else if (penanganan.text.isEmpty) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text('Penanganan tidak boleh kosong',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else if (_selectedPoin == null) {
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text(
                                    'Silahkan pilih poin terlebih dahulu',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            await KonselingService().addKonseling(
                              id: id,
                              tokenss: tokenss.substring(0, 30),
                              action: 'add',
                              tanggal: _formatDate(_selectedDate),
                              jam: _formatTime(_selectedTime),
                              nis: _selectedSiswa!,
                              kasus: kasus.text,
                              penanganan: penanganan.text,
                              nilai: _selectedPoin!,
                            );
                            scaffold.showSnackBar(
                              SnackBar(
                                // ignore: use_build_context_synchronously
                                backgroundColor:
                                    // ignore: use_build_context_synchronously
                                    Theme.of(context).colorScheme.primary,
                                content: Text('Berhasil disimpan',
                                    style: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              // ignore: use_build_context_synchronously
                              context.read<KonselingProvider>().refresh(
                                  id: id, tokenss: tokenss.substring(0, 30));
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            });
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Berita gagal ditambahkan',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                            ),
                          );
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
      ),
    );
  }
}
