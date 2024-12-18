import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/sat/list_presensi_bulanan.dart';
import 'package:app5/pages_list/sat/list_presensi_history.dart';
import 'package:app5/providers/theme_provider.dart';

class SatListPresensi extends StatefulWidget {
  const SatListPresensi({super.key});

  @override
  State<SatListPresensi> createState() => _SatListPresensiState();
}

class _SatListPresensiState extends State<SatListPresensi> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const SatListPresensiBulanan(),
    const SatListPresensiHistory(),
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
            title: const Text('Presensi'),
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
                icon: Icon(Icons.calendar_month_outlined),
                label: 'BULANAN',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                label: 'HISTORY',
              ),
            ],
          ),
        );
      },
    );
  }
}
