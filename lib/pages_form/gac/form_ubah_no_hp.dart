import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/user_service.dart';

class FormUbahNoHp extends StatefulWidget {
  const FormUbahNoHp({super.key});

  @override
  State<FormUbahNoHp> createState() => _FormUbahNoHpState();
}

class _FormUbahNoHpState extends State<FormUbahNoHp> {
  bool isLoading = false;
  TextEditingController handphone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var siskohp = user.currentuser.hp;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Ubah No Hp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 160,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nomor Handphone'),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: handphone,
                      decoration: InputDecoration.collapsed(
                          hintText: '$siskohp',
                          hintStyle: const TextStyle(color: Colors.grey)),
                    ),
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
                        var siskoid = user.currentuser.siskonpsn;
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          if (await service.updateHandphone(
                            action: 'update',
                            hp: handphone.text,
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
                              'Minta OTP',
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
