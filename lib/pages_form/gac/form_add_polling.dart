import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/polling_service.dart';

class FormAddPolling extends StatefulWidget {
  const FormAddPolling({super.key});

  @override
  State<FormAddPolling> createState() => _FormAddPollingState();
}

class _FormAddPollingState extends State<FormAddPolling> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  Future<void> initData() async {
    await getPeserta();
  }

  late DateTime tanggalMulai = DateTime.now();
  late DateTime tanggalSelesai = DateTime.now();
  TextEditingController namapolling = TextEditingController();
  TextEditingController pertanyaan = TextEditingController();

  List<TextEditingController> pilihanControllers = [];
  List<Widget> pilihanFields = [];
  List<String> peserta = [];
  List<String> jawabans = [];
  bool isLoading = false;

  Future<void> _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalMulai,
      firstDate: DateTime(2015, 8),
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
              dialogBackgroundColor: context.watch<ThemeSwitchProvider>().isDark
                  ? Colors.black
                  : Colors.white),
          child: child!,
        );
      },
    );

    if (picked != null && picked != tanggalMulai) {
      setState(() {
        tanggalMulai = picked;
      });
    }
  }

  Future<void> _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalSelesai,
      firstDate: DateTime(2015, 8),
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
              dialogBackgroundColor: context.watch<ThemeSwitchProvider>().isDark
                  ? Colors.black
                  : Colors.white),
          child: child!,
        );
      },
    );

    if (picked != null && picked != tanggalSelesai) {
      setState(() {
        tanggalSelesai = picked;
      });
    }
  }

  Future<void> getPeserta() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        await context
            .read<PollingProvider>()
            .getPeserta(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  void addPeserta() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer<PollingProvider>(
              builder: (context, pollingProvider, child) {
                var data = pollingProvider.peserta.data;
                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: data.entries.map((entry) {
                            bool value = peserta.contains(entry.key);
                            return CheckboxListTile(
                              title: Text(entry.key),
                              value: value,
                              onChanged: (bool? newValue) {
                                setModalState(() {
                                  if (newValue == true) {
                                    peserta.add(entry.key);
                                  } else {
                                    peserta.remove(entry.key);
                                  }
                                });
                                setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _addPilihanField() {
    TextEditingController jawaban = TextEditingController();
    pilihanControllers.add(jawaban);
    setState(() {
      pilihanFields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilihan'),
            TextFormField(
              controller: jawaban,
              decoration: const InputDecoration.collapsed(hintText: ''),
            ),
            const Divider(
              thickness: 0.5,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    namapolling.dispose();
    pertanyaan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startDate = DateFormat('yyyy-MM-dd').format(tanggalMulai);
    final endDate = DateFormat('yyyy-MM-dd').format(tanggalSelesai);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Polling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Polling'),
              TextFormField(
                controller: namapolling,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tanggal Mulai'),
              TextButton(
                onPressed: () {
                  _startDate(context);
                },
                child: Column(
                  children: [
                    Text(
                      startDate,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tanggal Selesai'),
              TextButton(
                onPressed: () {
                  _endDate(context);
                },
                child: Column(
                  children: [
                    Text(
                      endDate,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                onPressed: () {
                  addPeserta();
                },
                child: peserta.isNotEmpty
                    ? Text(peserta.join(', '))
                    : const Text('Peserta'),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Pertanyaan'),
              TextFormField(
                controller: pertanyaan,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(
                height: 10,
              ),
              ...pilihanFields,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _addPilihanField,
                    child: const Text('Tambah Pilihan'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final scaffold = ScaffoldMessenger.of(context);
                        if (namapolling.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Nama polling tidak boleh kosong',
                                  style: TextStyle(
                                      color:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                            ),
                          );
                        } else if (pertanyaan.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Pertanyaan tidak boleh kosong',
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
                            jawabans.clear();
                            for (var controller in pilihanControllers) {
                              jawabans.add(controller.text);
                            }
                          });
                          final PollingService service = PollingService();
                          final user = Provider.of<SqliteUserProvider>(context,
                              listen: false);
                          var id = user.currentuser.siskonpsn;
                          var tokenss = user.currentuser.tokenss;
                          if (id != null && tokenss != null) {
                            await service.addPolling(
                              id: id,
                              tokenss: tokenss,
                              action: 'add',
                              namapolling: namapolling.text,
                              tanggalmulai: tanggalMulai.toString(),
                              tanggalselesai: tanggalSelesai.toString(),
                              peserta: peserta,
                              pertanyaan: pertanyaan.text,
                              jawaban: jawabans,
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
                            // ignore: use_build_context_synchronously
                            context
                                .read<PollingProvider>()
                                .getList(id: id, tokenss: tokenss);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          }

                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        return;
                      }
                    },
                    child: isLoading
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator.adaptive())
                        : const Text('Submit'),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
