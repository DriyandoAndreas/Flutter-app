import 'package:flutter/material.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/nilai_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/nilai_service.dart';

class ListJenisNilai extends StatefulWidget {
  const ListJenisNilai({super.key});

  @override
  State<ListJenisNilai> createState() => _ListJenisNilaiState();
}

class _ListJenisNilaiState extends State<ListJenisNilai> {
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  late List<NilaiJenisModel> _jenisNilai = [];
  bool _isLoading = false;

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
    await _loadList();
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

  Future<void> _loadList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentUser = _users.isNotEmpty ? _users.first : null;
      String? id = currentUser?.siskoid;
      String? tokenss = currentUser?.tokenss;
      if (id != null && tokenss != null) {
        final paginatedList = await NilaiService().getJenisNilai(
          id: id,
          tokenss: tokenss.substring(0, 30),
        );
        setState(() {
          _jenisNilai = paginatedList;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid ID or token');
      }
    } catch (e) {
      throw Exception('Failed to load list $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ListNilaiMapelModel kelas =
        ModalRoute.of(context)!.settings.arguments as ListNilaiMapelModel;
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
            // const Text(
            //   'Semester Genap', // TODO: ganti data dengan data dari backend
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Text(
            //   'Th. Ajaran 2023-2024', // TODO: ganti dengan data dari backend
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const Divider(
            //   thickness: 0.1,
            // ),
            Expanded(
              child: buildList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList() {
    if (_isLoading && _jenisNilai.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_jenisNilai.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _jenisNilai.length,
        itemBuilder: (context, index) {
          if (index < _jenisNilai.length) {
            final nilai = _jenisNilai[index];
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    //to form nilai
                    Navigator.pushNamed(context, '/form-add-nilai',
                        arguments: nilai);
                  },
                  title: Text(nilai.namaTes ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                const Divider(
                  thickness: 0.1,
                ),
              ],
            );
          } else if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      );
    }
  }
}
