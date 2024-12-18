import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/monitoring_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewMonitoringAktifitas extends StatelessWidget {
  const ViewMonitoringAktifitas({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<MonitoringProvider>().getListUser(id: id, tokenss: tokenss);
      context
          .read<MonitoringProvider>()
          .fetchAktifitas(id: id, tokenss: tokenss);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Monitoring Aktifitas'),
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, child) {
          if (provider.getGrAll.isEmpty &&
              provider.getKrAll.isEmpty &&
              provider.getXtAll.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Info akses per group pengguna',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildGauge(provider.getGrAll, provider.getGr, 'Guru',
                        Colors.amber.shade400, Colors.amber.shade800),
                    buildGauge(provider.getKrAll, provider.getKr, 'Karyawan',
                        Colors.blue.shade400, Colors.blue.shade800),
                    buildGauge(provider.getXtAll, provider.getXt, 'Extra',
                        Colors.red.shade400, Colors.red.shade800),
                  ],
                )),
                Expanded(
                  child: GroupedListView<ListMonitoringAktifitasModel, String>(
                    elements: [
                      ...provider.aktifitas.guru ?? [],
                      ...provider.aktifitas.karyawan ?? [],
                      ...provider.aktifitas.extra ?? []
                    ],
                    groupBy: (element) {
                      if (element.kodepegawai!.startsWith('GR')) {
                        return 'Guru';
                      } else if (element.kodepegawai!.startsWith('KR')) {
                        return 'Karyawan';
                      } else {
                        return 'Pegawai Extra';
                      }
                    },
                    groupSeparatorBuilder: (String groupByValue) => Container(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          groupByValue,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    order: GroupedListOrder.ASC,
                    useStickyGroupSeparators: true,
                    itemBuilder: (context, element) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Text(element.namalengkap!),
                        subtitle: Text(
                          '${element.lastaccess} [ip: ${element.lastip}]',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: element.logincounter == '0'
                                  ? Colors.red.shade400
                                  : Colors.blue.shade400,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: element.logincounter == '0'
                                    ? const Text(
                                        'Pasif',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )
                                    : Text(
                                        '${element.logincounter}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildGauge(
    List<UserMonitoringAktifitasModel> allData,
    List<UserMonitoringAktifitasModel> data,
    String label,
    Color warna1,
    Color warna2,
  ) {
    double max = allData.isNotEmpty
        ? double.tryParse(allData.first.jumlah ?? '0') ?? 0
        : 0;
    double value =
        data.isNotEmpty ? double.tryParse(data.first.jumlah ?? '0') ?? 0 : 0;
    double percentage = max > 0 ? (value / max) * 100 : 0;
    if (max <= 0) {
      max = 1;
      value = 0;
      percentage = 0;
    }
    return Column(
      children: [
        SizedBox(
          width: 110,
          height: 110,
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
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  ' / ${max.toStringAsFixed(0)}',
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
