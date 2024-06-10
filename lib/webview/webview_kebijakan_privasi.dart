import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KebijakanPrivasi extends StatefulWidget {
  const KebijakanPrivasi({super.key});

  @override
  State<KebijakanPrivasi> createState() => _KebijakanPrivasiState();
}

class _KebijakanPrivasiState extends State<KebijakanPrivasi> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.sisko-online.com/privacy-policy'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
