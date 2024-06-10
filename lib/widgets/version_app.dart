import 'package:flutter/material.dart';

class VersionApp extends StatelessWidget {
  const VersionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Center(
          child: Text('Powered by'),
        ),
        SizedBox(
          height: 12,
        ),
        Center(
          child: Text(
            'KAMADEVA',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Center(
          child: Text('5.0'),
        ),
      ],
    );
  }
}
