import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class SatViewKomunikasiTahfidz extends StatefulWidget {
  const SatViewKomunikasiTahfidz({super.key});

  @override
  State<SatViewKomunikasiTahfidz> createState() =>
      _SatViewKomunikasiTahfidzState();
}

class _SatViewKomunikasiTahfidzState extends State<SatViewKomunikasiTahfidz> {
  TextEditingController komentar = TextEditingController();
  late List<SqliteUserModel> _users = [];
  late SqLiteHelper _sqLiteHelper;
  void clear() {
    komentar.clear();
  }

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
    super.dispose();
  }

  void _initData() async {
    await _loadUsers();
    await loadComment();
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

  Future<void> loadComment() async {
    try {
      final user = _users.isNotEmpty ? _users.first : null;
      var id = user?.siskonpsn;
      var tokenss = user?.tokenss;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        SatKomunikasiTahfidzModel tahfidz =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments
                as SatKomunikasiTahfidzModel;
        var param = tahfidz.idtahfidz;
        if (id != null && tokenss != null && param != null) {
          context.read<SatKomunikasiProvider>().getListKomentarTahfidz(
                id: id,
                tokenss: tokenss,
                param: param,
              );
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _loadView() async {
    try {
      final user = _users.isNotEmpty ? _users.first : null;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        SatKomunikasiTahfidzModel tahfidz =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments
                as SatKomunikasiTahfidzModel;
        var idc = tahfidz.idtahfidz;
        var id = user?.siskonpsn;
        var tokenss = user?.tokenss;

        if (id != null && tokenss != null && idc != null) {
          await context.read<SatKomunikasiProvider>().getViewTahfidz(
              id: id, tokenss: tokenss.substring(0, 30), param: idc);
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _refresh() async {
    await loadComment();
  }

  @override
  Widget build(BuildContext context) {
    final SatKomunikasiTahfidzModel tahfidz =
        ModalRoute.of(context)!.settings.arguments as SatKomunikasiTahfidzModel;
    final user = Provider.of<SqliteUserProvider>(context, listen: false);

    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tahfidz.jenishafalan ?? '',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              tahfidz.tanggal ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<SatKomunikasiProvider>(
                  builder: (context, value, child) {
                    if (value.viewTahfidz.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.viewTahfidz.length,
                          itemBuilder: (context, index) {
                            var datas = value.viewTahfidz[index];
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Jenis Hafalan'),
                                  Text(
                                      '${datas.jenishafalan} (${datas.metode})',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  const Divider(
                                    thickness: 0.1,
                                  ),
                                  const Text('Juz - Surat  - Ayat'),
                                  Text(
                                      '${datas.juz}-${datas.surat}-${datas.ayat}-${datas.ayato}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  const Divider(
                                    thickness: 0.1,
                                  ),
                                  const Text(
                                    'Tahun Ajaran',
                                  ),
                                  Text('${datas.tahunajaran}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  const Divider(
                                    thickness: 0.1,
                                  ),
                                  const Text('Semester'),
                                  Text('${datas.semester}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  const Divider(
                                    thickness: 0.1,
                                  ),
                                  const Text('Catatan'),
                                  Text('${datas.catatan}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  const Divider(
                                    thickness: 0.1,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  comment(),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ]);
                          });
                    }
                  },
                ),
                Card(
                  color: Theme.of(context).colorScheme.onPrimary,
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: komentar,
                        decoration: const InputDecoration(
                            hintText: 'Silahkan isi tanggapan'),
                      ),
                    ),
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
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        if (id != null && tokenss != null) {
                          bool isSiswa = false;
                          if (user.currentuser.siskostatuslogin == 's' ||
                              user.currentuser.siskostatuslogin == 'i' ||
                              user.currentuser.siskostatuslogin == 'a') {
                            setState(() {
                              isSiswa = true;
                            });
                          }
                          await KomunikasiService().addComment(
                            id: id,
                            tokenss: tokenss.substring(0, 30),
                            action: 'comment',
                            tabel: 'umum',
                            idc: tahfidz.idtahfidz ?? '',
                            komentar: komentar.text,
                            kodePegawai:
                                isSiswa ? '' : user.currentuser.siskokode!,
                            nis: isSiswa ? user.currentuser.siskokode! : '',
                          );
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                              // ignore: use_build_context_synchronously
                              content: Text(
                                'Berhasil disimpan',
                                style: TextStyle(
                                    // ignore: use_build_context_synchronously
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          clear();
                          _refresh();
                          // ignore: use_build_context_synchronously
                          context
                              .read<KomunikasiProvider>()
                              .initListUmum(id: id, tokenss: tokenss);
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
                            'Submit',
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

  Widget comment() {
    return Consumer<SatKomunikasiProvider>(
      builder: (context, data, child) {
        if (data.komentarTahfidz.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return ListView.builder(
            shrinkWrap: true, // Menyusutkan ukuran ListView sesuai jumlah item
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView
            itemCount: data.komentarTahfidz.length,
            itemBuilder: (context, index) {
              final comment = data.komentarTahfidz[index];
              return Card(
                surfaceTintColor: Theme.of(context).colorScheme.tertiary,
                color: Theme.of(context).colorScheme.onPrimary,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.namalengkap ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.tanggal ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(height: 8),
                      Text(comment.komentar ?? ''),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
