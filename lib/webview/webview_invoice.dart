import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInvoice extends StatefulWidget {
  const WebViewInvoice({super.key});

  @override
  State<WebViewInvoice> createState() => _WebViewInvoiceState();
}

class _WebViewInvoiceState extends State<WebViewInvoice> {
  String invoiceUrl = '';
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final Map<String, dynamic> arguments =
          // ignore: use_build_context_synchronously
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      invoiceUrl = arguments['invoiceurl'];
    }
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(invoiceUrl));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Payment Gateway'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
