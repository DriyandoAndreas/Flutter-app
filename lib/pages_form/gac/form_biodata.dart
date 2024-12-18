import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/user_service.dart';

class FormBiodata extends StatefulWidget {
  const FormBiodata({super.key});

  @override
  State<FormBiodata> createState() => _FormBiodataState();
}

class _FormBiodataState extends State<FormBiodata> {
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  late DateTime selectedDate;
  late DateTime initialdatadate;
  List<String> lists = <String>[' ', 'Laki-Laki', 'Perempuan'];
  String dropdownValue = 'Laki-Laki';
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    selectedDate =
        DateTime.parse(user.currentuser.tanggallahir ?? '2000-01-01');
    nama.text = user.currentuser.nama ?? '';
    email.text = user.currentuser.email ?? '';
    var jeniskelamin = '';
    if (user.currentuser.kelamin == 'L') {
      jeniskelamin = "Laki-Laki";
    } else {
      jeniskelamin = "Laki-Laki";
    }
    dropdownValue = jeniskelamin;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final inputDate = DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate);
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var hp = user.currentuser.hp;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Biodata"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                width: width,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nama'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: nama,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Nama anda',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const Text('Tanggal lahir'),
                      const SizedBox(
                        width: 12,
                      ),
                      TextButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(
                          inputDate,
                        ),
                      ),
                      const Text('Jenis Kelamin'),
                      const SizedBox(
                        width: 12,
                      ),
                      DropdownButton(
                        isExpanded: true,
                        value: dropdownValue,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            lists.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                      const Text('Email'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: email,
                          decoration: const InputDecoration.collapsed(
                              hintText: '....@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text('Handphone'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(height: 50, child: Text(hp ?? '')),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            UserService service = UserService();
                            var token = user.currentuser.token;
                            var nomor = user.currentuser.nomorsc;
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (await service.updateProfile(
                                token: token ?? '',
                                action: 'update',
                                nama: nama.text,
                                tanggallahir: inputDate,
                                kelamin: dropdownValue,
                                emailuser: email.text,
                                hp: hp ?? '',
                                nomor: nomor ?? '',
                              )) {
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Update berhasil',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const FormBiodata(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Update gagal',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const FormBiodata(),
                                ),
                              );
                            } catch (e) {
                              return;
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8)),
                            backgroundColor:
                                const Color.fromARGB(255, 73, 72, 72),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
