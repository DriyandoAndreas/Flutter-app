import 'package:flutter/material.dart';
// import 'package:sisko_v5/utils/theme.dart';

class ListMonitoring extends StatelessWidget {
  const ListMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Aktivitas Pengguna"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.file_open,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Progress Implementasi",
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.pie_chart,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Jumlah Koneksi Smartphone",
                    style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.star_border,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Akses Pengguna", style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.article_rounded,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Monitoring Activity (30 hari terakhir)",
                    style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.file_copy_outlined,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Activity Summary (monthly)",
                    style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.group,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Presensi Siswa", style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.groups,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text("Presensi Karyawan", style: TextStyle(fontSize: 18)),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: const Row(children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 30,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Agenda Akademik",
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ),
            const Divider(
              thickness: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
