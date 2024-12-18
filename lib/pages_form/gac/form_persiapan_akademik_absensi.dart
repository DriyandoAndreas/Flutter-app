import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/akademik_service.dart';

class FormPersiapanAkademikAbsensi extends StatefulWidget {
  const FormPersiapanAkademikAbsensi({super.key});

  @override
  State<FormPersiapanAkademikAbsensi> createState() =>
      _FormPersiapanAkademikAbsensiState();
}

class _FormPersiapanAkademikAbsensiState
    extends State<FormPersiapanAkademikAbsensi> {
  bool isLoading = false;
  final Map<String, String> _absenStatus = {};

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var idakademik = arguments['id_akademik'];
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    var action = 'view';
    if (id != null && tokenss != null && idakademik != null) {
      context.read<AkademikProvider>().persiapanPresensi(
          id: id, tokenss: tokenss, action: action, idakademik: idakademik);
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(
            thickness: 0.5,
          ),
          Consumer<AkademikProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 0.5,
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
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryFixed,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      RadioListTile<String>(
                                        title: const Text('Hadir'),
                                        value: 'Hadir',
                                        groupValue: keterangan,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _absenStatus[datas.nis ?? ''] =
                                                value!;
                                          });
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Sakit'),
                                        value: 'Sakit',
                                        groupValue: keterangan,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _absenStatus[datas.nis ?? ''] =
                                                value!;
                                          });
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Ijin'),
                                        value: 'Ijin',
                                        groupValue: keterangan,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _absenStatus[datas.nis ?? ''] =
                                                value!;
                                          });
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Alpha'),
                                        value: 'Alpha',
                                        groupValue: keterangan,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _absenStatus[datas.nis ?? ''] =
                                                value!;
                                          });
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: const Text('Terlambat'),
                                        value: 'Terlambat',
                                        groupValue: keterangan,
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _absenStatus[datas.nis ?? ''] =
                                                value!;
                                          });
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).then((selectedStatus) {
                        if (selectedStatus != null) {
                          setState(() {
                            _absenStatus[datas.nis ?? ''] = selectedStatus;
                          });
                        }
                      });
                    },
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
                    trailing: Text(
                      _absenStatus[datas.nis] ?? keterangan,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
                backgroundColor: const Color.fromARGB(255, 73, 72, 72),
              ),
              onPressed: () async {
                final user =
                    Provider.of<SqliteUserProvider>(context, listen: false);
                final service = AkademikService();
                final scaffold = ScaffoldMessenger.of(context);
                var id = user.currentuser.siskonpsn;
                var tokenss = user.currentuser.tokenss;
                var action = 'update-aka-absen';
                var kodeakademik = arguments['kode_akademik'];

                try {
                  setState(() {
                    isLoading = true;
                  });
                  final provider =
                      Provider.of<AkademikProvider>(context, listen: false);
                  for (var datas in provider.presensi) {
                    if (_absenStatus[datas.nis] == null ||
                        _absenStatus[datas.nis]!.isEmpty) {
                      _absenStatus[datas.nis ?? ''] = 'Hadir';
                    }
                  }
                  if (id != null && tokenss != null && kodeakademik != null) {
                    await service.updatePresensi(
                      id: id,
                      tokenss: tokenss,
                      action: action,
                      kodeakademik: kodeakademik,
                      absen: _absenStatus, // Send the map with the status
                    );
                  }
                  setState(() {
                    isLoading = false;
                  });
                  scaffold.showSnackBar(
                    SnackBar(
                      backgroundColor:
                          // ignore: use_build_context_synchronously
                          Theme.of(context).colorScheme.primary,
                      content: Text('Berhasil update',
                          style: TextStyle(
                              color:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.onPrimary)),
                    ),
                  );
                } catch (e) {
                  return;
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    )
                  : const Text(
                      'Update Presensi',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
