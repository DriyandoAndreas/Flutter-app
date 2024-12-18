import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:app5/providers/perpus_provider.dart';
import 'package:app5/providers/sqlite_user_provider.dart';
import 'package:app5/services/perpus_service.dart';

class FormPengembalian extends StatefulWidget {
  const FormPengembalian({super.key});

  @override
  State<FormPengembalian> createState() => _FormPengembalianState();
}

class _FormPengembalianState extends State<FormPengembalian> {
  bool isLoading = false;
  TextEditingController noInventaris = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _scanQRCode(TextEditingController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRCodeScannerScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SqliteUserProvider>(context);
    var id = user.currentuser.siskonpsn;
    var tokenss = user.currentuser.tokenss;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Pengembalian'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kode Inventaris Buku'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: noInventaris,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Kode Inventaris',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () => _scanQRCode(noInventaris),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final scaffold = ScaffoldMessenger.of(context);
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      if (id != null && tokenss != null) {
                        int statuscode = await PerpusService().bukuKembali(
                          id: id,
                          tokenss: tokenss.substring(0, 30),
                          action: 'k',
                          kodeInventaris: noInventaris.text,
                        );
                        if (statuscode == 200) {
                          scaffold.showSnackBar(
                            SnackBar(
                              // ignore: use_build_context_synchronously
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.primary,
                              content: Text('Berhasil di kembalikan',
                                  style: TextStyle(
                                      // ignore: use_build_context_synchronously
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            // ignore: use_build_context_synchronously
                            context.read<PerpusProvider>().refresh(
                                id: id, tokenss: tokenss.substring(0, 30));
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          });
                        } else {
                          scaffold.showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Gagal di kembalikan',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      return;
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    backgroundColor: const Color.fromARGB(255, 73, 72, 72),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                      : const Text(
                          'Buku Kembali',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null && !_isScanned) {
            _isScanned = true;
            Navigator.pop(context, barcode.rawValue);
          }
        },
      ),
    );
  }
}
