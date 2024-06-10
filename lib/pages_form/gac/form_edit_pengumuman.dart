import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/database/sqlite_helper.dart';
import 'package:sisko_v5/models/pengumuman_model.dart';
import 'package:sisko_v5/models/sqlite_user_model.dart';
import 'package:sisko_v5/providers/pengumuman_provider.dart';
import 'package:sisko_v5/services/pengumuman_service.dart';

class FormEditPengumuman extends StatefulWidget {
  const FormEditPengumuman({super.key});

  @override
  State<FormEditPengumuman> createState() => _FormEditPengumumanState();
}

class _FormEditPengumumanState extends State<FormEditPengumuman> {
  late DateTime selectedDate = DateTime.parse(pengumuman.tgl!);
  bool ischeckedGuru = false;
  bool ischeckedKaryawan = false;
  bool ischeckedSis = false;
  File? _selectedImage;
  String? base64Image;
  String? tanggal;
  String? tanggalKadaluarsa;
  late TextEditingController judul;
  late TextEditingController isi;
  late PengumumanModel pengumuman;
  bool isloading = false;
  late SqLiteHelper _sqLiteHelper;
  late List<SqliteUserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _sqLiteHelper = SqLiteHelper();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<SqliteUserModel> users = await _sqLiteHelper.getusers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      throw Exception('Gagal mengambil data dari sqlite');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pengumuman = ModalRoute.of(context)!.settings.arguments as PengumumanModel;
    judul = TextEditingController(text: pengumuman.judul);
    isi = TextEditingController(text: pengumuman.post);
    if (pengumuman.untuk != null) {
      setState(() {
        ischeckedGuru = pengumuman.untuk!.contains('GR');
        ischeckedKaryawan = pengumuman.untuk!.contains('KR');
        ischeckedSis = pengumuman.untuk!.contains('SIS');
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskoid;
    String? tokenss = currentUser?.tokenss;
    final inputDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    Future pickFromGallery() async {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnImage == null) return;
      File imageFile = File(returnImage.path);
      List<int> imageByte = await imageFile.readAsBytes();
      base64Image = base64Encode(imageByte);
      setState(() {
        _selectedImage = imageFile;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Teras Sekolah'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gambar'),
              Card(
                child: GestureDetector(
                  onTap: () {
                    pickFromGallery();
                  },
                  child: SizedBox(
                    height: 200,
                    child: Center(
                        child: _selectedImage != null
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.file(_selectedImage!),
                              )
                            : Image.network(pengumuman.image!)),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text('Tanggal Mulai'),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Column(
                  children: [
                    Text(
                      inputDate.toString(),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Judul Pengumuman'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: judul,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Judul Pengumuman',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Isi'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: isi,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Isi',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: ischeckedGuru,
                        onChanged: (bool? value) {
                          setState(() {
                            ischeckedGuru = value!;
                          });
                        },
                      ),
                      const Text('Semua Guru')
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: ischeckedKaryawan,
                        onChanged: (bool? value) {
                          setState(() {
                            ischeckedKaryawan = value!;
                          });
                        },
                      ),
                      const Text('Semua Karyawan')
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: ischeckedSis,
                        onChanged: (bool? value) {
                          setState(() {
                            ischeckedSis = value!;
                          });
                        },
                      ),
                      const Text('Semua Siswa dan Orang Tua')
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    try {
                      // ignore: use_build_context_synchronously
                      final scaffold = ScaffoldMessenger.of(context);

                      if (id != null && tokenss != null) {
                        String guruValue = ischeckedGuru ? 'GR' : '';
                        String karyawanValue = ischeckedKaryawan ? 'KR' : '';
                        String siswaValue = ischeckedSis ? 'SIS' : '';

                        List<String> values = [];
                        if (guruValue.isNotEmpty) values.add(guruValue);
                        if (karyawanValue.isNotEmpty) values.add(karyawanValue);
                        if (siswaValue.isNotEmpty) values.add(siswaValue);

                        String untuk = values.join(',');
                        tokenss = tokenss?.substring(0, 30);
                        if (judul.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              content: const Text('Judul tidak boleh kosong'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                // ignore: use_build_context_synchronously
                                bottom:
                                    MediaQuery.of(context).size.height - 150,
                                left: 15,
                                right: 15,
                              ),
                            ),
                          );
                        } else if (isi.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              content: const Text('Konten tidak boleh kosong'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                // ignore: use_build_context_synchronously
                                bottom:
                                    MediaQuery.of(context).size.height - 150,
                                left: 15,
                                right: 15,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            isloading = true;
                          });
                          await PengumumanService().editPengumuman(
                            id: id,
                            tokenss: tokenss.toString(),
                            idc: pengumuman.kode.toString(),
                            action: 'edit',
                            imageUrl: base64Image != null
                                ? 'data:image/jpg;base64,$base64Image'
                                : pengumuman.image.toString(),
                            tanggal: inputDate.toString(),
                            judul: judul.text,
                            isi: isi.text,
                            wysiwyg: '0',
                            untuk: untuk,
                          );

                          scaffold.showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Pengumuman berhasil di edit'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                // ignore: use_build_context_synchronously
                                bottom:
                                    // ignore: use_build_context_synchronously
                                    MediaQuery.of(context).size.height - 150,
                                left: 15,
                                right: 15,
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Future.delayed(const Duration(seconds: 2), () {
                            context
                                .read<PengumumanProvider>()
                                .refresh(id: id, tokenss: tokenss ?? '');
                            Navigator.of(context).pop();
                          });
                          setState(() {
                            isloading = false;
                          });
                        }
                      } else {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: const Text('Pengumuman gagal di edit'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              // ignore: use_build_context_synchronously
                              bottom: MediaQuery.of(context).size.height - 150,
                              left: 15,
                              right: 15,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      throw Exception('$e');
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Simpan',
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
