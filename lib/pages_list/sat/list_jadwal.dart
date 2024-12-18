import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/sat/list_jadwal_kerjapraktik.dart';
import 'package:app5/pages_list/sat/list_jadwal_pelajaran.dart';
import 'package:app5/pages_list/sat/list_jadwal_ujian.dart';
import 'package:app5/providers/theme_provider.dart';

class SatListJadwal extends StatefulWidget {
  const SatListJadwal({super.key});

  @override
  State<SatListJadwal> createState() => _SatListJadwalState();
}

class _SatListJadwalState extends State<SatListJadwal> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const SatListJadwalPelajaran(),
    const SatListJadwalUjian(),
    const SatListJadwalKerjaPraktik(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        Color selectedItemColor = themeProvider.themeData.colorScheme.primary;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            title: const Text('Jadwal'),
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            selectedItemColor: selectedItemColor,
            iconSize: 30,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: 'PELAJARAN',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: 'UJIAN',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                label: 'KERJA PRAKTIK',
              ),
            ],
          ),
        );
      },
    );
  }
}
