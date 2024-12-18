import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/kelas_model.dart';
import 'package:app5/providers/kelas_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewSatKelas extends StatefulWidget {
  const ViewSatKelas({super.key});

  @override
  State<ViewSatKelas> createState() => _ViewSatKelasState();
}

class _ViewSatKelasState extends State<ViewSatKelas> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initData() async {
    try {
      await getListKelasOpen();
    } catch (e) {
      return;
    }
  }

  Future<void> getListKelasOpen() async {
    try {
      final KelasSatModel kelassat =
          ModalRoute.of(context)!.settings.arguments as KelasSatModel;
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      var kodeKelas = kelassat.kodeKelas;
      if (id != null && tokenss != null && kodeKelas != null) {
        context
            .read<KelasSatProvider>()
            .getKelasOpen(id: id, tokenss: tokenss, kodeKelas: kodeKelas);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final KelasSatModel kelassat =
        ModalRoute.of(context)!.settings.arguments as KelasSatModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(kelassat.namaKelas ?? ''),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'TA ${kelassat.tahunAjaran ?? ''}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 0.1,
          ),
          Expanded(child: Consumer<KelasSatProvider>(
            builder: (context, datakelasopen, child) {
              if (datakelasopen.isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (datakelasopen.listKelasOpen.isEmpty) {
                return const Center(
                  child: Text('Beluma ada data siswa pada kelas ini'),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: datakelasopen.listKelasOpen.length,
                  itemBuilder: (context, index) {
                    final datas = datakelasopen.listKelasOpen[index];
                    final user =
                        Provider.of<SqliteUserProvider>(context, listen: false);
                    var nis = user.currentuser.siskokode;
                    var mynis = datas.nis;
                    bool ismyclass = false;
                    if (nis == mynis) {
                      ismyclass = true;
                    }
                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(datas.nis ?? ''),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  datas.namalengkap ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ismyclass
                                  ? const Icon(Icons.stars)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 0.1,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
