import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app5/models/teras_sekolah_model.dart';

class DetailTerasSekolah extends StatelessWidget {
  const DetailTerasSekolah({super.key});

  @override
  Widget build(BuildContext context) {
    final TerasSekolahModel terasSekolah =
        ModalRoute.of(context)!.settings.arguments as TerasSekolahModel;
    String tanggal = terasSekolah.tgl!;
    DateTime tgl = DateTime.parse(tanggal);
    var formattgl = DateFormat("d MMM yyyy").format(tgl);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(terasSekolah.judul!),
            Text(
              formattgl,
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
              Image.network(
                terasSekolah.image!,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image,
                      size: 300,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Text(terasSekolah.post!),
              const SizedBox(
                height: 12,
              ),
              Text('Penulis: ${terasSekolah.pembuat!}'),
            ],
          ),
        ),
      ),
    );
  }
}
