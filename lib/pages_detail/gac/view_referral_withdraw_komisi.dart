import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewReferralWithdrawKomisi extends StatelessWidget {
  const ViewReferralWithdrawKomisi({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context.read<ReferralProvider>().getDashboard(id: id, tokenss: tokenss);
    }
    urlLuncer(String urls) async {
      final Uri url = Uri.parse(urls);
      if (!await launchUrl(url)) {
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Withdraw Komisi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ReferralProvider>(
          builder: (context, value, child) {
            int komisi = int.parse(value.referraldashboard.komisi ?? '');
            var iswithdraw = false;
            if (komisi > 500.000) {
              iswithdraw = true;
            }
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  iswithdraw == true
                      ? const Text('Anda sudah dapat melakukan withdraw')
                      : const Text('Anda belum dapat melakukan withdraw'),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Rp. $komisi/500.000 ',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'minimal melakukan withdraw adalah Rp.500.000',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey),
                      onPressed: () {
                        iswithdraw == true
                            ? urlLuncer(
                                'https://wa.me/+6288806117755?text=Halo%20nama%20saya%20')
                            : null;
                      },
                      child: const Text(
                        'WITHDRAW SEKARANG',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
