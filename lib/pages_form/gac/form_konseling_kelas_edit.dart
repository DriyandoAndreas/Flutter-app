import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/konseling_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/providers/konseling_provider.dart';
import 'package:sisko_v5/services/konseling_service.dart';

class FormKonselingEdit extends StatefulWidget {
  const FormKonselingEdit({super.key});

  @override
  State<FormKonselingEdit> createState() => _FormKonselingEditState();
}

class _FormKonselingEditState extends State<FormKonselingEdit>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<PoinModel> _poins = [];
  late KonselingModel konseling;
  bool _isLoading = false;
  bool isLoading = false;
  String? _selectedSiswa;
  late String? _selectedPoin = konseling.kodeScore;
  late TextEditingController kasus =
      TextEditingController(text: konseling.kasus);
  late TextEditingController penanganan =
      TextEditingController(text: konseling.penanganan);
  late DateTime selectedDate = DateTime.parse(konseling.tanggal!);
  late TimeOfDay selectedTime =
      TimeOfDay.fromDateTime(DateTime.parse(konseling.tanggalJam!));
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();

    initdata();
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

  Future<void> initdata() async {
    await loadUser();
    await loadPoin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    konseling = ModalRoute.of(context)!.settings.arguments as KonselingModel;
    _selectedSiswa = konseling.nis;
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Pilih waktu Konseling';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> loadPoin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final lists = await KonselingService().getPoin(
          id: id,
          tokenss: tokenss.substring(0, 30),
        );

        setState(() {
          _poins = lists;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('gagal load list $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskoid;
    String? tokenss = currentUser?.tokenss;
    final inputDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final inputTime = _formatTime(selectedTime);
    String kdKonseling = konseling.kdKonseling!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Konseling"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tanggal'),
              TextButton(
                onPressed: null,
                child: Text(inputDate),
              ),
              const Divider(thickness: 0.1),
              const Text('Waktu/Jam'),
              TextButton(
                onPressed: null,
                child: Text(inputTime),
              ),
              const Divider(thickness: 0.1),
              const Text('Pilih siswa'),
              TextButton(
                onPressed: null,
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (_poins.isEmpty) {
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
                                  itemCount: _poins.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index < _poins.length) {
                                      final poin = _poins[index];
                                      return RadioListTile<String>(
                                        title: Text(
                                            '[${poin.nilai}]-${poin.deskripsi!}'),
                                        value: poin.kodeScore!,
                                        groupValue: _selectedPoin,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedPoin = value;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    } else if (_isLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
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
                child: Text(_selectedPoin ?? 'Pilih Jenis Poin'),
              ),
              const Divider(thickness: 0.1),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final scaffold = ScaffoldMessenger.of(context);
                    if (id != null && tokenss != null) {
                      tokenss = tokenss?.substring(0, 30);
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      await KonselingService().editKonseling(
                        id: id!,
                        tokenss: tokenss!,
                        action: 'edit',
                        kdKonseling: kdKonseling,
                        nis: _selectedSiswa!,
                        tanggal: inputDate,
                        jam: inputTime,
                        kasus: kasus.text,
                        penanganan: penanganan.text,
                        nilai: _selectedPoin!,
                      );
                      scaffold.showSnackBar(
                        SnackBar(
                          content: const Text('Berhasil di edit'),
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
                            .read<KonselingProvider>()
                            .refresh(id: id, tokenss: tokenss ?? '');
                        Navigator.of(context).pop();
                      });
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
