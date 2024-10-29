import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/webview_provider.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            Provider.of<WebViewProvider>(context, listen: false).setLoading(true);
          },
          onPageFinished: (url) {
            Provider.of<WebViewProvider>(context, listen: false).setLoading(false);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            Provider.of<WebViewProvider>(context, listen: false).setError('Failed to load page: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load page: ${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(Provider.of<WebViewProvider>(context, listen: false).currentUrl));
  }

  @override
  Widget build(BuildContext context) {
    final webViewProvider = Provider.of<WebViewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        actions: [
          if (webViewProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          PopupMenuButton<String>(
            onSelected: (String url) {
              webViewProvider.updateUrl(url);
              _controller.loadRequest(Uri.parse(url));
            },
            itemBuilder: (BuildContext context) {
              return webViewProvider.urls.map((String url) {
                return PopupMenuItem<String>(
                  value: url,
                  child: Text(url),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _controller.reload();
        },
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (webViewProvider.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (webViewProvider.error != null)
              Center(
                child: Text(
                  webViewProvider.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
