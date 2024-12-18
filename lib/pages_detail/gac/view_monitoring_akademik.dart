import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk format tanggal

class ViewMonitoringAkademik extends StatefulWidget {
  const ViewMonitoringAkademik({super.key});

  @override
  State<ViewMonitoringAkademik> createState() => _ViewMonitoringAkademikState();
}

class _ViewMonitoringAkademikState extends State<ViewMonitoringAkademik> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Fetch initial data on app start
  }

  void _fetchInitialData() {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    if (id != null && tokenss != null) {
      context.read<MonitoringProvider>().loadAkademikData(
            id: id,
            tokenss: tokenss,
            date: formattedDate,
          );
    }
  }

  urlLuncer(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url)) {
      return;
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // ignore: use_build_context_synchronously
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;

      if (id != null && tokenss != null) {
        // ignore: use_build_context_synchronously
        context.read<MonitoringProvider>().loadAkademikData(
              id: id,
              tokenss: tokenss,
              date: formattedDate,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Akademik'),
        actions: [
          TextButton(
            onPressed: () => _selectDate(context),
            child: const Icon(Icons.date_range),
          ),
        ],
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, child) {
          if (provider.kelasList.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: provider.kelasList.map((kelas) {
                return Container(
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: Theme.of(context).colorScheme.primaryFixed),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kelas.namaKelas!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (kelas.listData == null || kelas.listData!.isEmpty)
                            const SizedBox.shrink()
                          else
                            ...kelas.listData!.map((data) {
                              double presensi =
                                  double.parse(data.presensi ?? '0');
                              double presensitotal =
                                  double.parse(data.presensitotal ?? '0');

                              double presentase =
                                  (presensi / presensitotal) * 100;

                              return Column(
                                children: [
                                  Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryFixed,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  data.mulaipukul != ''
                                                      ? Card(
                                                          color: Colors.amber,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.mulaipukul!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      : Card(
                                                          color: Colors.blue,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.mulai!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                  data.selesaipukul != '' &&
                                                              data.status ==
                                                                  'Selesai' ||
                                                          data.status ==
                                                              'SUKSES'
                                                      ? Card(
                                                          color: Colors.blue,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.selesaipukul!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      : Card(
                                                          color: Colors.blue,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.selesai!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  data.status != ''
                                                      ? Card(
                                                          color: data.status ==
                                                                  'SUKSES'
                                                              ? Colors.green
                                                              : data.status ==
                                                                      'Selesai'
                                                                  ? Colors.blue
                                                                  : data.status ==
                                                                          'Mulai'
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .amber,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.status ?? '',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              data.namaPljrn!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              data.namalengkap!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          data.materi != ''
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                      'Materi: ${data.materi}'),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          data.pr != ''
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text('PR: ${data.pr}'),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          data.hambatan != ''
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                      'Kendala: ${data.hambatan}'),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          data.persiapan != ''
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                      'Persiapan berikutnya: ${data.persiapan}'),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              data.presensi != '0' &&
                                                      data.presensitotal != '0'
                                                  ? Card(
                                                      color: Colors.grey,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Text(
                                                          '${presensi.toStringAsFixed(0)}/${presensitotal.toStringAsFixed(0)} ${presentase.toStringAsFixed(0)}%',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                              IconButton(
                                                  onPressed: () {
                                                    urlLuncer(
                                                        'https://wa.me/${data.nohp}');
                                                  },
                                                  icon: const Icon(
                                                      Icons.chat_outlined))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          data.presensi != '0' &&
                                                  data.presensitotal != '0'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/view-monitoring-akademik-presensi-detail',
                                                            arguments: <String,
                                                                dynamic>{
                                                              'id_akademik': data
                                                                  .idakademik,
                                                              'nama_pljrn': data
                                                                  .namaPljrn,
                                                              'mulai':
                                                                  data.mulai,
                                                              'selesai':
                                                                  data.selesai,
                                                              'tanggal':
                                                                  data.tanggal,
                                                            });
                                                      },
                                                      icon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child: Badge(
                                                          isLabelVisible: true,
                                                          label: Text(
                                                              '${presentase.toStringAsFixed(0)}%'),
                                                          offset: const Offset(
                                                              -2, -4),
                                                          backgroundColor:
                                                              presentase > 50
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          child: const Icon(
                                                            Icons
                                                                .person_outline,
                                                            size: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
