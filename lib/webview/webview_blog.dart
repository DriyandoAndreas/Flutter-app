import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.sisko-online.com/category/blog'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
