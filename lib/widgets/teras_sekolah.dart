import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/providers/berita_provider.dart';
import 'package:sisko_v5/providers/sqlite_user_provider.dart';

class TerasSekolah extends StatelessWidget {
  const TerasSekolah({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);

    bool isSiswa = false;
    int limit = 3;
    String id = user.currentuser.siskoid.toString();
    String tokenss = user.currentuser.tokenss.toString();
    if (user.currentuser.siskoid != null && user.currentuser.tokenss != null) {
      context
          .watch<BeritaProvider>()
          .fetchList(id: id, tokenss: tokenss.substring(0, 30), limit: limit);
    }
    if (user.currentuser.siskostatuslogin == 's') {
      isSiswa = true;
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
                          'Teras sekolah',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        isSiswa
                            ? const SizedBox()
                            : TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/form-teras-sekolah');
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(8)),
                                  backgroundColor: Colors.white,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.add, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text(
                                      'Add',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Consumer<BeritaProvider>(
                    builder: (context, berita, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: berita.list.length,
                        itemBuilder: (context, index) {
                          final terasSekolah = berita.list[index];
                          DateTime date =
                              DateTime.parse(terasSekolah.tgl ?? '');
                          String dateFormat =
                              DateFormat('d MMM yyyy').format(date);
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/view-teras-sekolah',
                                    arguments: terasSekolah,
                                  );
                                },
                                title: Text('${terasSekolah.judul}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      terasSekolah.post ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 121, 120, 120)),
                                    ),
                                    Text(
                                      terasSekolah.pembuat ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(
                                              255, 121, 120, 120)),
                                    ),
                                  ],
                                ),
                                leading: Image.network(
                                  terasSekolah.image.toString(),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image, size: 60);
                                  },
                                ),
                                trailing: Text(
                                  dateFormat,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 121, 120, 120)),
                                ),
                              ),
                              const Divider(
                                thickness: 0.1,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/list-teras-sekolah');
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
