import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/nilai_model.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/nilai_service.dart';

class FormAddNilai extends StatefulWidget {
  const FormAddNilai({super.key});

  @override
  State<FormAddNilai> createState() => _FormAddNilaiState();
}

class _FormAddNilaiState extends State<FormAddNilai> {
  List<TextEditingController> teoriController = [];
  List<TextEditingController> praktikController = [];
  List<TextEditingController> notesController = [];
  bool _isInit = true;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initData();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    for (var controller in teoriController) {
      controller.dispose();
    }
    for (var controller in praktikController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadList();
  }

  Future<void> _loadList() async {
    try {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final Map<String, dynamic> arguments =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final String kodeKelas = arguments['kodeKelas'];
        final String kodeMengajar = arguments['kodeMengajar'];
        NilaiJenisModel nilai = arguments['jp'] as NilaiJenisModel;
        final String jp = nilai.kodeTes ?? '';
        final user = Provider.of<SqliteUserProvider>(context, listen: false);
        String? id = user.currentuser.siskonpsn;
        String? tokenss = user.currentuser.tokenss;
        if (id != null && tokenss != null) {
          await context.read<NilaiProvider>().initShowNilai(
                id: id,
                tokenss: tokenss.substring(0, 30),
                kodeKelas: kodeKelas,
                jp: jp,
                kodeMengajar: kodeMengajar,
              );

          // ignore: use_build_context_synchronously
          final nilaiProvider = context.read<NilaiProvider>();
          teoriController = [];
          praktikController = [];
          notesController = [];
          for (var i = 0; i < nilaiProvider.listShowNilai.length; i++) {
            var item = nilaiProvider.listShowNilai[i];
            var itemkey = '';
            item.nilaiTes?.forEach((key, value) {
              itemkey = key;
            });
            final getkey = item.nilaiTes?[itemkey];
            var teori = getkey?['ppk'];
            var praktik = getkey?['praktik'];
            var notes = getkey?['notes'];

            if (teori == 'false') teori = '0';
            if (praktik == 'false') praktik = '0';
            if (notes == 'false') notes = '';
            if (teori != null &&
                praktik != null &&
                notes != null &&
                teori != '' &&
                praktik != '' &&
                notes != '') {
              double dblteori = double.parse(teori);
              int intteori = dblteori.toInt();
              teori = intteori.toString();
              double dblpraktik = double.parse(praktik);
              int intpraktik = dblpraktik.toInt();
              praktik = intpraktik.toString();
            } else {
              teori = '0';
              praktik = '0';
              notes = '';
            }
            teoriController.add(TextEditingController(text: teori));
            praktikController.add(TextEditingController(text: praktik));
            notesController.add(TextEditingController(text: notes));
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> refresh() async {
    try {
      //code here
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final Map<String, dynamic> arguments =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        final String kodeKelas = arguments['kodeKelas'];
        final String kodeMengajar = arguments['kodeMengajar'];
        NilaiJenisModel nilai = arguments['jp'] as NilaiJenisModel;
        final String jp = nilai.kodeTes ?? '';
        final user = Provider.of<SqliteUserProvider>(context, listen: false);
        String? id = user.currentuser.siskonpsn;
        String? tokenss = user.currentuser.tokenss;
        if (id != null && tokenss != null) {
          context.read<NilaiProvider>().refreshNilai(
                id: id,
                tokenss: tokenss.substring(0, 30),
                kodeKelas: kodeKelas,
                jp: jp,
                kodeMengajar: kodeMengajar,
              );
        }
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var npsn = user.currentuser.siskonpsn;
    bool branding = false;
    if (npsn == '7978' || npsn == '501') {
      branding = true;
    }
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    NilaiJenisModel nilai = arguments['jp'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: Text('${nilai.namaTes}'),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Consumer<NilaiProvider>(
            builder: (context, nilai, child) {
              if (nilai.listShowNilai.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                if (teoriController.length < nilai.listShowNilai.length) {
                  teoriController = [];
                  praktikController = [];
                  notesController = [];
                  for (var i = 0; i < nilai.listShowNilai.length; i++) {
                    var item = nilai.listShowNilai[i];
                    var itemkey = '';
                    item.nilaiTes?.forEach((key, value) {
                      itemkey = key;
                    });
                    final getkey = item.nilaiTes?[itemkey];
                    var teori = getkey?['ppk'];
                    var praktik = getkey?['praktik'];
                    var notes = getkey?['notes'];
                    if (teori == 'false') teori = '0';
                    if (praktik == 'false') praktik = '0';
                    if (notes == 'false') notes = '';
                    if (teori != null &&
                        praktik != null &&
                        notes != null &&
                        teori != '' &&
                        praktik != '' &&
                        notes != '') {
                      double dblteori = double.parse(teori);
                      int intteori = dblteori.toInt();
                      teori = intteori.toString();
                      double dblpraktik = double.parse(praktik);
                      int intpraktik = dblpraktik.toInt();
                      praktik = intpraktik.toString();
                    } else {
                      teori = '0';
                      praktik = '0';
                      notes = '';
                    }
                    teoriController.add(TextEditingController(text: teori));
                    praktikController.add(TextEditingController(text: praktik));
                    notesController.add(TextEditingController(text: notes));
                  }
                }
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      DataTable(
                          dataRowMinHeight: 50,
                          dataRowMaxHeight: branding == true ? 100 : 50,
                          dividerThickness: 0.1,
                          showBottomBorder: true,
                          columns: [
                            const DataColumn(
                              label: Text('Nama'),
                            ),
                            branding == true
                                ? const DataColumn(label: Text(''))
                                : const DataColumn(
                                    label: Text('Teori'),
                                  ),
                            branding == true
                                ? const DataColumn(
                                    label: Text('Nilai'),
                                  )
                                : const DataColumn(label: Text('Praktik')),
                          ],
                          rows: List.generate(
                            nilai.listShowNilai.length,
                            (index) {
                              final item = nilai.listShowNilai[index];
                              var itemkey = '';
                              item.nilaiTes?.forEach(
                                (key, value) {
                                  itemkey = key;
                                },
                              );
                              final getkey = item.nilaiTes?[itemkey];
                              var teori = getkey?['ppk'];
                              var praktik = getkey?['praktik'];
                              var notes = getkey?['notes'];

                              if (teori == 'false') {
                                teori = '0';
                              }
                              if (praktik == 'false') {
                                praktik = '0';
                              }
                              if (notes == 'false') {
                                notes = '';
                              }

                              return DataRow(cells: [
                                branding == true
                                    ? DataCell(Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.namaLengkap ?? ''),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text('notes: '),
                                          SizedBox(
                                            width: 200,
                                            height: 30,
                                            child: TextFormField(
                                              maxLines: null,
                                              minLines: 1,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    150)
                                              ],
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                              controller:
                                                  notesController[index],
                                              decoration: InputDecoration
                                                  .collapsed(
                                                      hintStyle: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .tertiary),
                                                      hintText:
                                                          'maksimal 150 karakter'),
                                            ),
                                          )
                                        ],
                                      ))
                                    : DataCell(
                                        Text(item.namaLengkap ?? ''),
                                      ),
                                branding == true
                                    ? const DataCell(Text(''))
                                    : DataCell(TextFormField(
                                        controller: teoriController[index],
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(3)
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration.collapsed(
                                            hintStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                            hintText: teoriController[index]
                                                    .text
                                                    .isEmpty
                                                ? teori
                                                : null),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary))),
                                DataCell(TextFormField(
                                  controller: praktikController[index],
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      hintText:
                                          praktikController[index].text.isEmpty
                                              ? praktik
                                              : null),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                )),
                              ]);
                            },
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  final scaffold =
                                      ScaffoldMessenger.of(context);
                                  setState(() {
                                    isloading = true;
                                  });
                                  final provider = Provider.of<NilaiProvider>(
                                      context,
                                      listen: false);
                                  final kelasMapels =
                                      provider.listKelas.isNotEmpty
                                          ? provider.listKelas.first
                                          : null;
                                  String? thnAjaran = kelasMapels?.thnAj;
                                  String? semester = kelasMapels?.semester;
                                  final Map<String, dynamic> arguments =
                                      ModalRoute.of(context)!.settings.arguments
                                          as Map<String, dynamic>;
                                  final String kodePelajaran =
                                      arguments['kodePelajaran'];
                                  NilaiJenisModel kodeTes =
                                      arguments['jp'] as NilaiJenisModel;
                                  final String jp = kodeTes.kodeTes ?? '';
                                  final user = Provider.of<SqliteUserProvider>(
                                      context,
                                      listen: false);
                                  String? id = user.currentuser.siskonpsn;
                                  String? tokenss = user.currentuser.tokenss;
                                  String? kodePegawai =
                                      user.currentuser.siskokode;
                                  if (id != null && tokenss != null) {
                                    List<String> nis = [];
                                    List<String> jenisNilai = [];
                                    List<String> nilaiList = [];
                                    for (var i = 0;
                                        i < nilai.listShowNilai.length;
                                        i++) {
                                      nis.add(nilai.listShowNilai[i].nis ?? '');

                                      if (branding == true) {
                                        jenisNilai.add('praktik');
                                        nilaiList.add(
                                            praktikController[i].text.isNotEmpty
                                                ? praktikController[i].text
                                                : '0');
                                        jenisNilai.add('notes');
                                        nilaiList.add(
                                            notesController[i].text.isNotEmpty
                                                ? notesController[i].text
                                                : '');
                                      } else {
                                        jenisNilai.add('ppk');
                                        nilaiList.add(
                                            teoriController[i].text.isNotEmpty
                                                ? teoriController[i].text
                                                : '0');
                                        jenisNilai.add('praktik');
                                        nilaiList.add(
                                            praktikController[i].text.isNotEmpty
                                                ? praktikController[i].text
                                                : '0');
                                      }
                                    }

                                    await NilaiService().addNilai(
                                      id: id,
                                      tokenss: tokenss.substring(0, 30),
                                      action: 'simpan',
                                      branding: branding,
                                      jp: jp,
                                      tahunAjaran: thnAjaran ?? '',
                                      semester: semester ?? '',
                                      kodePelajaran: kodePelajaran,
                                      kodePegawai: kodePegawai ?? '',
                                      nis: nis,
                                      jenisNilai: jenisNilai,
                                      nilai: nilaiList,
                                    );
                                  }
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
                                  refresh();
                                } catch (e) {
                                  return;
                                } finally {
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(8)),
                                backgroundColor:
                                    const Color.fromARGB(255, 73, 72, 72),
                              ),
                              child: isloading
                                  ? const CircularProgressIndicator.adaptive(
                                      backgroundColor: Colors.white,
                                    )
                                  : const Text(
                                      'Simpan',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}
