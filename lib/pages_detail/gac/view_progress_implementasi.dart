import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:app5/models/monitoring_model.dart';
import 'package:app5/providers/monitoring_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ViewProgressImplementasi extends StatelessWidget {
  const ViewProgressImplementasi({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<MonitoringProvider>().getProgress(id: id, tokenss: tokenss);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Progress Implementasi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MonitoringProvider>(
              builder: (context, provider, child) {
                if (provider.groups == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  List<dynamic> itemList = [];
                  for (var group in provider.groups!) {
                    itemList.addAll(group.list!.map((item) => {
                          'group': group.group,
                          'item': item,
                        }));
                  }
                  return GroupedListView(
                    shrinkWrap: true,
                    elements: itemList,
                    groupBy: (element) => element['group'],
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
                      MonitoringProgressImpelementasi item = element['item'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('${item.nama}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                color: item.query == 'Belum Digunakan'
                                    ? Colors.red.shade400
                                    : Colors.blue.shade400,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    '${item.query}',
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
                    // optional
                    useStickyGroupSeparators: true, // optional
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
