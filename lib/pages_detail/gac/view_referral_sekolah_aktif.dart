import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/referral_view_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewReferralSekolahAktif extends StatelessWidget {
  const ViewReferralSekolahAktif({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<ReferralViewProvider>()
          .getSekolahAktif(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Sekolah Aktif'),
      ),
      body: Consumer<ReferralViewProvider>(
        builder: (context, value, child) {
          if (value.yreg.isEmpty) {
            return const Center(
              child: Text('belum ada sekolah registrasi'),
            );
          }
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = value.yreg[index];
                return ListTile(
                  title: Text(data.namasekolah ?? ''),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.1,
                );
              },
              itemCount: value.yreg.length);
        },
      ),
    );
  }
}
