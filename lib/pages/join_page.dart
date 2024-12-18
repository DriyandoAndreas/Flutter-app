import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/providers/user_provider.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var token = user.currentuser.token;
    if (token != null) {
      context.read<UserProvider>().getRegisterAt(token: token);
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('SISKO Connect'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.list.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(thickness: 0.1);
            },
            shrinkWrap: true,
            itemCount: provider.list.length,
            itemBuilder: (context, index) {
              var data = provider.list[index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/school-connect', arguments: {
                    'npsn': data.npsn,
                    'token': token,
                  });
                },
                leading: const Icon(Icons.domain),
                title: Row(
                  children: [
                    Text(
                      '${data.namalengkap}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    data.sebagailabel != '' && data.sebagailabel != null
                        ? Text(
                            '(${data.sebagailabel})',
                            style: const TextStyle(fontSize: 12),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                subtitle: Text('(${data.npsn}) ${data.schoolname}'),
              );
            },
          );
        },
      ),
    );
  }
}
