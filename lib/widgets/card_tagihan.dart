import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/card_tagihan_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';

class CardTagihan extends StatelessWidget {
  const CardTagihan({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<CardTagihanProvider>().getTagihan(id: id, tokenss: tokenss);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<CardTagihanProvider>(
                    builder: (context, value, child) {
                      var tagihan = value.tagihan.tagihan;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Tagihan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp.$tagihan',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pushNamed(context, '/list-keuangan');
                    },
                    child: const Text(
                      'Bayar',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
