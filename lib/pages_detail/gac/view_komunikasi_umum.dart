import 'package:flutter/material.dart';
import 'package:sisko_v5/models/komunikasi_model.dart';

class DetailKomunikasiUmum extends StatefulWidget {
  const DetailKomunikasiUmum({super.key});

  @override
  State<DetailKomunikasiUmum> createState() => _DetailKomunikasiUmumState();
}

class _DetailKomunikasiUmumState extends State<DetailKomunikasiUmum> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final KomunikasiUmumModel listUmum =
        ModalRoute.of(context)!.settings.arguments as KomunikasiUmumModel;
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mata Pelajaran'),
              Text(listUmum.mapel ?? ''),
              const Divider(
                thickness: 0.1,
              ),
              const Text('Tahun Ajaran'),
              Text(listUmum.tahunAjaran ?? ''),
              const Divider(
                thickness: 0.1,
              ),
              const Text('Semester'),
              Text(listUmum.semester ?? ''),
              const Divider(
                thickness: 0.1,
              ),
              const Text('Bahasan'),
              Text(listUmum.bahasan ?? ''),
              const Divider(
                thickness: 0.1,
              ),
              const Text('Catatan Kelompok'),
              Text(listUmum.catatanKel ?? ''),
              const Divider(
                thickness: 0.1,
              ),
              const SizedBox(
                height: 20,
              ),
              //TODO: buat conditional rendering untuk tampilkan tanggapan dengan lisview
              Card(
                surfaceTintColor: Colors.grey.shade400,
                shadowColor: Colors.grey.shade600,
                margin: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
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
                    //TODO: buat service untuk tambah tanggapan

                    // try {
                    //   // ignore: use_build_context_synchronously
                    //   final scaffold = ScaffoldMessenger.of(context);

                    //   if (id != null && tokenss != null) {
                    //     String guruValue = ischeckedGuru ? 'GR' : '';
                    //     String karyawanValue = ischeckedKaryawan ? 'KR' : '';
                    //     String siswaValue = ischeckedSis ? 'SIS' : '';

                    //     List<String> values = [];
                    //     if (guruValue.isNotEmpty) values.add(guruValue);
                    //     if (karyawanValue.isNotEmpty) values.add(karyawanValue);
                    //     if (siswaValue.isNotEmpty) values.add(siswaValue);

                    //     String untuk = values.join(',');
                    //     tokenss = tokenss?.substring(0, 30);
                    //     if (base64Image == null) {
                    //       scaffold.showSnackBar(
                    //         SnackBar(
                    //           content: const Text('Gambar tidak boleh kosong'),
                    //           duration: const Duration(seconds: 1),
                    //           behavior: SnackBarBehavior.floating,
                    //           margin: EdgeInsets.only(
                    //             // ignore: use_build_context_synchronously
                    //             bottom:
                    //                 MediaQuery.of(context).size.height - 150,
                    //             left: 15,
                    //             right: 15,
                    //           ),
                    //         ),
                    //       );
                    //     } else if (judul.text.isEmpty) {
                    //       scaffold.showSnackBar(
                    //         SnackBar(
                    //           content: const Text('Judul tidak boleh kosong'),
                    //           duration: const Duration(seconds: 1),
                    //           behavior: SnackBarBehavior.floating,
                    //           margin: EdgeInsets.only(
                    //             // ignore: use_build_context_synchronously
                    //             bottom:
                    //                 MediaQuery.of(context).size.height - 150,
                    //             left: 15,
                    //             right: 15,
                    //           ),
                    //         ),
                    //       );
                    //     } else if (isi.text.isEmpty) {
                    //       scaffold.showSnackBar(
                    //         SnackBar(
                    //           content: const Text('Konten tidak boleh kosong'),
                    //           duration: const Duration(seconds: 1),
                    //           behavior: SnackBarBehavior.floating,
                    //           margin: EdgeInsets.only(
                    //             // ignore: use_build_context_synchronously
                    //             bottom:
                    //                 MediaQuery.of(context).size.height - 150,
                    //             left: 15,
                    //             right: 15,
                    //           ),
                    //         ),
                    //       );
                    //     } else {
                    //       setState(() {
                    //         isloading = true;
                    //       });
                    //       await PengumumanService().addPengumuman(
                    //         id: id,
                    //         tokenss: tokenss.toString(),
                    //         idc: '',
                    //         action: 'add',
                    //         imageUrl: 'data:image/jpg;base64,$base64Image',
                    //         tanggal: inputDate,
                    //         judul: judul.text,
                    //         isi: isi.text,
                    //         wysiwyg: '0',
                    //         untuk: untuk,
                    //       );

                    //       scaffold.showSnackBar(
                    //         SnackBar(
                    //           content:
                    //               const Text('Pengumuman berhasil ditambahkan'),
                    //           duration: const Duration(seconds: 1),
                    //           behavior: SnackBarBehavior.floating,
                    //           margin: EdgeInsets.only(
                    //             // ignore: use_build_context_synchronously
                    //             bottom:
                    //                 // ignore: use_build_context_synchronously
                    //                 MediaQuery.of(context).size.height - 150,
                    //             left: 15,
                    //             right: 15,
                    //           ),
                    //         ),
                    //       );
                    //       // ignore: use_build_context_synchronously
                    //       Future.delayed(const Duration(seconds: 2), () {
                    //         Navigator.of(context).pop();
                    //       });
                    //       setState(() {
                    //         isloading = false;
                    //       });
                    //     }
                    //   } else {
                    //     scaffold.showSnackBar(
                    //       SnackBar(
                    //         content: const Text('Pengumuman gagal ditambahkan'),
                    //         duration: const Duration(seconds: 1),
                    //         behavior: SnackBarBehavior.floating,
                    //         margin: EdgeInsets.only(
                    //           // ignore: use_build_context_synchronously
                    //           bottom: MediaQuery.of(context).size.height - 150,
                    //           left: 15,
                    //           right: 15,
                    //         ),
                    //       ),
                    //     );
                    //   }
                    // } catch (e) {
                    //   throw Exception('$e');
                    // }
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
                          'Submit',
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
