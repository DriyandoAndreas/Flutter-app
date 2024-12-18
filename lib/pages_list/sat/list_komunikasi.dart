import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/sat/list_komunikasi_tahfidz.dart';
import 'package:app5/pages_list/sat/list_komunikasi_umum.dart';
import 'package:app5/providers/theme_provider.dart';

class SatListKomunikasi extends StatefulWidget {
  const SatListKomunikasi({super.key});

  @override
  State<SatListKomunikasi> createState() => _SatListKomunikasiState();
}

class _SatListKomunikasiState extends State<SatListKomunikasi> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const SatListKomunikasiUmum(),
    const SatListKomunikasiTahfidz(),
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
            title: const Text('Komunikasi'),
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
                icon: Icon(Icons.view_list_outlined),
                label: 'UMUM',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list_outlined),
                label: 'TAHFIDZ',
              ),
            ],
          ),
        );
      },
    );
  }
}
