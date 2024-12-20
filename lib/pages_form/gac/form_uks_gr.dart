import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/models/uks_model.dart';
import 'package:app5/services/uks_service.dart';

class FormUksGr extends StatefulWidget {
  const FormUksGr({super.key});

  @override
  State<FormUksGr> createState() => _FormUksGrState();
}

class _FormUksGrState extends State<FormUksGr> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late List<UksListGrModel> _guruOpen = [];
  late List<UksListObatModel> _obatOpen = [];
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  DateTime selectedDate = DateTime.now();

  TextEditingController diagnosa = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  TextEditingController jumlahObat1 = TextEditingController(text: '0');
  TextEditingController jumlahObat2 = TextEditingController(text: '0');

  int _limit = 30;
  String? _seletedGuru;
  String? _selectedObat1;
  String? _selectedObat2;

  bool isLoading = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _scrollController.addListener(_loadMoreItems);
    initdata();
  }

  Future<void> loadUser() async {
    try {
      List<SqliteUserModel> users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> initdata() async {
    await loadUser();
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> arguments =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String kodeKelas = arguments['kode_kelas'];

      await loadGuru(kodeKelas, _limit);
      await loadObat();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadGuru(
    String kodeKelas,
    int limit,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id!=null && tokenss != null) {
        final listKelas = await UksService().getListGuru(
            id: id,
            tokenss: tokenss.substring(0, 30),
            kodeKelas: kodeKelas,
            limit: limit);

        setState(() {
          _guruOpen = listKelas;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> loadObat() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskonpsn;
      String? tokenss = currentUser?.tokenss;
      if (id!=null && tokenss != null) {
        final lists = await UksService().getObat(
          id: id,
          tokenss: tokenss.substring(0, 30),
        );

        setState(() {
          _obatOpen = lists;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      return;
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final Map<String, dynamic> arguments =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final String kodeKelas = arguments['kode_kelas'];
        _limit += 10;
        loadGuru(kodeKelas, _limit).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _incrementController(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 1;
      currentValue++;
      controller.text = currentValue.toString();
    });
  }

  void _decrementController(TextEditingController controller) {
    setState(() {
      int currentValue = int.tryParse(controller.text) ?? 1;
      if (currentValue > 1) {
        currentValue--;
        controller.text = currentValue.toString();
      }
    });
  }

  void _showGuruModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_guruOpen.isEmpty) {
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
                    itemCount: _guruOpen.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _guruOpen.length) {
                        final guru = _guruOpen[index];
                        return RadioListTile<String>(
                          title: Text('[${guru.nis}] ${guru.nama}'),
                          value: '${guru.nis}',
                          groupValue: _seletedGuru,
                          onChanged: (value) {
                            setState(() {
                              _seletedGuru = value;
                            });
                            Navigator.pop(context);
                          },
                        );
                      } else if (_isLoading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
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

  void _showObat1() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_obatOpen.isEmpty) {
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
                    itemCount: _obatOpen.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _obatOpen.length) {
                        final obat = _obatOpen[index];
                        return RadioListTile<String>(
                          title: Text('[${obat.kdObat}] ${obat.namaObat}'),
                          value: '${obat.kdObat}',
                          groupValue: _selectedObat1,
                          onChanged: (value) {
                            setState(() {
                              _selectedObat1 = value;
                            });
                            Navigator.pop(context);
                          },
                        );
                      } else if (_isLoading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
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

  void _showObat2() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_obatOpen.isEmpty) {
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
                    itemCount: _obatOpen.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _obatOpen.length) {
                        final obat = _obatOpen[index];
                        return RadioListTile<String>(
                          title: Text('[${obat.kdObat}] ${obat.namaObat}'),
                          value: '${obat.kdObat}',
                          groupValue: _selectedObat2,
                          onChanged: (value) {
                            setState(() {
                              _selectedObat2 = value;
                            });
                            Navigator.pop(context);
                          },
                        );
                      } else if (_isLoading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
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

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskonpsn;
    String? tokenss = currentUser?.tokenss;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kesehatan (UKS)'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Pasien'),
              TextButton(
                onPressed: _showGuruModal,
                child: Text(_seletedGuru ?? 'Pilih pasien'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tanggal'),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(_formatDate(selectedDate)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Diagnosa'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: diagnosa,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Diagnosa penyakit',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 0.1,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextButton(
                            onPressed: _showObat1,
                            child: Text(_selectedObat1 ?? 'Pilih obat')),
                      ),
                      TextButton(
                        onPressed: () => _decrementController(jumlahObat1),
                        child: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        height: 50,
                        width: 25,
                        child: TextFormField(
                          controller: jumlahObat1,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: '1',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _incrementController(jumlahObat1),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 0.1,
              ),
              const Divider(
                thickness: 0.1,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextButton(
                            onPressed: _showObat2,
                            child: Text(_selectedObat2 ?? 'Pilih Obat')),
                      ),
                      TextButton(
                        onPressed: () => _decrementController(jumlahObat2),
                        child: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        height: 50,
                        width: 25,
                        child: TextFormField(
                          controller: jumlahObat2,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: '1',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _incrementController(jumlahObat2),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 0.1,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Keterangan'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: keterangan,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Keterangan penyakit',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const Divider(thickness: 0.1),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final scaffold = ScaffoldMessenger.of(context);
                   
                    try {
                      setState(() {
                        isLoading = true;
                      });
                       if (id!=null && tokenss != null) {
                        tokenss = tokenss?.substring(0, 30);
                      
                      await UksService().addUks(
                        id: id,
                        tokenss: tokenss!,
                        action: 'add',
                        nis: _seletedGuru!,
                        tgl: _formatDate(selectedDate),
                        diagnosa: diagnosa.text,
                        ket: keterangan.text,
                        obat0: _selectedObat1 ?? '',
                        obat1: _selectedObat2 ?? '',
                        stock0: jumlahObat1.text,
                        stock1: jumlahObat2.text,
                      );
                      }
                      scaffold.showSnackBar(
                        SnackBar(
                          backgroundColor:
                              // ignore: use_build_context_synchronously
                              Theme.of(context).colorScheme.primary,
                          content: Text(
                            'Berhasil disimpan',
                            style: TextStyle(
                                // ignore: use_build_context_synchronously
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      );
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
