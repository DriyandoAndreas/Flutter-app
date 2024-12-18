import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/user_service.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("QR Web Dashboard Login"),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: (capture) async {
          UserService service = UserService();
          final user = Provider.of<SqliteUserProvider>(context, listen: false);
          var iduser = user.currentuser.iduser;
          var token = user.currentuser.token;
          final barcodes = capture.barcodes.first;
          final barcodeValue = barcodes.rawValue ?? '';

          RegExp regExp = RegExp(
              r'https?:\/\/(sisko|sisuka).(cloud|id)\/Wss\/login\/sisko\/(.+)$');
          var sessionid = '';
          var match = regExp.firstMatch(barcodeValue);
          if (match != null && match.groupCount >= 2) {
            sessionid = match.group(3) ?? '';
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Barcode tidak valid',
                  textAlign: TextAlign.center,
                ),
              ),
            );
            return;
          }
          try {
            if (await service.setSession(
              action: 'setSession',
              sessionid: sessionid,
              iduser: iduser ?? '',
              token: token ?? '',
            )) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Berhasil login',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Gagal login',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } catch (e) {
            return;
          }
        },
      ),
    );
  }
}
