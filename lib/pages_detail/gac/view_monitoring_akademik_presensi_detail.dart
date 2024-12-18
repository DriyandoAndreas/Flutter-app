import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewMonitoringAkademikPresensiDetail extends StatelessWidget {
  const ViewMonitoringAkademikPresensiDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var idakademik = arguments['id_akademik'];
    var tanggal = arguments['tanggal'];
    var namapelajaran = arguments['nama_pljrn'];
    var mulai = arguments['mulai'];
    var selesai = arguments['selesai'];
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    var action = 'view';
    if (id != null && tokenss != null && idakademik != null) {
      context.read<AkademikProvider>().persiapanPresensi(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$namapelajaran',
              style: const TextStyle(fontSize: 24),
            ),
            Text('$tanggal $mulai-$selesai',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.tertiary)),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 0.1,
          ),
          Consumer<AkademikProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 0.1,
                  );
                },
                shrinkWrap: true,
                itemCount: provider.presensi.length,
                itemBuilder: (context, index) {
                  var datas = provider.presensi[index];
                  var keterangan = 'Hadir';
                  switch (datas.keterangan) {
                    case 'H':
                      keterangan = 'Hadir';
                      break;
                    case 'S':
                      keterangan = 'Sakit';
                      break;
                    case 'I':
                      keterangan = 'Ijin';
                      break;
                    case 'A':
                      keterangan = 'Alpha';
                      break;
                    case 'T':
                      keterangan = 'Terlambat';
                      break;
                    default:
                  }
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas.nis ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Text(datas.namasiswa ?? ''),
                      ],
                    ),
                    trailing: datas.keterangan == 'H'
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        : Text(keterangan),
                  );
                },
              );
            },
          ),
          const Divider(
            thickness: 0.1,
          ),
        ],
      ),
    );
  }
}
