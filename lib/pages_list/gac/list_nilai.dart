import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListNilai extends StatefulWidget {
  const ListNilai({super.key});

  @override
  State<ListNilai> createState() => _ListNilaiState();
}

class _ListNilaiState extends State<ListNilai> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadList();
  }

  Future<void> _loadList() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if (id!=null && tokenss != null) {
        context.read<NilaiProvider>().initKelas(
              id: id,
              tokenss: tokenss.substring(0, 30),
            );
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NilaiProvider>(context);
    final kelasNilai =
        provider.listKelas.isNotEmpty ? provider.listKelas.first : null;
    String? thnAjaran = kelasNilai?.thnAj;
    String? semester = kelasNilai?.semester;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Nilai'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Semester $semester',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Th. Ajaran $thnAjaran',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 0.1,
              ),
              Expanded(
                child: buildList(),
              )
            ],
          ),
        ));
  }

  Widget buildList() {
    return Consumer<NilaiProvider>(
      builder: (context, kelas, child) {
        if (kelas.listKelas.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: kelas.hasMore
                ? kelas.listKelas.length + 1
                : kelas.listKelas.length,
            itemBuilder: (context, index) {
              if (index < kelas.listKelas.length) {
                final kelass = kelas.listKelas[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/jenis-mapel',
                            arguments: kelass);
                      },
                      title: Text(kelass.namaKelas ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else if (index == kelas.listKelas.length) {
                return const SizedBox.shrink();
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          );
        }
      },
    );
  }
}
