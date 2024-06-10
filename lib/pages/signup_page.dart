import 'package:flutter/material.dart';
// import 'package:sisko_v5/utils/theme.dart';

List<String> lists = <String>['Siswa', 'Guru', 'Umum'];

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String dropdownValue = lists.first;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Sign Up'),
        centerTitle: true,
        // backgroundColor: backgroundcolor,
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
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8)),
                            backgroundColor:
                                const Color.fromARGB(255, 73, 72, 72),
                          ),
                          child: const Text(
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
