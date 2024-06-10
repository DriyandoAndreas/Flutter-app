import 'package:flutter/material.dart';
import 'package:sisko_v5/models/nilai_model.dart';

class FormAddNilai extends StatefulWidget {
  const FormAddNilai({super.key});

  @override
  State<FormAddNilai> createState() => _FormAddNilaiState();
}

class _FormAddNilaiState extends State<FormAddNilai> {
  @override
  Widget build(BuildContext context) {
    final NilaiJenisModel mapel =
        ModalRoute.of(context)!.settings.arguments as NilaiJenisModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(mapel.namaTes ?? ''),
      ),
      //TODO: buat list untuk input nilai
    );
  }
}
