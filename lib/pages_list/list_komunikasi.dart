import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/pages_list/list_komunikasi_tahfidz.dart';
import 'package:sisko_v5/pages_list/list_komunikasi_umum.dart';
import 'package:sisko_v5/providers/theme_provider.dart';

class ListKomunikasi extends StatefulWidget {
  const ListKomunikasi({super.key});

  @override
  State<ListKomunikasi> createState() => _ListKomunikasiState();
}

class _ListKomunikasiState extends State<ListKomunikasi> {
  bool isOpen = false;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const ListKomunikasiUmum(),
    const ListKomunikasiTahfidz(),
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
            selectedItemColor: selectedItemColor,
            iconSize: 30,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt),
                label: 'UMUM',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt),
                label: 'TAHFIDZ',
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: Colors.grey.shade600,
            renderOverlay: false,
            animatedIcon: null,
            animatedIconTheme: const IconThemeData(size: 22),
            onOpen: () => setState(() => isOpen = true),
            onClose: () => setState(() => isOpen = false),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.add),
                label: 'Umum',
                onTap: () {
                  Navigator.pushNamed(context, '/form-komunikasi-umum');
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.add),
                label: 'Tahfidz',
                onTap: () {
                  Navigator.pushNamed(context, '/form-komunikasi-tahfidz');
                },
              ),
            ],
            child: isOpen
                ? const Icon(
                    Icons.close,
                  )
                : const Icon(
                    Icons.add,
                  ),
          ),
        );
      },
    );
  }
}
