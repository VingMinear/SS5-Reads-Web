import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:homework3/routes/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.url,
  });
  final String url;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView>
    with WidgetsBindingObserver {
  late WebViewController _controller;
  bool loading = true;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            setState(() {
              loading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print(error.toString());
          },
          onNavigationRequest: (NavigationRequest request) async {
            log("onNavigationRequest ----------->🌏:${request.url}");
            if (request.url.contains('success')) {
              router.pop(true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        // openLink(
        //   url: widget.deepLink,
        //   prefix: PrefixLauncher.none,
        // );
      },
    );
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(10),
              child: FadeIn(child: const CircularProgressIndicator()),
            )
          : SafeArea(
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
    );
  }
}
