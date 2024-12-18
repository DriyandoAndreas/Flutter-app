import 'package:flutter/material.dart';
import 'package:app5/services/forget_passwrod_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  TextEditingController hp = TextEditingController();
  TextEditingController email = TextEditingController();
  failed() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Gagal reset. Nomor Handphone/Email kosong',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Forget Password'),
        centerTitle: true,
        // backgroundColor: backgroundcolor,
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
                      const Text('Handphone'),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: hp,
                          keyboardType: TextInputType.number,
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
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration.collapsed(
                              hintText: '....@gmail.com',
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
                            ForgetPasswrodService service =
                                ForgetPasswrodService();
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (await service.forget(
                                  action: 'pwd-reset',
                                  hp: hp.text,
                                  email: email.text)) {
                                setState(() {
                                  isLoading = false;
                                });
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Reset berhasil. Silahkan cek inbox email atau Whatsapp anda',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                failed();
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
                                  'Reset Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
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
