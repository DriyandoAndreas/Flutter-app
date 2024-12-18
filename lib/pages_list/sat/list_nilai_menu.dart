import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatNilaiMenu extends StatefulWidget {
  const SatNilaiMenu({super.key});

  @override
  State<SatNilaiMenu> createState() => _SatNilaiMenuState();
}

class _SatNilaiMenuState extends State<SatNilaiMenu> {
  String selectedSemester = 'Ganjil';
  String selectedTahunAjaran =
      '${DateTime.now().year.toString()}-${DateTime.now().year + 1}';

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    iniData();
  }

  Future<void> iniData() async {
    try {
      await loadData();
    } catch (e) {
      return;
    }
  }

  Future<void> loadData() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      if (id != null && tokenss != null) {
        context
            .read<SatNilaiProivder>()
            .initMenuNilai(id: id, tokenss: tokenss);
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            buildListNilai(),
          ],
        ),
      ),
    );
  }

  Widget buildListNilai() {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var thnaj = arguments['tahun_ajaran'];
    var semester = arguments['semester'];
    var kodepenilaian = arguments['kode_pelajaran'];
    return Consumer<SatNilaiProivder>(
      builder: (context, data, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.listmenu.length,
          itemBuilder: (context, index) {
            final menuuh = data.listmenu[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/view-nilai',
                        arguments: <String, dynamic>{
                          'tahun_ajaran': thnaj,
                          'semester': semester,
                          'kode_menu': menuuh.kodemenu,
                          'kode_pelajaran': kodepenilaian
                        });
                  },
                  leading: const Icon(Icons.layers_outlined),
                  title: Text(menuuh.namamenu ?? ''),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
