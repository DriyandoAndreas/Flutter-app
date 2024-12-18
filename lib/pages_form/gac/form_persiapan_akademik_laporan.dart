import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/akademik_service.dart';

class FormPersiapanAkademikLaporan extends StatefulWidget {
  const FormPersiapanAkademikLaporan({super.key});

  @override
  State<FormPersiapanAkademikLaporan> createState() =>
      _FormPersiapanAkademikLaporanState();
}

class _FormPersiapanAkademikLaporanState
    extends State<FormPersiapanAkademikLaporan> {
  bool isLoading = false;
  TextEditingController materi = TextEditingController();
  TextEditingController media = TextEditingController();
  TextEditingController kegiatan = TextEditingController();
  TextEditingController hambatan = TextEditingController();
  TextEditingController tugas = TextEditingController();
  TextEditingController persiapan = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var idakademik = arguments['id_akademik'];
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    var action = 'edit';
    if (id != null && tokenss != null && idakademik != null) {
      context.read<AkademikProvider>().persiapanLaporan(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AkademikProvider>(
          builder: (context, provider, child) {
            if (provider.laporan == null) {
              return const SizedBox.shrink();
            } else {
              materi.text = provider.laporan?.materi ?? '';
              media.text = provider.laporan?.media ?? '';
              kegiatan.text = provider.laporan?.kegiatan ?? '';
              tugas.text = provider.laporan?.tugas ?? '';
              hambatan.text = provider.laporan?.hambatan ?? '';
              persiapan.text = provider.laporan?.persiapanselanjutnya ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Materi yang diberian',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: materi,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.materi ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const Text(
                    'Media / Alat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: media,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.media ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const Text(
                    'Kegiatan Belajar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: kegiatan,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.kegiatan ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const Text(
                    'Tugas / Pekerjaan Rumah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: tugas,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.tugas ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const Text(
                    'Hambatan / Kendala',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: hambatan,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.hambatan ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const Text(
                    'Persiapan pertemuan berikutnya',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: persiapan,
                    maxLines: 2, //or null
                    decoration: InputDecoration.collapsed(
                        hintText: provider.laporan?.persiapanselanjutnya ?? ''),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(8)),
                        backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                      ),
                      onPressed: () async {
                        final user = Provider.of<SqliteUserProvider>(context,
                            listen: false);
                        final service = AkademikService();
                        final scaffold = ScaffoldMessenger.of(context);
                        var id = user.currentuser.siskonpsn;
                        var tokenss = user.currentuser.tokenss;
                        var action = 'update-aka-laporan-guru';
                        var kodeakademik = arguments['kode_akademik'];
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          if (id != null &&
                              tokenss != null &&
                              kodeakademik != null) {
                            await service.updateLaporan(
                              id: id,
                              tokenss: tokenss,
                              action: action,
                              idakademik: arguments['id_akademik'] ?? '',
                              kodeakademik: kodeakademik,
                              materi: materi.text,
                              media: media.text,
                              hambatan: hambatan.text,
                              kegiatan: kegiatan.text,
                              persiapan: persiapan.text,
                              tugas: tugas.text,
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text(
                                'Berhasil update',
                                style: TextStyle(
                                    color:
                                        // ignore: use_build_context_synchronously
                                        Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                            ),
                          );
                        } catch (e) {
                          return;
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            )
                          : const Text(
                              'Simpan Laporan',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
