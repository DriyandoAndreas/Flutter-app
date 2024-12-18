import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_detail/gac/list_view_monitoring_activity_guru.dart';
import 'package:app5/pages_detail/gac/list_view_monitoring_activity_karyawan.dart';
import 'package:app5/providers/theme_provider.dart';

class ViewMonitoringActivitySummary extends StatefulWidget {
  const ViewMonitoringActivitySummary({super.key});

  @override
  State<ViewMonitoringActivitySummary> createState() =>
      _ViewMonitoringActivitySummaryState();
}

class _ViewMonitoringActivitySummaryState
    extends State<ViewMonitoringActivitySummary> {
  int _selected = 0;
  List<Widget> widgetoption = <Widget>[
    const ListViewMonitoringActivityGuru(),
    const ListViewMonitoringActivityKaryawan()
  ];
  void _ontap(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        Color selectedItemColor = themeProvider.themeData.colorScheme.primary;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            title: const Text('Activity Summary'),
          ),
          body: widgetoption.elementAt(_selected),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: selectedItemColor,
              currentIndex: _selected,
              onTap: _ontap,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Guru',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Karyawan',
                ),
              ]),
        );
      },
    );
  }
}
