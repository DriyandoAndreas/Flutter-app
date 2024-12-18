import 'package:app5/providers/kelas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sekolahinfo_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/widgets/pengumuman.dart';
import 'package:app5/widgets/teras_sekolah.dart';
import 'package:app5/widgets/today_pengumuman_slider.dart';

class MyschoolPage extends StatefulWidget {
  const MyschoolPage({super.key});

  @override
  State<MyschoolPage> createState() => _MyschoolPageState();
}

class _MyschoolPageState extends State<MyschoolPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var token = user.currentuser.token;
      var npsn = user.currentuser.siskonpsn;
      if (token != null && npsn != null) {
        await context
            .read<SekolahInfoProvider>()
            .getInfoTop(token: token, npsn: npsn);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var akses = user.currentuser.siskostatuslogin;
    bool isSat = false;
    if (akses == 's' || akses == 'a' || akses == 'i') {
      isSat = true;
    }
    Widget profilCard() {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<KelasSatProvider>().getListKelas(id: id, tokenss: tokenss);
      }
      var kelassatprovider =
          Provider.of<KelasSatProvider>(context, listen: false);
      var kelassat = '';
      if (kelassatprovider.listkelas.isNotEmpty) {
        kelassat = kelassatprovider.listkelas.first.namaKelas ?? '';
      }

      return Center(
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Consumer<SekolahInfoProvider>(
            builder: (context, provider, child) {
              String ratedata = provider.infotop.rate ?? '0';
              double rate = double.parse(ratedata);
              double ratingInStars = rate / 20.0;
              var status = provider.infotop.status;
              var bentuk = provider.infotop.bentuk;
              if (status == 'S') {
                status = 'Swasta';
              } else {
                status = 'Negeri';
              }
              return SizedBox(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(12)),
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.infotop.sekolah ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 16,
                                      initialRating: ratingInStars,
                                      allowHalfRating: true,
                                      minRating: 0,
                                      maxRating: 100,
                                      itemCount: 5,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                      onRatingUpdate: (value) {
                                        //
                                      },
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      rate.toStringAsFixed(1),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Card(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text('${bentuk ?? ''} $status',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(provider.infotop.waktukbm ?? '',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                user.currentuser.siskostatuslogin == 'g'
                                    ? Navigator.pushNamed(
                                        context, '/form-rating')
                                    : Navigator.pushNamed(
                                        context, '/form-rating-sat');
                              },
                              child: Text(
                                  'Komentar ${provider.infotop.reviewer ?? ''}')),
                          const Text('|'),
                          isSat ? Text(kelassat) : const SizedBox.shrink(),
                          const Text('|'),
                          Text(
                              'Akreditasi ${provider.infotop.akreditasi ?? ''}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    Widget menuMySchool() {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var akses = user.currentuser.siskostatuslogin;
      bool isSat = false;
      if (akses == 's' || akses == 'a' || akses == 'i') {
        isSat = true;
      }
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-kelas-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-kelas');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-presensi-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-presensi');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-konseling-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-konseling');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-jadwal-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-jadwal');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-nilai-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-nilai');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-perpustakaan-sat')
                                    : Navigator.pushNamed(
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/sat-list-akademik')
                                    : Navigator.pushNamed(
                                        context, '/list-akademik');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-uks-sat')
                                    : Navigator.pushNamed(context, '/list-uks');
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
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-komunikasi-sat')
                                    : Navigator.pushNamed(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            isSat
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/list-keuangan');
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          size: 40,
                                          color: isSat
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                        const Text('Keuangan')
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      NullableIndexedWidgetBuilder;
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.money_off_csred,
                                          size: 40,
                                          color: isSat
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                        Text('Keuangan',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ))
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                isSat
                                    ? Navigator.pushNamed(
                                        context, '/list-polling-sat')
                                    : Navigator.pushNamed(
                                        context, '/list-polling');
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
                            isSat
                                ? const SizedBox(
                                    height: 64,
                                  )
                                : GestureDetector(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                isSat
                    ? Text(user.currentuser.namalengkap ?? '')
                    : Text('${user.currentuser.nama}'),
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
            const SizedBox(
              height: 12,
            ),
            profilCard(),
            menuMySchool(),
            const TerasSekolah(),
            const TodayPengumumanSlider(),
            const Pengumuman(),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
