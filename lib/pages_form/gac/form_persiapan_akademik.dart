import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_form/gac/form_persiapan_akademik_absensi.dart';
import 'package:app5/pages_form/gac/form_persiapan_akademik_info.dart';
import 'package:app5/pages_form/gac/form_persiapan_akademik_laporan.dart';
import 'package:app5/pages_form/gac/form_persiapan_akademik_persiapan.dart';
import 'package:app5/providers/theme_provider.dart';

class FormPersiapanAkademik extends StatefulWidget {
  const FormPersiapanAkademik({super.key});

  @override
  State<FormPersiapanAkademik> createState() => _FormPersiapanAkademikState();
}

class _FormPersiapanAkademikState extends State<FormPersiapanAkademik> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const FormPersiapanAkademikInfo(),
    const FormPersiapanAkademikPersiapan(),
    const FormPersiapanAkademikAbsensi(),
    const FormPersiapanAkademikLaporan(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var mapel = arguments['nama_pelajaran'];
    var tanggal = arguments['tanggal'];
    var mulai = arguments['mulai'];
    var selesai = arguments['selesai'];
    var indexpresensi = arguments['index'];
    if (indexpresensi != null) {
      setState(() {
        _selectedIndex = indexpresensi;
      });
    }
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        Color selectedItemColor = themeProvider.themeData.colorScheme.primary;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$mapel'),
                Text(
                  '$tanggal $mulai-$selesai',
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: selectedItemColor,
            unselectedItemColor: Theme.of(context).colorScheme.tertiary,
            iconSize: 30,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.info,
                ),
                label: 'Info',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.preview_sharp,
                ),
                label: 'Persiapan',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people_alt_outlined,
                ),
                label: 'Absensi',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_online_outlined,
                ),
                label: 'Laporan',
              ),
            ],
          ),
        );
      },
    );
  }
}
