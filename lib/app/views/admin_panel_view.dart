import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdminPanelView extends StatelessWidget {
  final String adminPanelUrl;
  const AdminPanelView({super.key, required this.adminPanelUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: const Text('Pocketbase Mobile'),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(adminPanelUrl)),
      ),
    );
  }
}
