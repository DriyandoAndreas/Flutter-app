import 'package:flutter/material.dart';
// import 'package:sisko_v5/utils/theme.dart';

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Biodata"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 0.1,
            ),
            Text('Nomor Induk'),
            Text("123456"),
            Divider(
              thickness: 0.1,
            ),
            Text('Jenis Kelamin'),
            Text("Laki-laki"),
            Divider(
              thickness: 0.1,
            ),
            Text('Tempat , Tgl. Lahir'),
            Text("Riau, 20 April 1998"),
            Divider(
              thickness: 0.1,
            ),
            Text('Nomor Handphone'),
            Text("081328059142"),
            Divider(
              thickness: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
