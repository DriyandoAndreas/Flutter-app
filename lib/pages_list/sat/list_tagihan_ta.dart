import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/keuangan_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class ListTagihanTa extends StatelessWidget {
  const ListTagihanTa({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<KeuanganProvider>().getListTagihan(id: id, tokenss: tokenss);
    }
    return Consumer<KeuanganProvider>(
      builder: (context, tgh, child) {
        return Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: ListView.builder(
            itemCount: tgh.listTgh.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final tagihan = tgh.listTgh[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/form-invoice',
                          arguments: tagihan);
                    },
                    leading: const Icon(Icons.wysiwyg_outlined),
                    title: Text(tagihan.thnPljrn ?? ''),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.tertiary),
                      child: Center(
                          child: Text('${tagihan.jmlTempoInv}',
                              style: const TextStyle(color: Colors.white))),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
