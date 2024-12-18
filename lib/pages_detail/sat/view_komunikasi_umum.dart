import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class SatViewKomunikasiUmum extends StatefulWidget {
  const SatViewKomunikasiUmum({super.key});

  @override
  State<SatViewKomunikasiUmum> createState() => _SatViewKomunikasiUmumState();
}

class _SatViewKomunikasiUmumState extends State<SatViewKomunikasiUmum> {
  TextEditingController komentar = TextEditingController();
  void clear() {
    komentar.clear();
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initData() async {
    await loadComment();
  }

  Future<void> loadComment() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (ModalRoute.of(context)!.settings.arguments != null) {
        SatKomunikasiModel listUmum =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as SatKomunikasiModel;
        var param2 = listUmum.idumum;
        if (id != null && tokenss != null && param2 != null) {
          context
              .read<SatKomunikasiProvider>()
              .getViewUmum(id: id, tokenss: tokenss, param: param2);
          context
              .read<SatKomunikasiProvider>()
              .getListKomentarUmum(id: id, tokenss: tokenss, param: param2);
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
    final SatKomunikasiModel viewumum =
        ModalRoute.of(context)!.settings.arguments as SatKomunikasiModel;
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
              viewumum.mapel ?? '',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              viewumum.tanggal ?? '',
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
                    if (value.viewUmum.isEmpty) {
                      return const SizedBox.shrink();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.viewUmum.length,
                        itemBuilder: (context, index) {
                          var datas = value.viewUmum[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mata Pelajaran'),
                              Text(datas.namapelajaran ?? '',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                              const Divider(
                                thickness: 0.1,
                              ),
                              const Text('Tahun Ajaran'),
                              Text(datas.tahunajaran ?? '',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                              const Divider(
                                thickness: 0.1,
                              ),
                              const Text('Semester'),
                              Text(datas.semester ?? '',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                              const Divider(
                                thickness: 0.1,
                              ),
                              const Text('Bahasan'),
                              Text(datas.bahasan ?? '',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                              const Divider(
                                thickness: 0.1,
                              ),
                              const Text('Catatan Kelompok'),
                              Text(
                                datas.catatankelompok ?? '',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              const Divider(
                                thickness: 0.1,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              comment(),
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          );
                        },
                      );
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
                            idc: viewumum.idumum ?? '',
                            komentar: komentar.text,
                            kodePegawai:
                                isSiswa ? '' : user.currentuser.siskokode!,
                            nis: isSiswa ? user.currentuser.siskokode! : '',
                          );
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              // ignore: use_build_context_synchronously
                              content: Text(
                                'Berhasil disimpan',
                                style: TextStyle(
                                    // ignore: use_build_context_synchronously
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
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
        if (data.komentarUmum.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.komentarUmum.length,
            itemBuilder: (context, index) {
              final comment = data.komentarUmum[index];
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
