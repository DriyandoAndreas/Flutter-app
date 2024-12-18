// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/presensi_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/presensi_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

class SatListPresensiBulanan extends StatefulWidget {
  const SatListPresensiBulanan({super.key});

  @override
  State<SatListPresensiBulanan> createState() => _SatListPresensiBulananState();
}

class _SatListPresensiBulananState extends State<SatListPresensiBulanan> {
  String selectedBulan = DateFormat('MMMM', 'id_ID').format(DateTime.now());
  String selectedTahun = DateTime.now().year.toString();
  late List<DateTime> selectedDateIjin = [];
  late List<DateTime> selectedDateSakit = [];
  late List<String> tanggalijin = [];
  late List<String> tanggalsakit = [];
  TextEditingController keteranganIjin = TextEditingController();
  TextEditingController keteranganSakit = TextEditingController();
  String? fileName;
  String? base64File;
  String? type;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  late String angkabulan = bulanKeAngka(selectedBulan);
  late String fulldate = '$selectedTahun-$angkabulan-01';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final now = DateTime.now();
    selectedBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ][now.month - 1];
    selectedTahun = now.year.toString();
    initData();
  }

  Future<void> initData() async {
    try {
      await loadData();
    } catch (e) {
      return;
    }
  }

  Future<void> loadData() async {
    try {
      final user = Provider.of<SqliteUserProvider>(context, listen: false);
      var id = user.currentuser.siskonpsn;
      var tokenss = user.currentuser.tokenss;
      var nis = user.currentuser.siskokode;
      if (id != null && tokenss != null && nis != null) {
        context.read<SatPresensiProvider>().getpresensisum(
            id: id, tokenss: tokenss, kode: nis, tglabsensi: fulldate);
        context.read<SatPresensiProvider>().getPresensiBulanan(
            id: id, tokenss: tokenss, kode: nis, tglabsensi: fulldate);
      }
    } catch (e) {
      return;
    }
  }

  void showBulan() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: List.generate(12, (index) {
                  final bulan = DateTime(0, index + 1).month;
                  final namaBulan = [
                    'Januari',
                    'Februari',
                    'Maret',
                    'April',
                    'Mei',
                    'Juni',
                    'Juli',
                    'Agustus',
                    'September',
                    'Oktober',
                    'November',
                    'Desember'
                  ][bulan - 1];
                  return RadioListTile(
                    title: Text(namaBulan),
                    value: namaBulan,
                    groupValue: selectedBulan,
                    onChanged: (value) {
                      setState(() {
                        selectedBulan = value!;
                      });
                      this.setState(() {
                        selectedBulan = value!;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  void showTahun() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final currentYear = DateTime.now().year;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: List.generate(7, (index) {
                  final tahun = currentYear - index;
                  return RadioListTile(
                    title: Text(tahun.toString()),
                    value: tahun.toString(),
                    groupValue: selectedTahun,
                    onChanged: (value) {
                      setState(() {
                        selectedTahun = value!;
                      });
                      this.setState(() {
                        selectedTahun = value!;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  void formIjin() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: Container(
                        color: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Form Ijin',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.grey.shade800),
                              ),
                              onPressed: () async {
                                final user = Provider.of<SqliteUserProvider>(
                                    context,
                                    listen: false);
                                final service = SatPresensiService();
                                var kode = user.currentuser.siskokode;
                                var id = user.currentuser.siskonpsn;
                                var tokenss = user.currentuser.tokenss;
                                if (kode != null &&
                                    id != null &&
                                    tokenss != null) {
                                  await service.addFormIjin(
                                    id: id,
                                    tokenss: tokenss,
                                    kode: kode,
                                    tgl: tanggalijin,
                                    keterangan: keteranganIjin.text,
                                  );
                                  loadData();
                                  Navigator.pop(
                                      // ignore: use_build_context_synchronously
                                      context);
                                }
                              },
                              child: const Text(
                                'SIMPAN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Tanggal Ijin'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () {
                          _selectDateIjin(context, setState);
                        },
                        child: Text(
                          selectedDateIjin.isNotEmpty
                              ? selectedDateIjin
                                  .map((date) =>
                                      DateFormat('yyyy-MM-dd').format(date))
                                  .join(', ')
                              : 'Pilih Tanggal',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Keterangan'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: keteranganIjin,
                        decoration: const InputDecoration(
                            labelText: 'Jelaskan keterang ijin'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void formSakit() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: Container(
                        color: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Form Sakit',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.grey.shade800),
                              ),
                              onPressed: () async {
                                final user = Provider.of<SqliteUserProvider>(
                                    context,
                                    listen: false);
                                final service = SatPresensiService();
                                var kode = user.currentuser.siskokode;
                                var id = user.currentuser.siskonpsn;
                                var tokenss = user.currentuser.tokenss;
                                if (kode != null &&
                                    id != null &&
                                    tokenss != null) {
                                  await service.addFormSakit(
                                    id: id,
                                    tokenss: tokenss,
                                    kode: kode,
                                    tgl: tanggalsakit,
                                    filename: fileName ?? '',
                                    type: type ?? '',
                                    base64flutter: base64File ?? '',
                                    keterangan: keteranganSakit.text,
                                  );
                                  loadData();
                                  Navigator.pop(
                                      // ignore: use_build_context_synchronously
                                      context);
                                }
                              },
                              child: const Text(
                                'SIMPAN',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Tanggal Sakit'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () {
                          _selectDateSakit(context, setState);
                        },
                        child: Text(
                          selectedDateSakit.isNotEmpty
                              ? selectedDateSakit
                                  .map((date) =>
                                      DateFormat('yyyy-MM-dd').format(date))
                                  .join(', ')
                              : 'Pilih Tanggal',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Keterangan'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: keteranganSakit,
                        decoration: const InputDecoration(
                            labelText: 'Jelaskan keterang Sakit'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Surat Dokter/Puskesmas'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1,
                                    )),
                              ),
                            ),
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png'],
                                withData: true,
                              );
                              if (result != null) {
                                PlatformFile file = result.files.first;
                                setState(() {
                                  fileName = file.name;
                                  type = file.extension;
                                  base64File = base64Encode(file.bytes!);
                                });
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.attach_file),
                                Text('Pilih File'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            fileName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDateIjin(
      BuildContext context, StateSetter setState) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: SfDateRangePicker(
            headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Theme.of(context).colorScheme.primaryFixed),
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            showNavigationArrow: true,
            initialSelectedDates: selectedDateIjin,
            selectionMode: DateRangePickerSelectionMode.multiple,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                selectedDateIjin = args.value.cast<DateTime>();
                tanggalijin = selectedDateIjin
                    .map((date) => DateFormat('yyyy-MM-dd').format(date))
                    .toList();
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDateSakit(
      BuildContext context, StateSetter setState) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: SfDateRangePicker(
            headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Theme.of(context).colorScheme.primaryFixed),
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            showNavigationArrow: true,
            initialSelectedDates: selectedDateSakit,
            selectionMode: DateRangePickerSelectionMode.multiple,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                selectedDateSakit = args.value.cast<DateTime>();
                tanggalsakit = selectedDateSakit
                    .map((date) => DateFormat('yyyy-MM-dd').format(date))
                    .toList();
              });
            },
          ),
        );
      },
    );
  }

  Decoration _getDecorationForDay(
      Map<String, dynamic>? presensi, DateTime day) {
    if (presensi == null) return const BoxDecoration();

    final formattedDay = DateFormat('yyyy-MM-dd').format(day);
    final status = presensi[formattedDay];

    switch (status) {
      case 'H':
        return const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        );
      case 'S':
        return const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        );
      case 'I':
        return const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        );
      case 'A':
        return const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        );
      case 'T':
        return const BoxDecoration(
          color: Color.fromARGB(255, 255, 111, 0),
          shape: BoxShape.circle,
        );
      case 'B':
        return const BoxDecoration(
          color: Color.fromARGB(255, 183, 28, 28),
          shape: BoxShape.circle,
        );
      case 'D':
        return const BoxDecoration(
          color: Color.fromARGB(255, 13, 71, 161),
          shape: BoxShape.circle,
        );
      default:
        return const BoxDecoration(
          color: Colors.grey, // Default color if status is not 'H' or 'S'
          shape: BoxShape.circle,
        );
    }
  }

  String bulanKeAngka(String namaBulan) {
    List<String> bulan = [
      'januari',
      'februari',
      'maret',
      'april',
      'mei',
      'juni',
      'juli',
      'agustus',
      'september',
      'oktober',
      'november',
      'desember'
    ];

    int index = bulan.indexOf(namaBulan.toLowerCase());
    DateTime dateTime = DateTime(0, index + 1);
    return DateFormat('MM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final formatdate = DateFormat.yMMMMEEEEd('id_ID').format(now);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                )),
                          ),
                        ),
                        onPressed: showBulan,
                        child: Text(selectedBulan),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                )),
                          ),
                        ),
                        onPressed: showTahun,
                        child: Text(selectedTahun),
                      ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.grey.shade800),
                    ),
                    onPressed: () {
                      setState(() {
                        angkabulan = bulanKeAngka(selectedBulan);
                        fulldate = '$selectedTahun-$angkabulan-01';
                        _focusedDay = DateTime(
                            int.parse(selectedTahun), int.parse(angkabulan), 1);
                      });
                      loadData();
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Consumer<SatPresensiProvider>(
              builder: (context, presensiBulanan, child) {
                final firstDay = DateTime(
                    int.parse(selectedTahun), int.parse(angkabulan), 1);
                final lastDay = DateTime(
                    int.parse(selectedTahun), int.parse(angkabulan) + 1, 0);
                if (_focusedDay.isBefore(firstDay)) {
                  _focusedDay = firstDay;
                } else if (_focusedDay.isAfter(lastDay)) {
                  _focusedDay = lastDay;
                }
                return TableCalendar(
                  locale: 'id_ID',
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  availableGestures: AvailableGestures.none,
                  selectedDayPredicate: (day) {
                    if (presensiBulanan.presensi == null) {
                      return false;
                    }
                    final formattedDay = DateFormat('yyyy-MM-dd').format(day);
                    return presensiBulanan.presensi?[formattedDay] != false;
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, _) {
                      return Container(
                        decoration: _getDecorationForDay(
                            presensiBulanan.presensi, date),
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style:
                              const TextStyle().copyWith(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(formatdate.toString()),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.amber.shade800),
                        ),
                        onPressed: () {
                          formIjin();
                        },
                        child: const Text(
                          'AJUKAN IJIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.blue.shade800),
                        ),
                        onPressed: () {
                          formSakit();
                        },
                        child: const Text(
                          'INFOKAN SAKIT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Rekapilutasi'),
            ),
            Consumer<SatPresensiProvider>(
              builder: (context, datasum, child) {
                // ignore: unused_local_variable
                var label = '';
                switch (datasum.presensiSum.entries.map(
                  (e) => e.key,
                )) {
                  // ignore: duplicate_ignore
                  // ignore: constant_pattern_never_matches_value_type
                  case 'H':
                    label = 'Hadir';
                    break;
                  case 'S':
                    label = 'Sakit';
                    break;
                  case 'I':
                    label = 'Ijin';
                    break;
                  case 'A':
                    label = 'Aplha';
                    break;
                  case 'T':
                    label = 'Terlambat';
                    break;
                  case 'B':
                    label = 'Bolos';
                    break;
                  case 'D':
                    label = 'Dipulangkan';
                    break;
                  default:
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: datasum.presensiSum.entries.map((e) {
                    String label = '';
                    Color warna = Colors.black;
                    switch (e.key) {
                      case 'H':
                        label = 'Hadir';
                        warna = Colors.green;
                        break;
                      case 'S':
                        label = 'Sakit';
                        warna = Colors.blue;
                        break;
                      case 'I':
                        label = 'Ijin';
                        warna = Colors.amber;
                        break;
                      case 'A':
                        label = 'Alpha';
                        warna = Colors.red;
                        break;
                      case 'T':
                        label = 'Terlambat';
                        warna = Colors.amber.shade900;
                        break;
                      case 'B':
                        label = 'Bolos';
                        warna = Colors.red.shade900;
                        break;
                      case 'D':
                        label = 'Dipulangkan';
                        warna = Colors.blue.shade900;
                        break;
                      default:
                        label = 'Tidak diketahui';
                    }
                    return ListTile(
                      leading: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: warna,
                        ),
                        child: Center(
                          child: Text(
                            e.key,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      title: Text(label),
                      trailing: Text(e.value),
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
