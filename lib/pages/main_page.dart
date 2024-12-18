import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages/account_page.dart';
import 'package:app5/pages/home_page.dart';
import 'package:app5/pages/myschool_page.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/theme_provider.dart';
import 'package:app5/providers/user_connection_provider.dart';

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
    final userConnection = context.read<UserConnectionProvider>();
    if (userConnection.disconnected && index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda tidak terhubung ke sekolah.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    user.fetchUser();
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            Color selectedItemColor =
                themeProvider.themeData.colorScheme.primary;
            return Consumer<UserConnectionProvider>(
              builder: (context, provider, child) {
                return BottomNavigationBar(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  selectedItemColor: selectedItemColor,
                  iconSize: 30,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.shield_outlined,
                      ),
                      label: 'My School',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Account',
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}
