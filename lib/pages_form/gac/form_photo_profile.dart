import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/user_service.dart';

class FormPhotoProfile extends StatefulWidget {
  const FormPhotoProfile({super.key});

  @override
  State<FormPhotoProfile> createState() => _FormPhotoProfileState();
}

class _FormPhotoProfileState extends State<FormPhotoProfile> {
  File? _selectedPhotoProfile;
  String? base64Image;
  bool isLoading = false;

  Future pickFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    File imageFile = File(returnImage.path);
    List<int> imageByte = await imageFile.readAsBytes();
    base64Image = base64Encode(imageByte);
    setState(() {
      _selectedPhotoProfile = File(returnImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Photo Profile"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: GestureDetector(
                onTap: () {
                  pickFromGallery();
                },
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: _selectedPhotoProfile != null
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.file(_selectedPhotoProfile!),
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
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  UserService service = UserService();
                  final user =
                      Provider.of<SqliteUserProvider>(context, listen: false);
                  var token = user.currentuser.token;
                  var nomor = user.currentuser.nomorsc;
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    if (token != null && nomor != null) {
                      if (await service.updatePhotoProfile(
                        action: 'update',
                        data: 'data',
                        content: 'data:image/jpg;base64,$base64Image',
                        nomor: nomor,
                        token: token,
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
                            builder: (context) => const FormPhotoProfile(),
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
                              'Gagal update',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const FormPhotoProfile(),
                          ),
                        );
                      }
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
                child: isLoading
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
    );
  }
}
