import 'package:flutter/material.dart';
// import 'package:sisko_v5/utils/theme.dart';

class ListCCTV extends StatelessWidget {
  const ListCCTV({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("CCTV"),
      ),
    );
  }
}