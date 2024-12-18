import 'package:flutter/material.dart';

class FormPersiapanAkademikInfo extends StatefulWidget {
  const FormPersiapanAkademikInfo({super.key});

  @override
  State<FormPersiapanAkademikInfo> createState() =>
      _FormPersiapanAkademikInfoState();
}

class _FormPersiapanAkademikInfoState extends State<FormPersiapanAkademikInfo> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var tahunajaran = arguments['tahun_ajaran'];
    var semester = arguments['semester'];
    var namakelas = arguments['nama_kelas'];
    var namamapel = arguments['nama_pelajaran'];
    var namalengkap = arguments['nama_lengkap'];
    var tanggal = arguments['tanggal'];
    var mulai = arguments['mulai'];
    var selesai = arguments['selesai'];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahun Ajaran/Semester',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$tahunajaran/$semester',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Kelas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$namakelas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Nama Pelajaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$namamapel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Guru',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            namalengkap ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Ruangan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Fasilitas Penunjang',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.close),
                    Text('Proyektor'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.close),
                    Text('Komputer'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.close),
                    Text('Lainnya'),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Tanggal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$tanggal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          const Text(
            'Jam',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$mulai-$selesai',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
