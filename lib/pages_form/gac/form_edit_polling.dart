import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/polling_model.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/polling_service.dart';

class FormEditPolling extends StatefulWidget {
  const FormEditPolling({super.key});

  @override
  State<FormEditPolling> createState() => _FormEditPollingState();
}

class _FormEditPollingState extends State<FormEditPolling> {
  PollingProvider? _pollingProvider;
  late ListPollingModel dataEdit;
  late DateTime tanggalMulai = DateTime.parse(dataEdit.tanggalmulai!);
  late DateTime tanggalSelesai = DateTime.parse(dataEdit.tanggalselesai!);
  late TextEditingController namapolling =
      TextEditingController(text: dataEdit.namapolling);
  late TextEditingController pertanyaan =
      TextEditingController(text: dataEdit.pertanyaan);
  List<String> _selectedParticipants = [];
  List<TextEditingController> pilihanControllers = [];
  List<Widget> pilihanFields = [];
  List<String> peserta = [];
  List<String> jawabans = [];
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataEdit = ModalRoute.of(context)!.settings.arguments as ListPollingModel;
    _pollingProvider ??= Provider.of<PollingProvider>(context, listen: false);
    initData();
  }

  @override
  void dispose() {
    namapolling.dispose();
    pertanyaan.dispose();
    _pollingProvider?.disposeControllers();
    super.dispose();
  }

  Future<void> initData() async {
    await getPeserta();
    await getPilihan();
    await getView();
  }

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
        await _pollingProvider?.getPeserta(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getPilihan() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      var param = dataEdit.kodepolling;
      if (id != null && tokenss != null && param != null) {
        if (mounted) {
          await _pollingProvider?.getJawabanPolling(
              id: id, tokenss: tokenss, param: param);
          if (pilihanControllers.isEmpty) {
            setState(() {
              pilihanControllers =
                  List.from(_pollingProvider?.controllers ?? []);
            });
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getView() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      var param = dataEdit.kodepolling;
      if (id != null && tokenss != null && param != null) {
        if (mounted) {
          await _pollingProvider?.getPolling(
              id: id, tokenss: tokenss, param: param);
          List<ViewPollingModel> pollingData = _pollingProvider!.getPoling;
          if (pollingData.isNotEmpty) {
            //element pertama pada polling data view
            var data = pollingData
                .firstWhere((element) => element.kodepolling == param)
                .peserta!
                .split(', ');

            setState(() {
              // Simpan peserta dari API
              _selectedParticipants = data;
            });
          }
        }
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
                            bool value =
                                _selectedParticipants.contains(entry.key);
                            return CheckboxListTile(
                              title: Text(entry.key),
                              value: value,
                              onChanged: (bool? newValue) {
                                setModalState(() {
                                  if (newValue == true) {
                                    _selectedParticipants.add(entry.key);
                                  } else {
                                    _selectedParticipants.remove(entry.key);
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
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
  Widget build(BuildContext context) {
    final ListPollingModel formdatas =
        ModalRoute.of(context)!.settings.arguments as ListPollingModel;

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
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                    Text(startDate,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
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
                    Text(endDate,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
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
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                controller: pertanyaan,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<PollingProvider>(
                builder: (context, value, child) {
                  if (value.getJawaban.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.getJawaban.length,
                      itemBuilder: (context, index) {
                        if (index < value.controllers.length) {
                          var datas = value.getJawaban[index];
                          var controller = value.controllers[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pilihan'),
                              TextFormField(
                                controller: controller,
                                decoration: InputDecoration.collapsed(
                                    hintText: '${datas.jawaban}'),
                              ),
                              const Divider(
                                thickness: 0.5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
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
                      setState(() {
                        isLoading = true;
                        jawabans.clear();
                        for (var controller in pilihanControllers) {
                          jawabans.add(controller.text);
                        }
                      });

                      final scaffold = ScaffoldMessenger.of(context);
                      final PollingService service = PollingService();
                      final user = Provider.of<SqliteUserProvider>(context,
                          listen: false);
                      var id = user.currentuser.siskonpsn;
                      var tokenss = user.currentuser.tokenss;
                      var kodepolling = formdatas.kodepolling;

                      if (id != null &&
                          tokenss != null &&
                          kodepolling != null) {
                        await service.editPolling(
                          id: id,
                          tokenss: tokenss,
                          action: 'edit',
                          kodepolling: kodepolling,
                          namapolling: namapolling.text,
                          tanggalmulai: startDate,
                          tanggalselesai: endDate,
                          peserta: peserta,
                          pertanyaan: pertanyaan.text,
                          jawaban: jawabans,
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
                    },
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive()
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
