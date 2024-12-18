import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatViewNilai extends StatelessWidget {
  const SatViewNilai({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    var sem = arguments['semester'];
    var tahunajaran = arguments['tahun_ajaran'];
    var jenispenilaian = arguments['kode_menu'];
    var kodepenilaian = arguments['kode_pelajaran'];
    if (id != null &&
        tokenss != null &&
        sem != null &&
        tahunajaran != null &&
        jenispenilaian != null &&
        kodepenilaian != null) {
      context.read<SatNilaiProivder>().initShowNilai(
          id: id,
          tokenss: tokenss,
          sem: sem,
          tahunajaran: tahunajaran,
          jenispenilaian: jenispenilaian,
          kodepenilaian: kodepenilaian);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: jenispenilaian.startsWith('UH')
            ? const Text('Nilai Ulangan')
            : const Text('Nilai Tugas'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<SatNilaiProivder>(
              builder: (context, data, child) {
                return Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Teori',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Praktik',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      data.listnilai.length,
                      (index) {
                        var datas = data.listnilai[index];
                        return TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  datas.teori ?? 'Belum ada nilai',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  datas.praktik ?? 'Belum ada nilai',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
