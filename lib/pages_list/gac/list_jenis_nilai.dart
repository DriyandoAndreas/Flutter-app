import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/nilai_model.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListJenisNilai extends StatefulWidget {
  const ListJenisNilai({super.key});

  @override
  State<ListJenisNilai> createState() => _ListJenisNilaiState();
}

class _ListJenisNilaiState extends State<ListJenisNilai> {
  bool _isInit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initData();
      _isInit = false;
    }
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
      if (id != null && tokenss != null) {
        context.read<NilaiProvider>().initJenisNilai(
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
    final ListNilaiMapelModel kelas =
        ModalRoute.of(context)!.settings.arguments as ListNilaiMapelModel;
    final provider = Provider.of<NilaiProvider>(context);
    final jenisNilai =
        provider.listKelas.isNotEmpty ? provider.listKelas.first : null;
    String? thnAjaran = jenisNilai?.thnAj;
    String? semester = jenisNilai?.semester;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nilai'),
            Text(
              kelas.namaPljrn!,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Semester $semester',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Th. Ajaran $thnAjaran',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 0.1,
            ),
            Expanded(
              child: buildList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    final ListNilaiMapelModel kelas =
        ModalRoute.of(context)!.settings.arguments as ListNilaiMapelModel;
    return Consumer<NilaiProvider>(
      builder: (context, jenisNilai, child) {
        if (jenisNilai.listJenisNilai.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: jenisNilai.hasMore
                ? jenisNilai.listJenisNilai.length + 1
                : jenisNilai.listJenisNilai.length,
            itemBuilder: (context, index) {
              if (index < jenisNilai.listJenisNilai.length) {
                final nilai = jenisNilai.listJenisNilai[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        //to form nilai
                        Navigator.pushNamed(context, '/form-add-nilai',
                            arguments: {
                              'jp': nilai,
                              'kodePelajaran': kelas.kodePelajaran,
                              'kodeMengajar': kelas.kodeMengajar,
                              'kodeKelas': kelas.kodeKelas,
                            });
                      },
                      title: Text(nilai.namaTes ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else if (index == jenisNilai.listJenisNilai.length) {
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
