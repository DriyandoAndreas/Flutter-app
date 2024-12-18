import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewMonitoringConnected extends StatelessWidget {
  const ViewMonitoringConnected({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<MonitoringProvider>().getKoneksi(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Jumlah Koneksi Smartphone'),
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, child) {
          if (provider.monitoringKoneksi.g == null &&
              provider.monitoringKoneksi.k == null &&
              provider.monitoringKoneksi.s == null &&
              provider.monitoringKoneksi.o == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            var totalkoneksiortu =
                int.parse(provider.monitoringKoneksi.totalConnectionssiswa!);
            var totalortu = totalkoneksiortu * 2;
            // TODO: overflow layar < 600px
            return Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Connection',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                    child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildGauge(
                            provider.monitoringKoneksi.g!,
                            provider.monitoringKoneksi.totalConnectionsguru!,
                            'Guru',
                            Colors.amber.shade400,
                            Colors.amber.shade800),
                        buildGauge(
                            provider.monitoringKoneksi.k!,
                            provider
                                .monitoringKoneksi.totalConnectionskaryawan!,
                            'Karyawan',
                            Colors.green.shade400,
                            Colors.green.shade800),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildGauge(
                            provider.monitoringKoneksi.s!,
                            provider.monitoringKoneksi.totalConnectionssiswa!,
                            'Siswa',
                            Colors.grey.shade600,
                            Colors.grey.shade900),
                        buildGauge(
                            provider.monitoringKoneksi.o!,
                            totalortu.toString(),
                            'Orang tua',
                            Colors.pink.shade400,
                            Colors.pink.shade800),
                      ],
                    ),
                  ],
                )),
              ],
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
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  ' dari ${max.toStringAsFixed(0)} $label',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
