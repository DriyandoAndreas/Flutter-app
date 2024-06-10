import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/pengumuman_provider.dart';

class Pengumuman extends StatelessWidget {
  const Pengumuman({super.key});

  @override
  Widget build(BuildContext context) {
    PengumumanProvider pengumuman = Provider.of<PengumumanProvider>(context);
    DateTime today = DateTime.now();
    String dateFormat = DateFormat('yyy-MM-dd').format(today);
    int todayPengumuman = 0;
    for (var element in pengumuman.infinitelist) {
      if (element.tgl == dateFormat) {
        todayPengumuman++;
      }
    }
    return Center(
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color.fromARGB(255, 82, 82, 82),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pengumuman',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8)),
                            backgroundColor: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/form-pengumuman');
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  'Pengumuman',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/list-pengumuman');
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.list,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'View All',
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text('Today (${todayPengumuman.toString()})'))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
