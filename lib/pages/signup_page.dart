import 'package:flutter/material.dart';
import 'package:app5/services/register_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

// Map untuk posisi
  Map<String, int> positionMap = {
    'Guru': 2,
    'Siswa': 3,
    'Umum': 4,
  };

  List<String> lists = <String>['Guru', 'Siswa', 'Umum'];

  String dropdownValue = 'Siswa';
  TextEditingController nama = TextEditingController();
  TextEditingController hp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  failed() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Gagal registrasi. Nomor Handphone/Email sudah terdaftar',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Image.asset('assets/demo_background.jpg'),
            ),
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
                      const Text('Handphone'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: hp,
                          decoration: const InputDecoration.collapsed(
                              hintText: '0812xxxxxxx',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const Text('Email'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: const InputDecoration.collapsed(
                              hintText: '....@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const Text('Saya adalah'),
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
                      const SizedBox(
                        height: 12,
                      ),
                      const Text('Password'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          obscureText: true,
                          controller: password,
                          decoration: const InputDecoration.collapsed(
                              hintText:
                                  'Buat password baru anda min 6 karakter',
                              hintStyle: TextStyle(color: Colors.grey)),
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
                            RegisterService service = RegisterService();
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              int? position = positionMap[dropdownValue];
                              if (await service.register(
                                action: 'registrasi',
                                nama: nama.text,
                                hp: hp.text,
                                email: email.text,
                                position: position.toString(), // Kirim posisi
                                password: password.text,
                              )) {
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Registrasi berhasil. Silahkan cek inbox email anda',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {
                                failed();
                                setState(() {
                                  isLoading = false;
                                });
                              }
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
                                  'Daftar Sekarang',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Apabila anda mendaftar, berarti anda menyetujui hal-hal yang tercantum pada',
                      ),
                      Text(
                        'Kebijakan Privasi',
                        style: TextStyle(color: Colors.grey.shade600),
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
