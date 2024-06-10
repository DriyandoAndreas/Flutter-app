import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisko_v5/pages/account_page.dart';
import 'package:sisko_v5/pages/home_page.dart';
import 'package:sisko_v5/pages/myschool_page.dart';
import 'package:sisko_v5/providers/theme_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MyschoolPage(),
    const AccountPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            Color selectedItemColor =
                themeProvider.themeData.colorScheme.primary;
            return BottomNavigationBar(
              selectedItemColor: selectedItemColor,
              iconSize: 30,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield_rounded),
                  label: 'My School',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
            );
          },
        ));
  }
}
