import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/pages_detail/gac/view_biodata.dart';
import 'package:app5/pages_detail/sat/view_biodata.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Biodata"),
      ),
      body: user.currentuser.siskostatuslogin == 'g'
          ? const ViewBiodata()
          : const ViewBiodataSat(),
    );
  }
}
