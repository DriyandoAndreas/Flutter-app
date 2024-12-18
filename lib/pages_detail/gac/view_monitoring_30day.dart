import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/monitoring_model.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewMonitoring30Day extends StatefulWidget {
  const ViewMonitoring30Day({super.key});

  @override
  State<ViewMonitoring30Day> createState() => _ViewMonitoring30DayState();
}

class _ViewMonitoring30DayState extends State<ViewMonitoring30Day> {
  final ScrollController _scrollController = ScrollController();
  int _currentLimit = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreData();
      }
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<MonitoringProvider>()
          .getAktivitas30Day(id: id, tokenss: tokenss, limit: _currentLimit);
    }
  }

  void _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      await context
          .read<MonitoringProvider>()
          .getAktivitas30Day(id: id, tokenss: tokenss, limit: _currentLimit);
    }

    setState(() {
      _currentLimit += 10;
      _isLoadingMore = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Monitoring Aktifitas(30 hari)'),
      ),
      body: Consumer<MonitoringProvider>(
        builder: (context, provider, child) {
          if (provider.monitoringData == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            var day = provider.monitoringData?.jumlahhari;
            var totalday = '30';
            var list = provider.monitoringData?.data;

            return Column(
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildGauge(day!, totalday, Colors.amber.shade400,
                          Colors.amber.shade800),
                    ],
                  ),
                ),
                Expanded(
                  child: GroupedListView(
                    controller: _scrollController, // Attach ScrollController
                    shrinkWrap: true,
                    elements: list!,
                    groupBy: (element) {
                      return element.datetime!;
                    },
                    groupSeparatorBuilder: (String groupByValue) => Container(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        groupByValue,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    itemBuilder: (context, dynamic element) {
                      MonitoringAktifitas30Day item = element;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item.namalengkap}'),
                              Text(
                                '${item.url}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                              Text(
                                '${item.datetime} [${item.ip}]',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                color: Colors.blue.shade400,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '${item.action}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    order: GroupedListOrder.DESC,
                    useStickyGroupSeparators: true,
                  ),
                ),
                if (_isLoadingMore) const CircularProgressIndicator.adaptive(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildGauge(int data, String alldata, Color warna1, Color warna2) {
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
                                  ' ${value.toStringAsFixed(0)} hari aktif',
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
      ],
    );
  }
}
