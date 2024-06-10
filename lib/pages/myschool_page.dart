import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';
import 'package:sisko_v5/widgets/pengumuman.dart';
import 'package:sisko_v5/widgets/teras_sekolah.dart';
import 'package:sisko_v5/widgets/today_pengumuman_slider.dart';

class MyschoolPage extends StatelessWidget {
  const MyschoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    Widget profilCard() {
      return Center(
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: SizedBox(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(12)),
                  child: Container(
                    color: const Color.fromARGB(255, 136, 134, 134),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nama sekolah',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                RatingBar.builder(
                                  itemSize: 16,
                                  initialRating: 4,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                  ),
                                  onRatingUpdate: (value) {},
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  '4',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Column(
                          children: [
                            Text('SMK/SMA',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 8,
                            ),
                            Text('KBM ... Hari',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 8,
                            ),
                            Text('08:00-16:00',
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Komentar'),
                      Text('|'),
                      Text('|'),
                      Text('Akreditasi'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget menuMySchool() {
      return Center(
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: SizedBox(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-kelas');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.table_view,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                  Text('Kelas')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-presensi');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.sensors,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                  Text('Presensi')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-konseling');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.group,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  Text('Konseling')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-jadwal');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                  Text('Jadwal')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-nilai');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.note_add,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                  Text('Nilai')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/list-perpustakaan');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  Text('Perpustakaan')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-akademik');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.library_books,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  Text('Akademik')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-uks');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.medical_services,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                  Text('Kesehatan')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/list-komunikasi');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.forum,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  Text('Komunikasi')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-keuangan');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                  Text('Keuangan')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-polling');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.poll,
                                    size: 40,
                                    color: Colors.green,
                                  ),
                                  Text('Polling')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list-cctv');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.camera_outdoor,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  Text('CCTV')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/list-monitoring');
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.dashboard_customize,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  Text('Monitoring')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/landingpage');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_circle_outlined,
                size: 35,
              )
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/biodata');
            },
            child: Row(
              children: [
                Text('${user.currentuser.nama}'),
                const SizedBox(
                  width: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('${user.currentuser.photo}'),
                      onBackgroundImageError: (exception, stackTrace) {
                        const Icon(Icons.image);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profilCard(),
            menuMySchool(),
            const TerasSekolah(),
            const TodayPengumumanSlider(),
            const Pengumuman(),
          ],
        ),
      ),
    );
  }
}
