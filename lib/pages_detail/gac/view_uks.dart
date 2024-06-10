import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/models/uks_model.dart';
import 'package:sisko_v5/services/uks_service.dart';

class DetailUks extends StatefulWidget {
  const DetailUks({super.key});

  @override
  State<DetailUks> createState() => _DetailUksState();
}

class _DetailUksState extends State<DetailUks> {
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<UksViewObatModel> _obat = [];
  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUsers();
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      UksModel uks =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as UksModel;
      var param2 = uks.kdPeriksa;
      await _loadList(param2!);
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      throw Exception('Failed to fetch data from SQLite');
    }
  }

  Future<void> _loadList(String param2) async {
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;

      if (id != null && tokenss != null) {
        final paginatedList = await UksService().getObatDetail(
          id: id,
          tokenss: tokenss.substring(0, 30),
          param2: param2,
        );
        setState(() {
          _obat = paginatedList;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load data $e');
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('d MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final UksModel uks = ModalRoute.of(context)!.settings.arguments as UksModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesehatan (UKS)'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Card(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${uks.namaLengkap}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
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
                            const Text('Diagnosa:'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('${uks.diagnosa}'),
                            const SizedBox(
                              height: 8,
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
                            const Row(
                              children: [
                                Text('Obat'),
                                Icon(Icons.medication_outlined),
                                Text(':'),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _obat.length,
                                  itemBuilder: (context, index) {
                                    final obat = _obat[index];
                                    return ListTile(
                                      title: Text(
                                        obat.namaObat ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
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
                            const Text('Keterangan:'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('${uks.ket}'),
                            const SizedBox(
                              height: 8,
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
                            Text(
                              formatDate('${uks.tglPeriksa}'),
                            ),
                            Text('${uks.paraf}'),
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
