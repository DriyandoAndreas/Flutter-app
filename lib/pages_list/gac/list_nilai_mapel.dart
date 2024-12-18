import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/nilai_model.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListNilaiMapel extends StatefulWidget {
  const ListNilaiMapel({super.key});

  @override
  State<ListNilaiMapel> createState() => _ListNilaiMapelState();
}

class _ListNilaiMapelState extends State<ListNilaiMapel> {
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
    // ignore: use_build_context_synchronously
    if (ModalRoute.of(context)!.settings.arguments != null) {
      NilaiKelasModel kelas =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as NilaiKelasModel;
      var kodeKelas = kelas.kodeKelas;

      _loadList(kodeKelas!);
    }
  }

  Future<void> _loadList(String? kodeKelas) async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      String? id = user.currentuser.siskonpsn;
      String? tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context.read<NilaiProvider>().initMapel(
            id: id,
            tokenss: tokenss.substring(0, 30),
            kodeKelas: kodeKelas ?? '');
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NilaiKelasModel kelas =
        ModalRoute.of(context)!.settings.arguments as NilaiKelasModel;
    final provider = Provider.of<NilaiProvider>(context);
    final kelasMapels =
        provider.listKelas.isNotEmpty ? provider.listKelas.first : null;
    String? thnAjaran = kelasMapels?.thnAj;
    String? semester = kelasMapels?.semester;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          children: [
            const Text('Nilai'),
            Text(
              kelas.namaKelas!,
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
    return Consumer<NilaiProvider>(
      builder: (context, mapels, child) {
        if (mapels.listMapel.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: mapels.listMapel.length,
            itemBuilder: (context, index) {
              if (index < mapels.listKelas.length) {
                final mapel = mapels.listMapel[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/list-jenis-nilai',
                            arguments: mapel);
                      },
                      title: Text(mapel.namaPljrn ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}
