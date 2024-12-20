import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/models/uks_model.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/uks_service.dart';

class FormEditUks extends StatefulWidget {
  const FormEditUks({super.key});

  @override
  State<FormEditUks> createState() => _FormEditUksState();
}

class _FormEditUksState extends State<FormEditUks> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  late List<UksListSiswaModel> _siswaOpen = [];
  late List<UksListObatModel> _obatOpen = [];
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late UksModel uks;
  late List<UksViewObatModel> _obat = [];

  late TextEditingController diagnosa =
      TextEditingController(text: uks.diagnosa);
  late TextEditingController keterangan = TextEditingController(text: uks.ket);
  TextEditingController jumlahObat1 = TextEditingController();
  TextEditingController jumlahObat2 = TextEditingController();

  late String? _selectedSiswa = uks.nis;
  String? _selectedObat1;
  String? _selectedObat2;
  String? _selectedKdObat1;
  String? _selectedKdObat2;

  int _limit = 30;
  bool isLoading = false;
  bool _isLoading = false;
  late DateTime selectedDate = DateTime.parse(uks.tglPeriksa!);

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
      UksModel kelas =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as UksModel;
      var kodeKelas = kelas.kodeKelas;
      var param2 = kelas.kdPeriksa;
      await loadSiswa(kodeKelas!, _limit);
      await loadObat();
      _loadList(param2!);
    }
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

  Future<void> loadSiswa(
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
      if (id != null && tokenss != null) {
        final listKelas = await UksService().getListSiswa(
            id: id,
            tokenss: tokenss.substring(0, 30),
            kodeKelas: kodeKelas,
            limit: limit);

        setState(() {
          _siswaOpen = listKelas;
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
        return;
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
        UksListKelasModel kelas =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as UksListKelasModel;
        var kodeKelas = kelas.kodeKelas;
        _limit += 10;
        loadSiswa(kodeKelas!, _limit).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  Future<void> _loadList(String param2) async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await UksService().getObatDetail(
          id: id,
          tokenss: tokenss.substring(0, 30),
          param2: param2,
        );
        setState(() {
          _obat = paginatedList;
          if (_obat.isNotEmpty) {
            _selectedObat1 = _obat[0].namaObat;
            _selectedKdObat1 = _obat[0].kodeObat;
            jumlahObat1.text = _obat[0].jumobat ?? '';
          }
          if (_obat.length > 1) {
            _selectedObat2 = _obat[1].namaObat;
            _selectedKdObat2 = _obat[1].kodeObat;
            jumlahObat2.text = _obat[1].jumobat ?? '';
          }
        });
      } else {
        return;
      }
    } catch (e) {
      return;
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

  void _showSiswaModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (_siswaOpen.isEmpty) {
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
                    itemCount: _siswaOpen.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _siswaOpen.length) {
                        final siswa = _siswaOpen[index];
                        return RadioListTile<String>(
                          title: Text('[${siswa.nis}] ${siswa.nama}'),
                          value: '${siswa.nis}',
                          groupValue: _selectedSiswa,
                          onChanged: (value) {
                            setState(() {
                              _selectedSiswa = value;
                            });
                            Navigator.pop(context);
                          },
                        );
                      } else if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
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
                          groupValue: _selectedKdObat1,
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
                          groupValue: _selectedKdObat2,
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
                onPressed: _showSiswaModal,
                child: Text(_selectedSiswa ?? 'Pilih pasien',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tanggal'),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(_formatDate(selectedDate),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Diagnosa'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
              // TODO: overflow layar < 600px
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                      if (id != null && tokenss != null) {
                        setState(() {
                          isLoading = true;
                        });
                        await UksService().editUks(
                          id: id,
                          tokenss: tokenss.substring(0, 30),
                          action: 'edit',
                          kdPeriksa: uks.kdPeriksa ?? '',
                          nis: _selectedSiswa!,
                          tgl: _formatDate(selectedDate),
                          diagnosa: diagnosa.text,
                          ket: keterangan.text,
                          obat0: _selectedKdObat1 ?? '',
                          obat1: _selectedKdObat2 ?? '',
                          stock0: jumlahObat1.text,
                          stock1: jumlahObat2.text,
                        );
                        scaffold.showSnackBar(
                          SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text(
                                'Berhasil disimpan',
                                style: TextStyle(
                                  color:
                                      // ignore: use_build_context_synchronously
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = false;
                        });
                      }
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
