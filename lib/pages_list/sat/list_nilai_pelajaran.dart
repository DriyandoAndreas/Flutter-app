import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/nilai_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatNilaiPelajaran extends StatefulWidget {
  const SatNilaiPelajaran({super.key});

  @override
  State<SatNilaiPelajaran> createState() => _SatNilaiPelajaranState();
}

class _SatNilaiPelajaranState extends State<SatNilaiPelajaran> {
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
        context.read<SatNilaiProivder>().getMapel(
              id: id,
              tokenss: tokenss,
              semester: selectedSemester,
              tahunajaran: selectedTahunAjaran,
            );
      }
    } catch (e) {
      return;
    }
  }

  void semester() {
    //button show semester
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: List.generate(
                  2,
                  (index) {
                    final semester = ['Ganjil', 'Genap'][index];
                    return RadioListTile(
                      title: Text(semester),
                      value: semester,
                      groupValue: selectedSemester,
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value!;
                        });
                        this.setState(() {
                          selectedSemester = value!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void tahunajaran() {
    //button show semester
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: List.generate(
                  7,
                  (index) {
                    final tahun = DateTime.now().year - index;
                    final tahun2 = DateTime.now().year + 1 - index;
                    return RadioListTile(
                      title: Text('${tahun.toString()}-${tahun2.toString()}'),
                      value: '${tahun.toString()}-${tahun2.toString()}',
                      groupValue: selectedTahunAjaran,
                      onChanged: (value) {
                        setState(() {
                          selectedTahunAjaran = value!;
                        });
                        this.setState(() {
                          selectedTahunAjaran = value!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            )),
                      ),
                    ),
                    onPressed: () {
                      semester();
                    },
                    child: Text(selectedSemester),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            )),
                      ),
                    ),
                    onPressed: () {
                      tahunajaran();
                    },
                    child: Text(selectedTahunAjaran),
                  ),
                ],
              ),
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(Colors.grey.shade800),
                ),
                onPressed: () async {
                  loadData();
                },
                child: const Text(
                  'TAMPIL',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          buildListMapel(),
        ],
      ),
    );
  }

  Widget buildListMapel() {
    return Consumer<SatNilaiProivder>(
      builder: (context, mapel, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: mapel.listmapel.length,
          itemBuilder: (context, index) {
            final data = mapel.listmapel[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/list-nilai-menu-sat',
                        arguments: <String, dynamic>{
                          'tahun_ajaran': selectedTahunAjaran,
                          'semester': selectedSemester,
                          'kode_pelajaran': data.kodepelajaran
                        });
                  },
                  leading: const Icon(Icons.layers_outlined),
                  title: Text(data.namapelajaran ?? ''),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
