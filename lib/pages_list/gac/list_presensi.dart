import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/presensi_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';

class ListPresensi extends StatefulWidget {
  const ListPresensi({super.key});

  @override
  State<ListPresensi> createState() => _ListPresensiState();
}

class _ListPresensiState extends State<ListPresensi> {
  String todayformat = '';

  @override
  void initState() {
    super.initState();
    initdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initdata() async {
    try {
      await _loadList();
    } catch (e) {
      throw Exception('Error while init data');
    }
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      context.read<PresensiProvider>().initList(
          id: user.currentuser.siskoid ?? '',
          tokenss: user.currentuser.tokenss ?? '');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _refreshList() async {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    context.read<PresensiProvider>().refresh(
        id: user.currentuser.siskoid ?? '',
        tokenss: user.currentuser.tokenss ?? '');
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String dateFormat = DateFormat.yMMMMd('id_ID').format(today);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Presensi'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          dateFormat,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: const Center(
                              child: Text(
                            "H",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: const Center(
                              child: Text("S",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow.shade600),
                          child: const Center(
                              child: Text("I",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: const Center(
                              child: Text("A",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.brown),
                          child: const Center(
                              child: Text(
                            "T",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Expanded(child: buildList()),
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    return Consumer<PresensiProvider>(
      builder: (context, presensiList, child) {
        if (presensiList.list.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: presensiList.list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (presensiList.list.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final presensi = presensiList.list[index];
                int total = int.parse(presensi.H!) +
                    int.parse(presensi.S!) +
                    int.parse(presensi.I!) +
                    int.parse(presensi.A!) +
                    int.parse(presensi.T!);
                int hadir = int.parse(presensi.H!) + int.parse(presensi.T!);
                double proses = (hadir / total) * 100;
                double hasil = double.parse(proses.toStringAsFixed(0));
                int persentase = hasil.isFinite ? hasil.toInt() : 0;
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/view-presensi-kelas-open',
                            arguments: presensi);
                      },
                      title: Text(presensi.namaKelas!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (presensi.H != null &&
                              presensi.H!.isNotEmpty &&
                              presensi.H != '0')
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                              child: Center(
                                child: Text(
                                  presensi.H!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (presensi.S != null &&
                              presensi.S!.isNotEmpty &&
                              presensi.S != '0')
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Center(
                                child: Text(
                                  presensi.S!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (presensi.I != null &&
                              presensi.I!.isNotEmpty &&
                              presensi.I != '0')
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow.shade600),
                              child: Center(
                                child: Text(
                                  presensi.I!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (presensi.A != null &&
                              presensi.A!.isNotEmpty &&
                              presensi.A != '0')
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              child: Center(
                                child: Text(
                                  presensi.A!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (presensi.T != null &&
                              presensi.T!.isNotEmpty &&
                              presensi.T != '0')
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.brown),
                              child: Center(
                                child: Text(
                                  presensi.T!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (total != 0 && !persentase.isNaN)
                            Text('$total $persentase%'),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 121, 120, 120),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
