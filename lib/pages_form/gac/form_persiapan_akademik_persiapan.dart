import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/akademik_service.dart';

class FormPersiapanAkademikPersiapan extends StatefulWidget {
  const FormPersiapanAkademikPersiapan({super.key});

  @override
  State<FormPersiapanAkademikPersiapan> createState() =>
      _FormPersiapanAkademikPersiapanState();
}

class _FormPersiapanAkademikPersiapanState
    extends State<FormPersiapanAkademikPersiapan> {
  TextEditingController deskripsimenarik = TextEditingController();
  TextEditingController halpersiapan = TextEditingController();
  TextEditingController zoomlink = TextEditingController();

  bool konfirmasiGuru = false;
  bool isLoading = false;
  bool isInitialized = false;
  String? selectedMateri;
  String? selectedSemua;
  List<String> materis = [];
  List<String> semuaMateri = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var idakademik = arguments['id_akademik'];
    var id = user.currentuser.siskonpsn;
    var token = user.currentuser.token;
    var action = 'edit';
    if (id != null && token != null && idakademik != null) {
      context.read<AkademikProvider>().persiapanPersiapan(
          id: id, tokenss: token, action: action, idakademik: idakademik);
      context.read<AkademikProvider>().getMateri(token: token);
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Theme.of(context).colorScheme.primaryFixed,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Consumer<AkademikProvider>(
                    builder: (context, provider, child) {
                      if (!isInitialized && provider.persiapan != null) {
                        deskripsimenarik.text =
                            provider.persiapan?.deskripsimenarik ?? '';
                        halpersiapan.text =
                            provider.persiapan?.halpersiapan ?? '';
                        zoomlink.text = provider.persiapan?.zoomlink ?? '';
                        konfirmasiGuru =
                            provider.persiapan?.konfirmasiguru == '1';
                        isInitialized = true;
                      }
                      if (provider.persiapan == null) {
                        return const SizedBox.shrink();
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              color: const Color.fromARGB(255, 82, 82, 82),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Akademik',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text('Deskripsi yang menginspirasi siswa',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                  controller: deskripsimenarik,
                                  maxLines: 4,
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      hintText: "Tuliskan deskripsi"),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text('Persiapan Siswa',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                  controller: halpersiapan,
                                  maxLines: 4,
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      hintText:
                                          "Infokan yang perlu di siapkan"),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'Video Conference Link',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                  controller: zoomlink,
                                  maxLines: 2,
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      hintText:
                                          "contoh: https://meet.googe.com/abc-def"),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Konfirmasi Guru',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                    value: konfirmasiGuru,
                                    onChanged: (value) {
                                      setState(() {
                                        konfirmasiGuru = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                8)),
                                    backgroundColor:
                                        const Color.fromARGB(255, 73, 72, 72),
                                  ),
                                  onPressed: () async {
                                    final user =
                                        Provider.of<SqliteUserProvider>(context,
                                            listen: false);
                                    final service = AkademikService();
                                    final scaffold =
                                        ScaffoldMessenger.of(context);
                                    var id = user.currentuser.siskonpsn;
                                    var tokenss = user.currentuser.tokenss;
                                    var action = 'update-aka-persiapan';
                                    var kodeakademik =
                                        arguments['kode_akademik'];
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (id != null &&
                                          tokenss != null &&
                                          kodeakademik != null) {
                                        await service.updatePersiapan(
                                          id: id,
                                          tokenss: tokenss,
                                          action: action,
                                          kodeakademik: kodeakademik,
                                          idakademik:
                                              arguments['id_akademik'] ?? '',
                                          halpersiapan: deskripsimenarik.text,
                                          tugassiswa: halpersiapan.text,
                                          konfirmasiguru:
                                              konfirmasiGuru ? '1' : '0',
                                          zoomlink: zoomlink.text,
                                        );
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              // ignore: use_build_context_synchronously
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                      ? const CircularProgressIndicator
                                          .adaptive(
                                          backgroundColor: Colors.white,
                                        )
                                      : const Text(
                                          'Simpan',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
