import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/playlist_mengajar_provider_today.dart';
import 'package:app5/providers/playlist_mengajar_provider_tomorrow.dart';
import 'package:app5/providers/playlist_mengajar_provider_tomorrow_after.dart';
import 'package:app5/widgets/playlist_mengajar_dayaftertomorrow.dart';
import 'package:app5/widgets/playlist_mengajar_today.dart';
import 'package:app5/widgets/playlist_mengajar_tomorrow.dart';

class PlaylistMengajar extends StatelessWidget {
  const PlaylistMengajar({super.key});

  @override
  Widget build(BuildContext context) {
    return playList(
      context,
    );
  }

  Widget playList(
    context,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.secondary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Playlist Mengajar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/list-akademik');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(8)),
                        backgroundColor: Colors.white,
                      ),
                      child: Consumer3<
                          PlaylistMengajarProviderToday,
                          PlaylistMengajarProviderTomorrow,
                          PlaylistMengajarProviderTomorrowAfter>(
                        builder: (BuildContext context, value, value2, value3,
                            Widget? child) {
                          return Row(
                            children: [
                              value.timeline.isEmpty &&
                                      value2.tommorrowtimeline.isEmpty &&
                                      value3.tommorrowaftertimeline.isEmpty
                                  ? const Icon(Icons.add, color: Colors.black)
                                  : const Icon(Icons.list, color: Colors.black),
                              const SizedBox(width: 8),
                              value.timeline.isEmpty &&
                                      value2.tommorrowtimeline.isEmpty &&
                                      value3.tommorrowaftertimeline.isEmpty
                                  ? const Text(
                                      'Buat',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : const Text(
                                      'Selengkapnya',
                                      style: TextStyle(color: Colors.black),
                                    )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Column(
                children: [
                  PlaylistMengajarToday(),
                  PlaylistMengajarTomorrow(),
                  PlaylistMengajarDayAfterTomorrow(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
