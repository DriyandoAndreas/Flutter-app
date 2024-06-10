import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:sisko_v5/utils/theme.dart';

class FormPhotoProfile extends StatefulWidget {
  const FormPhotoProfile({super.key});

  @override
  State<FormPhotoProfile> createState() => _FormPhotoProfileState();
}

class _FormPhotoProfileState extends State<FormPhotoProfile> {
  File? _selectedPhotoProfile;
  @override
  Widget build(BuildContext context) {
    Future pickFromGallery() async {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnImage == null) return;
      setState(() {
        _selectedPhotoProfile = File(returnImage.path);
      });
    }

    return Scaffold(
      // backgroundColor: backgroundcolor,
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
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                ),
                child: const Text(
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
