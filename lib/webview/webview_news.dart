import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.kamadeva.com/web/term/view/news'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
