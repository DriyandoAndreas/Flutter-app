import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/sat/list_nilai_ekskul.dart';
import 'package:app5/pages_list/sat/list_nilai_pelajaran.dart';
import 'package:app5/providers/theme_provider.dart';

class SatListNilai extends StatefulWidget {
  const SatListNilai({super.key});

  @override
  State<SatListNilai> createState() => _SatListNilaiState();
}

class _SatListNilaiState extends State<SatListNilai> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const SatNilaiPelajaran(),
    const SatNilaiEkskul(),
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
            title: const Text('Nilai'),
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
                label: 'NILAI PELAJARAN',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: 'NILAI EKSKUL',
              ),
            ],
          ),
        );
      },
    );
  }
}
