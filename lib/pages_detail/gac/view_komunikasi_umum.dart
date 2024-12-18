import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/komunikasi_model.dart';
import 'package:app5/providers/komunikasi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/komunikasi_service.dart';

class DetailKomunikasiUmum extends StatefulWidget {
  const DetailKomunikasiUmum({super.key});

  @override
  State<DetailKomunikasiUmum> createState() => _DetailKomunikasiUmumState();
}

class _DetailKomunikasiUmumState extends State<DetailKomunikasiUmum> {
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
        KomunikasiUmumModel listUmum =
            // ignore: use_build_context_synchronously
            ModalRoute.of(context)!.settings.arguments as KomunikasiUmumModel;
        var param2 = listUmum.idUmum;
        if (id != null && tokenss != null && param2 != null) {
          context.read<KomunikasiProvider>().initListComment(
              id: id, tokenss: tokenss, param2: param2, param3: 'umum');
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
    final KomunikasiUmumModel listUmum =
        ModalRoute.of(context)!.settings.arguments as KomunikasiUmumModel;
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
              listUmum.mapel ?? '',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              listUmum.tanggal ?? '',
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
                const Text('Mata Pelajaran'),
                Text(listUmum.mapel ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Tahun Ajaran'),
                Text(listUmum.tahunAjaran ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Semester'),
                Text(listUmum.semester ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Bahasan'),
                Text(listUmum.bahasan ?? '',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Catatan Kelompok'),
                Text(
                  listUmum.catatanKel ?? '',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                          if (user.currentuser.siskoHakAkses == 's' ||
                              user.currentuser.siskoHakAkses == 'i' ||
                              user.currentuser.siskoHakAkses == 'a') {
                            isSiswa = true;
                          }
                          await KomunikasiService().addComment(
                            id: id,
                            tokenss: tokenss.substring(0, 30),
                            action: 'comment',
                            tabel: 'umum',
                            idc: listUmum.idUmum ?? '',
                            komentar: komentar.text,
                            kodePegawai: user.currentuser.siskokode ?? '',
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
    return Consumer<KomunikasiProvider>(
      builder: (context, listComment, child) {
        if (listComment.listComment.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return ListView.builder(
            shrinkWrap: true, // Menyusutkan ukuran ListView sesuai jumlah item
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView
            itemCount: listComment.listComment.length,
            itemBuilder: (context, index) {
              final comment = listComment.listComment[index];
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
                        comment.namaLengkap ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.tanggalWaktu ?? '',
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
