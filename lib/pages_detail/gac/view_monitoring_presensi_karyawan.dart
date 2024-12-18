import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewMonitoringPresensiKaryawan extends StatelessWidget {
  const ViewMonitoringPresensiKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<MonitoringProvider>()
          .getPresenKaryawan(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Presensi Pegawai'),
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, child) {
          if (provider.karyawan?.jumlahall == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            var all = provider.karyawan?.jumlahall;
            var mesintap = provider.karyawan?.jumlahtapping;
            var hadir = provider.karyawan?.jumlahhadir;
            var terlambat = provider.karyawan?.jumlahterlambat;
            var sakit = provider.karyawan?.jumlahsakit;
            var ijin = provider.karyawan?.jumlahijin;
            var alpha = provider.karyawan?.jumlahalpha;
            var tanpaketerangan = provider.karyawan?.jumlahtanpaketerangan;
            var dipulangkan = provider.karyawan?.jumlahdidinasluar;
            var bolos = provider.karyawan?.jumlahtbolos;
            var cuti = provider.karyawan?.jumlahtcuti;
            var today = DateTime.now();
            String dateFormat = DateFormat.yMMMMd('id_ID').format(today);
            // TODO: overflow layar < 600px
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Total siswa $all, $dateFormat',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildGauge(mesintap!, all!, 'Mesin Tap',
                            Colors.amber.shade400, Colors.amber.shade800),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        buildGauge(hadir!, all, 'Hadir', Colors.green.shade400,
                            Colors.green.shade800),
                        buildGauge(terlambat!, all, 'Terlambat',
                            Colors.green.shade400, Colors.green.shade800)
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildGauge(sakit!, all, 'Sakit', Colors.blue.shade400,
                            Colors.blue.shade800),
                        buildGauge(ijin!, all, 'Ijin', Colors.green.shade800,
                            Colors.red.shade800),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildGauge(alpha!, all, 'Alpha', Colors.green.shade800,
                            Colors.red.shade800),
                        buildGauge(tanpaketerangan!, all, 'Tanpa Keterangan',
                            Colors.pink.shade400, Colors.pink.shade800),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildGauge(dipulangkan!, all, 'Alpha',
                            Colors.purple.shade400, Colors.purple.shade800),
                        buildGauge(bolos!, all, 'Tanpa Keterangan',
                            Colors.red.shade400, Colors.red.shade800),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildGauge(cuti!, all, 'Cuti', Colors.pink.shade400,
                            Colors.pink.shade800),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildGauge(
      int data, String alldata, String label, Color warna1, Color warna2) {
    double max = alldata.isNotEmpty ? double.tryParse(alldata) ?? 0 : 0;
    double value = data.toDouble();
    double percentage = max > 0 ? (value / max) * 100 : 0;
    if (max <= 0) {
      max = 1;
      value = 0;
    }
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                radiusFactor: 0.8,
                minimum: 0,
                maximum: max,
                axisLineStyle: const AxisLineStyle(
                  thicknessUnit: GaugeSizeUnit.factor,
                  thickness: 0.15,
                ),
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    angle: 180,
                    widget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  ' ${value.toStringAsFixed(0)} $label',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: value,
                    cornerStyle: CornerStyle.bothCurve,
                    enableAnimation: true,
                    animationDuration: 1200,
                    sizeUnit: GaugeSizeUnit.factor,
                    gradient: SweepGradient(
                      colors: <Color>[
                        warna1,
                        warna2,
                      ],
                      stops: const <double>[0.25, 0.75],
                    ),
                    color: const Color(0xFF00A8B5),
                    width: 0.15,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
