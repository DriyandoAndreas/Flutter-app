import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/models/teras_sekolah_model.dart';
import 'package:app5/providers/berita_provider.dart';
import 'package:app5/services/berita_service.dart';

class FormEditTerasSekolah extends StatefulWidget {
  const FormEditTerasSekolah({super.key});

  @override
  State<FormEditTerasSekolah> createState() => _FormEditTerasSekolahState();
}

class _FormEditTerasSekolahState extends State<FormEditTerasSekolah> {
  late DateTime selectedDate = DateTime.parse(terasSekolah.tgl!);
  late DateTime endSelectedDate = DateTime.parse(terasSekolah.tglKadaluarsa!);
  bool ischeckedGuru = false;
  bool ischeckedKaryawan = false;
  bool ischeckedSis = false;
  File? _selectedImage;
  String? base64Image;
  String? tanggal;
  String? tanggalKadaluarsa;
  late TextEditingController judul;
  late TextEditingController isi;
  late TerasSekolahModel terasSekolah;
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
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    terasSekolah =
        ModalRoute.of(context)!.settings.arguments as TerasSekolahModel;
    judul = TextEditingController(text: terasSekolah.judul);
    isi = TextEditingController(text: terasSekolah.post);
    if (terasSekolah.untuk != null) {
      setState(() {
        ischeckedGuru = terasSekolah.untuk!.contains('GR');
        ischeckedKaryawan = terasSekolah.untuk!.contains('KR');
        ischeckedSis = terasSekolah.untuk!.contains('SIS');
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

  Future<void> _endDate(BuildContext context) async {
    final DateTime? endDate = await showDatePicker(
        context: context,
        initialDate: endSelectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (endDate != null && endDate != endSelectedDate) {
      setState(() {
        endSelectedDate = endDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _users.isNotEmpty ? _users.first : null;
    String? id = currentUser?.siskonpsn;
    String? tokenss = currentUser?.tokenss;
    final inputDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final inputEndDate = DateFormat('yyyy-MM-dd').format(endSelectedDate);

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
                            : Image.network(
                                terasSekolah.image!,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image);
                                },
                              )),
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
              const SizedBox(
                height: 12,
              ),
              const Text('Tanggal Berakhir'),
              const Divider(
                thickness: 0.5,
              ),
              TextButton(
                  onPressed: () {
                    _endDate(context);
                  },
                  child: Column(
                    children: [
                      Text(
                        inputEndDate.toString(),
                      ),
                    ],
                  )),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Headline'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: judul,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Headline',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              const Text('Konten/Deskirpsi'),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: isi,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Isi konten / deskripsi',
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

                      if (id!=null && tokenss != null) {
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Judul tidak boleh kosong',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else if (isi.text.isEmpty) {
                          scaffold.showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Konten tidak boleh kosong',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else {
                          setState(() {
                            isloading = true;
                          });
                          await BeritaService().editBerita(
                            id: id,
                            tokenss: tokenss.toString(),
                            idc: terasSekolah.kode.toString(),
                            action: 'edit',
                            imageUrl: base64Image != null
                                ? 'data:image/jpg;base64,$base64Image'
                                : terasSekolah.image.toString(),
                            tanggal: inputDate.toString(),
                            tanggalkadaluarsa: inputEndDate.toString(),
                            judul: judul.text,
                            isi: isi.text,
                            wysiwyg: '0',
                            untuk: untuk,
                          );

                          scaffold.showSnackBar(
                            SnackBar(
                              // ignore: use_build_context_synchronously
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Berita berhasil di edit',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Future.delayed(const Duration(seconds: 1), () {
                            // ignore: use_build_context_synchronously
                            context
                                .read<BeritaProvider>()
                                .refresh(id: id, tokenss: tokenss ?? '');
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          });
                          setState(() {
                            isloading = false;
                          });
                        }
                      } else {
                        scaffold.showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            content: Text('Berita gagal di edit',
                                style: TextStyle(
                                    // ignore: use_build_context_synchronously
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                          ),
                        );
                      }
                    } catch (e) {
                      return;
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isloading
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
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
