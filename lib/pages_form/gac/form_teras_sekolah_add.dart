import 'dart:convert';
import 'dart:io';
import 'package:app5/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';
import 'package:app5/providers/berita_provider.dart';
import 'package:app5/providers/theme_switch_provider.dart';
import 'package:app5/services/berita_service.dart';

class FormTerasSekolah extends StatefulWidget {
  const FormTerasSekolah({super.key});

  @override
  State<FormTerasSekolah> createState() => _FormTerasSekolahState();
}

class _FormTerasSekolahState extends State<FormTerasSekolah> {
  TextEditingController judul = TextEditingController();
  TextEditingController isi = TextEditingController();
  late DateTime selectedDate = DateTime.now();
  late DateTime endSelectedDate = DateTime.now();
  bool ischeckedGuru = true;
  bool ischeckedKaryawan = true;
  bool ischeckedSis = true;
  File? _selectedImage;
  String? base64Image;
  String? tanggal;
  String? tanggalKadaluarsa;
  bool isloading = false;
  final OpenAIService _openAIService = OpenAIService();

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
                brightness: context.watch<ThemeSwitchProvider>().isDark
                    ? Brightness.dark
                    : Brightness.light,
                colorScheme: context.watch<ThemeSwitchProvider>().isDark
                    ? ColorScheme.dark(
                        surface: Colors.grey.shade900, primary: Colors.white)
                    : const ColorScheme.light(
                        surface: Colors.white, primary: Colors.black),
                dialogBackgroundColor:
                    context.watch<ThemeSwitchProvider>().isDark
                        ? Colors.black
                        : Colors.white),
            child: child!);
      },
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
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
                brightness: context.watch<ThemeSwitchProvider>().isDark
                    ? Brightness.dark
                    : Brightness.light,
                colorScheme: context.watch<ThemeSwitchProvider>().isDark
                    ? ColorScheme.dark(
                        surface: Colors.grey.shade900, primary: Colors.white)
                    : const ColorScheme.light(
                        surface: Colors.white, primary: Colors.black),
                dialogBackgroundColor:
                    context.watch<ThemeSwitchProvider>().isDark
                        ? Colors.black
                        : Colors.white),
            child: child!);
      },
    );
    if (endDate != null && endDate != endSelectedDate) {
      setState(() {
        endSelectedDate = endDate;
      });
    }
  }

  Future<void> _generateContent() async {
    if (judul.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      String prompt = "Buatkan saya konten tentang ${judul.text}.";
      String content = await _openAIService.generateContent(prompt);

      setState(() {
        isi.text = content;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konten berhasil dihasilkan')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghasilkan konten: $e')),
      );
    } finally {
      setState(() {
        isloading = false;
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
                          : const Icon(
                              Icons.image,
                              size: 60,
                            ),
                    ),
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
                      inputDate,
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
                        inputEndDate,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TextFormField takes most of the available space
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: isi,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Isi konten / deskripsi',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // IconButton stays on the right
                  IconButton(
                    onPressed: _generateContent,
                    icon: const Icon(Icons.auto_awesome),
                  ),
                ],
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
                        if (base64Image == null) {
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text('Gambar tidak boleh kosong'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else if (judul.text.isEmpty) {
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text('Judul tidak boleh kosong'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else if (isi.text.isEmpty) {
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text('Konten tidak boleh kosong'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          setState(() {
                            isloading = true;
                          });
                          await BeritaService().addBerita(
                            id: id,
                            tokenss: tokenss.toString(),
                            idc: '',
                            action: 'add',
                            imageUrl: 'data:image/jpg;base64,$base64Image',
                            tanggal: inputDate,
                            tanggalkadaluarsa: inputEndDate,
                            judul: judul.text,
                            isi: isi.text,
                            wysiwyg: '0',
                            untuk: untuk,
                          );
                          scaffold.showSnackBar(
                            SnackBar(
                              content:
                                  // ignore: use_build_context_synchronously
                                  Text(
                                'Berita berhasil ditambahkan',
                                style: TextStyle(
                                    // ignore: use_build_context_synchronously
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              // ignore: use_build_context_synchronously
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
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
                            content: Text('Berita gagal ditambahkan',
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
