import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PlaylistMengajar extends StatefulWidget {
  const PlaylistMengajar({super.key});

  @override
  State<PlaylistMengajar> createState() => _PlaylistMengajarState();
}

class _PlaylistMengajarState extends State<PlaylistMengajar> {
  bool isConfirmed = false;
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return playList();
  }

  Widget alertActionKonfirmasi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isConfirmed = true;
            });
            Navigator.pop(context, 'Mulai');
          },
          child: const Text("Mulai"),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActionMulai() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isFinished = true;
            });
            Navigator.pop(context);
          },
          child: const Text("Selesai"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Presesnsi"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActionSelesai() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Laporan"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Kembali');
          },
          child: const Text("Kembali"),
        ),
      ],
    );
  }

  Widget alertActions(String status) {
    switch (status) {
      case 'Konfirmasi':
        return alertActionKonfirmasi();
      case 'Mulai':
        return alertActionMulai();
      case 'Selesai':
        return alertActionSelesai();
      default:
        return alertActionKonfirmasi();
    }
  }

  Widget playList() {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color.fromARGB(255, 82, 82, 82),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Playlist',
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
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Buat',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TODO: butuh plugin untuk timeline dengan listbuilder
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TimelineTile(
                      isFirst: true,
                      beforeLineStyle: LineStyle(color: Colors.green.shade400),
                      indicatorStyle:
                          IndicatorStyle(color: Colors.green.shade400),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      startChild: const Text("08:00"),
                      endChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //const Text("Hari ini"),
                          Card(
                            color: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black)),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("08:00"),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: isConfirmed
                                                ? (isFinished
                                                    ? Colors.blue.shade400
                                                    : Colors.green.shade400)
                                                : Colors.orange.shade600),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Bahasa Indonesia",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          isConfirmed
                                                              ? (isFinished
                                                                  ? Colors.blue
                                                                      .shade400
                                                                  : Colors.green
                                                                      .shade400)
                                                              : Colors.orange
                                                                  .shade600),
                                                  onPressed: () {},
                                                  child: Text(
                                                    isConfirmed
                                                        ? (isFinished
                                                            ? 'Selesai'
                                                            : 'Mulai')
                                                        : 'Konfirmasi',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content:
                                                const Text('Mulai Mengajar?'),
                                            actions: <Widget>[
                                              isConfirmed
                                                  ? (isFinished
                                                      ? alertActions('Selesai')
                                                      : alertActions('Mulai'))
                                                  : alertActions('Konfrimasi')
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          isConfirmed
                                              ? (isFinished
                                                  ? 'Selesai'
                                                  : 'Mulai')
                                              : 'Konfirmasi',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text("Bahasa Indonesia"),
                                  const Text("10 IPA 1"),
                                  const Text("Materi persiapan: "),
                                  const Text("persiapan siswa: "),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.book,
                                              color: Colors.green,
                                            ),
                                            Text("Materi"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.red,
                                            ),
                                            Text("View"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.chat,
                                              color: Colors.blue,
                                            ),
                                            Text("Kelas"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TimelineTile(
                      alignment: TimelineAlign.manual,
                      indicatorStyle: const IndicatorStyle(
                          color: Color.fromARGB(255, 233, 210, 0)),
                      beforeLineStyle: const LineStyle(
                          color: Color.fromARGB(255, 233, 210, 0)),
                      lineXY: 0.2,
                      startChild: const Text("Besok"),
                      endChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text("Besok"),
                          Card(
                            color: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black)),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("08:00"),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.green.shade400),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Bahasa Indonesia",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: Colors
                                                          .green.shade400),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Mulai',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                                'Apakah telah selesai mengajar?\nAtau mau input presensi siswa?'),
                                            actions: <Widget>[
                                              alertActionMulai()
                                            ],
                                          ),
                                        ),
                                        child: const Text(
                                          'Mulai',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text("Bahasa Indonesia"),
                                  const Text("10 IPA 1"),
                                  const Text("Materi persiapan: "),
                                  const Text("persiapan siswa: "),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.book,
                                              color: Colors.green,
                                            ),
                                            Text("Materi"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.red,
                                            ),
                                            Text("View"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.chat,
                                              color: Colors.blue,
                                            ),
                                            Text("Kelas"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TimelineTile(
                      isLast: true,
                      alignment: TimelineAlign.manual,
                      lineXY: 0.2,
                      indicatorStyle: const IndicatorStyle(color: Colors.red),
                      beforeLineStyle: const LineStyle(color: Colors.red),
                      startChild: const Text("Lusa"),
                      endChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text("Lusa"),
                          Card(
                            color: Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black)),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("08:00"),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade400),
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Bahasa Indonesia",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.blue.shade400),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Selesai',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                                'Silahkan membuat laporan mengajar untuk melengkapi jurnal harian'),
                                            actions: <Widget>[
                                              alertActions('Konfirmasi')
                                            ],
                                          ),
                                        ),
                                        child: const Text(
                                          'Selesai',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text("Bahasa Indonesia"),
                                  const Text("10 IPA 1"),
                                  const Text("Materi persiapan: "),
                                  const Text("persiapan siswa: "),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.book,
                                              color: Colors.green,
                                            ),
                                            Text("Materi"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.red,
                                            ),
                                            Text("View"),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.chat,
                                              color: Colors.blue,
                                            ),
                                            Text("Kelas"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
