import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app5/models/konseling_model.dart';

class DetailKonseling extends StatefulWidget {
  const DetailKonseling({super.key});

  @override
  State<DetailKonseling> createState() => _DetailKonselingState();
}

class _DetailKonselingState extends State<DetailKonseling> {
  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('d MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final KonselingModel konseling =
        ModalRoute.of(context)!.settings.arguments as KonselingModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Konseling'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: const Color.fromARGB(255, 82, 82, 82),
                        child: Column(
                          children: [
                            Text(
                              konseling.nama!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              konseling.kasus!,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              konseling.penanganan!,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDate(konseling.tanggal!),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                            Text(konseling.nilai!,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
