import 'package:flutter/material.dart';

class ListMonitoring extends StatelessWidget {
  const ListMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-progress-implementasi');
              },
              child: Container(
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
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-koneksi-phone');
              },
              child: Container(
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
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-monitoring-aktifitas');
              },
              child: Container(
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
            ),
            const Divider(
              thickness: 0.1,
            ),
            // TODO: overflow layar < 600px
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-monitoring-30day');
              },
              child: Container(
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
                  Text(
                    "Monitoring Activity (30 hari terakhir)",
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-activity-summary');
              },
              child: Container(
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
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-monitoring-presensi-siswa');
              },
              child: Container(
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
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, '/view-monitoring-presensi-karaywan');
              },
              child: Container(
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
                  Text("Presensi Pegawai", style: TextStyle(fontSize: 18)),
                ]),
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/view-monitoring-akademik');
              },
              child: Container(
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
