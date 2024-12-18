import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/polling_model.dart';
import 'package:app5/providers/polling_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/polling_service.dart';

class SatViewPolling extends StatefulWidget {
  const SatViewPolling({super.key});

  @override
  State<SatViewPolling> createState() => _SatViewPollingState();
}

class _SatViewPollingState extends State<SatViewPolling> {
  String groupValue = '';
  bool isloading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initData() async {
    await loadJawaban();
  }

  Future<void> loadJawaban() async {
    try {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final SatListPollingModel viewdata =
            ModalRoute.of(context)!.settings.arguments as SatListPollingModel;
        final user = Provider.of<SqliteUserProvider>(context, listen: false);
        var id = user.currentuser.siskonpsn;
        var tokenss = user.currentuser.tokenss;
        var param = viewdata.kodepolling;
        if (id != null && tokenss != null && param != null) {
          await context
              .read<SatPollingProvider>()
              .getJawabanPolling(id: id, tokenss: tokenss, param: param);
          // ignore: use_build_context_synchronously
          await context
              .read<SatPollingProvider>()
              .getPolling(id: id, tokenss: tokenss, param: param);
        }
        // ignore: use_build_context_synchronously
        final vdata = Provider.of<SatPollingProvider>(context, listen: false);
        if (vdata.getPoling.isNotEmpty) {
          var terpilih = vdata.getPoling.first;
          var jawaban = terpilih.satViewTerpilihModel?.kdjawaban;
          if (jawaban != null) {
            setState(() {
              groupValue = jawaban;
            });
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SatListPollingModel viewdata =
        ModalRoute.of(context)!.settings.arguments as SatListPollingModel;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Polling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(viewdata.namapolling ?? ''),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                viewdata.pertanyaan ?? '',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Consumer<SatPollingProvider>(
              builder: (context, value, child) {
                if (value.getJawaban.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getJawaban.length,
                    itemBuilder: (context, index) {
                      var datas = value.getJawaban[index];

                      return RadioListTile(
                        title: Text(datas.jawaban ?? ''),
                        value: datas.kdjawaban,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  try {
                    final user =
                        Provider.of<SqliteUserProvider>(context, listen: false);
                    final SatPollingService service = SatPollingService();
                    var id = user.currentuser.siskonpsn;
                    var tokenss = user.currentuser.tokenss;
                    var kodepolling = viewdata.kodepolling;
                    var kdpollpeserta = viewdata.kodepollpeserta;
                    var kdjawaban = groupValue;
                    var idpeserta = user.currentuser.siskokode;
                    if (id != null &&
                        tokenss != null &&
                        kodepolling != null &&
                        kdpollpeserta != null &&
                        idpeserta != null) {
                      await service.addJawaban(
                          id: id,
                          tokenss: tokenss,
                          action: 'vote',
                          kodepolling: kodepolling,
                          kdpollpeserta: kdpollpeserta,
                          kdjawaban: kdjawaban,
                          idpeserta: idpeserta);
                    }
                    setState(() {
                      isloading = false;
                    });
                  } catch (e) {
                    return;
                  }
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(8)),
                  backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                ),
                child: isloading
                    ? const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      )
                    : const Text(
                        'VOTE',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
