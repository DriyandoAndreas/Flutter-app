import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/models/uks_model.dart';
import 'package:sisko_v5/services/uks_service.dart';

class FormEditUksGr extends StatefulWidget {
  const FormEditUksGr({super.key});

  @override
  State<FormEditUksGr> createState() => _FormEditUksGrState();
}

class _FormEditUksGrState extends State<FormEditUksGr>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late List<UksListGrModel> _guruOpen = [];
  late List<UksListObatModel> _obatOpen = [];
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late UksModel uks;

  late TextEditingController diagnosa =
      TextEditingController(text: uks.diagnosa);
  late TextEditingController keterangan = TextEditingController(text: uks.ket);
  TextEditingController jumlahObat1 = TextEditingController(text: '0');
  TextEditingController jumlahObat2 = TextEditingController(text: '0');

  int _limit = 30;
  late String? _seletedGuru = uks.nip;
  String? _selectedObat1;
  String? _selectedObat2;
  late DateTime selectedDate = DateTime.parse(uks.tglPeriksa!);

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
      throw Exception('Gagal mengambil data dari sqlite');
    }
  }

  Future<void> initdata() async {
    await loadUser();
    // ignore: use_build_context_synchronously

    await loadGuru('gr', _limit);
    await loadObat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    uks = ModalRoute.of(context)!.settings.arguments as UksModel;
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
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
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
      throw Exception('gagal load list $e');
    }
  }

  Future<void> loadObat() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
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
      throw Exception('gagal load list $e');
    }
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      _limit += 10;
      loadGuru('gr', _limit).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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
          return const Center(child: CircularProgressIndicator());
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

  void _showObat1() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
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

  void _showObat2() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskoid;
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
                    if (id != null && tokenss != null) {
                      tokenss = tokenss?.substring(0, 30);
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await UksService().editUks(
                        id: id!,
                        tokenss: tokenss!,
                        action: 'add',
                        kdPeriksa: '',
                        nis: _seletedGuru!,
                        tgl: _formatDate(selectedDate),
                        diagnosa: diagnosa.text,
                        ket: keterangan.text,
                        obat0: _selectedObat1 ?? '',
                        obat1: _selectedObat2 ?? '',
                        stock0: jumlahObat1.text,
                        stock1: jumlahObat2.text,
                      );
                      scaffold.showSnackBar(
                        SnackBar(
                          content: const Text('Berhasil disimpan'),
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
