import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/referral_view_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewReferralSekolahBelumAktif extends StatelessWidget {
  const ViewReferralSekolahBelumAktif({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<ReferralViewProvider>()
          .getSekolahBelumAktif(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Sekolah Belum Aktif'),
      ),
      body: Consumer<ReferralViewProvider>(
        builder: (context, value, child) {
          if (value.nreg.isEmpty) {
            return const Center(
              child: Text('belum ada data'),
            );
          }
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = value.nreg[index];
                return ListTile(
                  title: Text(data.namasekolah ?? ''),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.1,
                );
              },
              itemCount: value.nreg.length);
        },
      ),
    );
  }
}
