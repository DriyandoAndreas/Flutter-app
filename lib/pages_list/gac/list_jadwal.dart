import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/gac/list_jam_pelajaran.dart';
import 'package:app5/pages_list/gac/list_mapel.dart';
import 'package:app5/providers/theme_provider.dart';

class ListJadwal extends StatefulWidget {
  const ListJadwal({super.key});

  @override
  State<ListJadwal> createState() => _ListJadwalState();
}

class _ListJadwalState extends State<ListJadwal> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const ListMapel(),
    const ListJamPelajaran(),
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
            selectedItemColor: selectedItemColor,
            iconSize: 30,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Mapel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Jadwal',
              ),
            ],
          ),
        );
      },
    );
  }
}
