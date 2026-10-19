import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XenditWebViewScreen extends StatefulWidget {
  final String invoiceUrl;

  const XenditWebViewScreen({super.key, required this.invoiceUrl});

  @override
  State<XenditWebViewScreen> createState() => _XenditWebViewScreenState();
}

class _XenditWebViewScreenState extends State<XenditWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.invoiceUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xendit Payment Simulation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}