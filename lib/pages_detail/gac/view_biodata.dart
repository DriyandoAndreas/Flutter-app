import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/biodata_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewBiodata extends StatelessWidget {
  const ViewBiodata({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<BoidataProvider>().getBioGac(id: id, tokenss: tokenss);
    }
    return Consumer<BoidataProvider>(
      builder: (context, provider, child) {
        if (provider.biodatagac == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Nomor Induk Pegawai'),
                Text(provider.biodatagac?.nip ?? ''),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Jenis Kelamin'),
                provider.biodatagac?.jeniskelamin == "L"
                    ? const Text('Laki-laki')
                    : const Text('Perempuan'),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Tempat , Tgl. Lahir'),
                Text(
                    '${provider.biodatagac?.tempatlahir}, ${provider.biodatagac?.tanggallahir ?? ''}'),
                const Divider(
                  thickness: 0.1,
                ),
                const Text('Nomor Handphone'),
                Text(provider.biodatagac?.nohp ?? ''),
                const Divider(
                  thickness: 0.1,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
