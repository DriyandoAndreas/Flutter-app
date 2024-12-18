import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/akademik_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class SatListAkademik extends StatefulWidget {
  const SatListAkademik({super.key});

  @override
  State<SatListAkademik> createState() => _SatListAkademikState();
}

class _SatListAkademikState extends State<SatListAkademik> {
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
      context.read<AkademikProvider>().loadAkademikData(
            id: id,
            tokenss: tokenss,
            date: formattedDate,
          );
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
        context.read<AkademikProvider>().loadAkademikData(
              id: id,
              tokenss: tokenss,
              date: formattedDate,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var formateddate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Agenda Akademik',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              formateddate,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _selectDate(context),
            child: const Icon(Icons.date_range),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<AkademikProvider>(
          builder: (context, provider, child) {
            if (provider.kelasList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Column(
              children: provider.kelasList.map(
                (e) {
                  return Column(
                    children: [
                      if (e.listData == null || e.listData!.isEmpty)
                        const SizedBox.shrink()
                      else
                        ...e.listData!.map(
                          (data) {
                            double absen = double.parse(data.absenht ?? '');
                            double totalabsen = double.parse(data.absen ?? '');
                            var persentase = absen / totalabsen * 100;
                            return Card(
                              color: Theme.of(context).colorScheme.onPrimary,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Card(
                                              color: data.mulaipukul != ''
                                                  ? Colors.amber.shade600
                                                  : Colors.blue.shade600,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: data.mulaipukul != ''
                                                    ? Text(
                                                        '${data.mulaipukul?.substring(0, 5)}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white))
                                                    : Text(
                                                        '${data.mulai?.substring(0, 5)}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                              ),
                                            ),
                                            Card(
                                              color: data.status == "Selesai"
                                                  ? Colors.green.shade800
                                                  : Colors.blue.shade600,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: data.selesaipukul != ''
                                                    ? Text(
                                                        '${data.selesaipukul?.substring(0, 5)}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white))
                                                    : Text(
                                                        '${data.selesai?.substring(0, 5)}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        data.status != ''
                                            ? Card(
                                                color: data.status ==
                                                        'Konfirmasi'
                                                    ? Colors.amber.shade800
                                                    : data.status == 'Mulai'
                                                        ? Colors.green.shade600
                                                        : data.status ==
                                                                'Selesai'
                                                            ? Colors
                                                                .blue.shade800
                                                            : data.status ==
                                                                    'SUKSES'
                                                                ? Colors.green
                                                                    .shade900
                                                                : null,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(data.status ?? '',
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ))
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      data.namaPljrn ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      data.namalengkap ?? '',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    data.halpersiapan != '' &&
                                            data.status != '' &&
                                            data.status != 'SUKSES'
                                        ? Text(
                                            "Materi persiapan: ${data.halpersiapan}")
                                        : data.status == 'SUKSES'
                                            ? Text(
                                                'Materi: ${data.materiyangdiberikan}')
                                            : const SizedBox.shrink(),
                                    data.tugassiswa != '' &&
                                            data.status != '' &&
                                            data.status != 'SUKSES'
                                        ? Text("Persiapan: ${data.tugassiswa}")
                                        : data.status == 'SUKSES'
                                            ? Text('PR: ${data.tugaspr}')
                                            : const SizedBox.shrink(),
                                    data.status == 'SUKSES'
                                        ? Text(
                                            'Kendala: ${data.hambatankendala}')
                                        : const SizedBox.shrink(),
                                    data.status == 'SUKSES'
                                        ? Text(
                                            'Persiapan berikutnya: ${data.persiapanberikutnya}')
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    data.absen != '0' && data.absenht != '0'
                                        ? Card(
                                            color: Colors.green.shade400,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    '${persentase.toStringAsFixed(0)}%',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                    ],
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }
}
