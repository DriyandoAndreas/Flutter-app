import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:sisko_v5/models/pengumuman_model.dart';

class DetailPengumuman extends StatelessWidget {
  const DetailPengumuman({super.key});

  @override
  Widget build(BuildContext context) {
    final PengumumanModel pengumuman =
        ModalRoute.of(context)!.settings.arguments as PengumumanModel;
    String tanggal = pengumuman.tgl!;
    DateTime tgl = DateTime.parse(tanggal);
    var formattgl = DateFormat("d MMM yyyy").format(tgl);
    String data = pengumuman.isi!;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pengumuman.judul!),
            Text(
              formattgl,
              style: const TextStyle(fontSize: 12),
            ),
          ])),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                pengumuman.image!,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, size: 300),
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Html(data: data),
              Text('Penulis: ${pengumuman.pembuat ?? ''}')
            ],
          ),
        ),
      ),
    );
  }
}
