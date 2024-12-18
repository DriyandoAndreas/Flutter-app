import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_list/sat/list_tagihan.dart';
import 'package:app5/pages_list/sat/list_transaksi.dart';
import 'package:app5/providers/theme_provider.dart';

class ListKuangan extends StatefulWidget {
  const ListKuangan({super.key});

  @override
  State<ListKuangan> createState() => _ListKuanganState();
}

class _ListKuanganState extends State<ListKuangan> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const ListTagihan(),
    const ListTransaksi(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Keuangan"),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            Color selectedItemColor =
                themeProvider.themeData.colorScheme.primary;
            return BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              selectedItemColor: selectedItemColor,
              iconSize: 30,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.money),
                  label: 'Tagihan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sort),
                  label: 'Transaksi',
                ),
              ],
            );
          },
        ));
  }
}
