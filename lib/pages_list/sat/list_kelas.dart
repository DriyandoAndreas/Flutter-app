import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/kelas_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SatListKelas extends StatelessWidget {
  const SatListKelas({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;

    if (id != null && tokenss != null) {
      context.read<KelasSatProvider>().getListKelas(id: id, tokenss: tokenss);
    }
    urlLuncer(String urls) async {
      final Uri url = Uri.parse(urls);
      if (!await launchUrl(url)) {
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kelas'),
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 0.1,
          ),
          Consumer<KelasSatProvider>(
            builder: (context, kelasdata, child) {
              if (kelasdata.listkelas.isEmpty) {
                return const Center(
                  child: SizedBox.shrink(),
                );
              } else {
                var datas = kelasdata.listkelas.first;
                return SizedBox(
                  height: 50,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'TA ${datas.tahunAjaran ?? ''}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(
            thickness: 0.1,
          ),
          Expanded(
            child: Consumer<KelasSatProvider>(
              builder: (context, datalist, child) {
                if (datalist.listkelas.isEmpty) {
                  return const Center(
                    child: SizedBox.shrink(),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: datalist.listkelas.length,
                    itemBuilder: (context, index) {
                      var datas = datalist.listkelas[index];
                      var wa = datas.waGroup;
                      var myclass = datas.myclass;
                      bool ismyclass = myclass == '1' ? true : false;
                      bool hasWaGroup = wa != '';
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/view-kelas-sat',
                              arguments: datas);
                        },
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(datas.namaKelas ?? ''),
                            const SizedBox(
                              width: 4,
                            ),
                            ismyclass
                                ? Card(
                                    color: Colors.green.shade400,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        'My Class',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                        subtitle: Text(
                          datas.namaLengkap ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasWaGroup)
                              GestureDetector(
                                  onTap: () {
                                    urlLuncer('${datas.waGroup}');
                                  },
                                  child: const Icon(Icons.forum_outlined)),
                            SizedBox(
                              width: hasWaGroup ? 12 : 0,
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
