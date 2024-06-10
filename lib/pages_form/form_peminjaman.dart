import 'package:flutter/material.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/services/perpus_service.dart';

class FormPeminjaman extends StatefulWidget {
  const FormPeminjaman({super.key});

  @override
  State<FormPeminjaman> createState() => _FormPeminjamanState();
}

class _FormPeminjamanState extends State<FormPeminjaman> {
  bool isLoading = false;
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];
  TextEditingController nis = TextEditingController();
  TextEditingController noInventaris = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskoid;
    String? tokenss = currentUser?.tokenss;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Peminjaman'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NIS / Nama Siswa'), //TODO: auto complete nis
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nis,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'NIS / Nama Siswa',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.qr_code),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'No Inventaris / Nama Buku'), //TODO: auto complete no inventaris
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: noInventaris,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'No Inventaris Buku / Nama Buku',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.qr_code),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final scaffold = ScaffoldMessenger.of(context);
                    if (id != null && tokenss != null) {
                      tokenss = tokenss?.substring(0, 30);
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await PerpusService().bukuPinjam(
                        id: id!,
                        tokenss: tokenss!,
                        action: 'p',
                        nis: nis.text,
                        kodeInventaris: noInventaris.text,
                      );
                      scaffold.showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil pinjam'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Pinjam',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}