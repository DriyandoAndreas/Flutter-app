import 'package:app5/models/presensi_model.dart';
import 'package:flutter/material.dart';

class ViewSuratSakit extends StatelessWidget {
  const ViewSuratSakit({super.key});

  @override
  Widget build(BuildContext context) {
    final PresensiKelasOpenModel presensi =
        ModalRoute.of(context)!.settings.arguments as PresensiKelasOpenModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Surat Sakit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [Image.network('${presensi.file}')],
        ),
      ),
    );
  }
}
