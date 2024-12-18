import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/monitoring_model.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListViewMonitoringActivityKaryawan extends StatelessWidget {
  const ListViewMonitoringActivityKaryawan({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<MonitoringProvider>()
          .getTotalActivityKaryawan(id: id, tokenss: tokenss);
    }
    return Column(
      children: [
        Expanded(
          child: Consumer<MonitoringProvider>(
            builder: (context, provider, child) {
              if (provider.ackaryawan.isEmpty &&
                  provider.totalactivitykaryawan.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                var itemList = provider.ackaryawan;
                var totalActivityMap = {
                  for (var item in provider.totalactivitykaryawan)
                    item.thnbln: item.total
                };

                return GroupedListView(
                  shrinkWrap: true,
                  elements: itemList,
                  groupBy: (element) => element.thnbln!,
                  groupSeparatorBuilder: (String groupByValue) {
                    var total = totalActivityMap[groupByValue] ?? '0';
                    var groupText = '$groupByValue [ Total Aktivitas: $total ]';
                    return Container(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        groupText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  itemBuilder: (context, dynamic element) {
                    MonitoringActivitySummaryModel item = element;
                    var totalForMonth =
                        int.parse(totalActivityMap[item.thnbln] ?? '0');
                    var itemJumlahAksi = int.parse(item.jumlahaksi ?? '0');
                    var percentage = totalForMonth > 0
                        ? (itemJumlahAksi / totalForMonth * 100)
                            .toStringAsFixed(2)
                        : '0%';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.namalengkap}'),
                            Text(
                              '${item.iduser}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 12,
                              ),
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
                                  '$percentage% (${item.jumlahaksi})',
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
