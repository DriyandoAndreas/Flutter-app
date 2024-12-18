import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/user_service.dart';

class FormUbahPassword extends StatefulWidget {
  const FormUbahPassword({super.key});

  @override
  State<FormUbahPassword> createState() => _FormUbahPasswordState();
}

class _FormUbahPasswordState extends State<FormUbahPassword> {
  TextEditingController passwordlama = TextEditingController();
  TextEditingController passwordbaru = TextEditingController();
  TextEditingController passwordbaruconfirm = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Ubah password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 320,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password lama'),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordlama,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Password lama anda',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const Text('Password baru'),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordbaru,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Password baru anda',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const Text('Ulangi password baru'),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordbaruconfirm,
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Ulangi password baru',
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
                        UserService service = UserService();
                        final user = Provider.of<SqliteUserProvider>(context,
                            listen: false);
                        var token = user.currentuser.token;
                        var nomor = user.currentuser.nomorsc;
                        var hp = user.currentuser.hp;
                        var siskoid = user.currentuser.siskonpsn;
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          if (await service.updatePassword(
                            action: 'update',
                            password: passwordlama.text,
                            passwordbaru: passwordbaru.text,
                            passwordBaruconfirm: passwordbaruconfirm.text,
                            hp: hp ?? '',
                            nomor: nomor ?? '',
                            token: token ?? '',
                            siskoid: siskoid ?? '',
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
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
