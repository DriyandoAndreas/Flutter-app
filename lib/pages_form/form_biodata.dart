import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:sisko_v5/utils/theme.dart';

List<String> lists = <String>[' ', 'Laki-Laki', 'Perempuan'];

class FormBiodata extends StatefulWidget {
  const FormBiodata({super.key});

  @override
  State<FormBiodata> createState() => _FormBiodataState();
}

class _FormBiodataState extends State<FormBiodata> {
  late DateTime selectedDate = DateTime.now();
  String dropdownValue = lists.first;
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
    final double width = MediaQuery.of(context).size.width;
    final inputDate = DateFormat('dd MMM yyyy').format(selectedDate);
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Biodata"),
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
                      const Text('Tanggal lahir'),
                      const SizedBox(
                        width: 12,
                      ),
                      TextButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Center(
                          child: Text(
                            inputDate,
                          ),
                        ),
                      ),
                      const Text('Jenis Kelamin'),
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
                      const SizedBox(
                        height: 12,
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
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
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
