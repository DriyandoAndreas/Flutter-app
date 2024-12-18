import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionApp extends StatefulWidget {
  const VersionApp({super.key});

  @override
  State<VersionApp> createState() => _VersionAppState();
}

class _VersionAppState extends State<VersionApp> {
  String _appVersion = '';
  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        const Center(
          child: Text('Powered by'),
        ),
        const SizedBox(
          height: 12,
        ),
        const Center(
          child: Text(
            'KAMADEVA',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: Text(_appVersion),
        ),
      ],
    );
  }
}
