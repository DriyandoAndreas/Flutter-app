import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:app5/providers/referral_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralLink extends StatelessWidget {
  const ReferralLink({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context, listen: false);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    if (id != null && tokenss != null) {
      context
          .read<ReferralProvider>()
          .getReferralData(id: id, tokenss: tokenss);
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
        automaticallyImplyLeading: false,
        title: const Text('Referral Link'),
      ),
      body: Consumer<ReferralProvider>(
        builder: (context, value, child) {
          var csfid = value.referraldata.csfid;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    ' https://register.sisko-online.com/aff_/$csfid',
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                      ),
                      onPressed: () {
                        urlLuncer(
                            'https://register.sisko-online.com/aff_/$csfid');
                      },
                      child: const Text(
                        'Bagikan Link',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        Restart.restartApp();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text(
                        'Tutup',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
