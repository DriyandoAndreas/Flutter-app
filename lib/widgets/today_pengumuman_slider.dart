import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sisko_v5/models/pengumuman_model.dart';
import 'package:sisko_v5/providers/pengumuman_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';

class TodayPengumumanSlider extends StatelessWidget {
  const TodayPengumumanSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);

    String id = user.currentuser.siskoid.toString();
    String tokenss = user.currentuser.tokenss.toString();
    if (user.currentuser.siskoid != null && user.currentuser.tokenss != null) {
      context.watch<PengumumanProvider>().initInfinite(
            id: id,
            tokenss: tokenss.substring(0, 30),
          );
    }
    final pengumumanProvider = Provider.of<PengumumanProvider>(context);
    DateTime today = DateTime.now();
    String dateFormat = DateFormat('yyy-MM-dd').format(today);

    List<PengumumanModel> todayAnnouncements = pengumumanProvider.infinitelist
        .where((element) => element.tgl == dateFormat)
        .toList();

    int count = 0;
    if (todayAnnouncements.length > 1) {
      count = todayAnnouncements.length;
    }
    if (todayAnnouncements.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        child: const Center(child: SizedBox.shrink()),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          aspectRatio: 16 / 9,
          viewportFraction: count > 1 ? 0.8 : 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: todayAnnouncements.map((announcement) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/view-pengumuman',
                      arguments: announcement);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(announcement.image ?? ''),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                announcement.judul ?? '',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    announcement.post ?? '',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color:
                                            Color.fromARGB(255, 121, 120, 120)),
                                  ),
                                  Text(
                                    announcement.tgl ?? '',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color:
                                            Color.fromARGB(255, 121, 120, 120)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
