import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/env.dart';
import '../../utils/colors.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  var isLoad = true;
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    setState(() {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(ColorTheme.primaryColor.withOpacity(0.2))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String? url) {
              setState(() {
                isLoad = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(Env().privacyPolicyUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Privacy Policy"),
              backgroundColor: ColorTheme.primaryColor,
            ),
            body: Container(
                child: isLoad
                    ? Center(
                        child: CircularProgressIndicator(
                        color: ColorTheme.darkGreen,
                      ))
                    : WebViewWidget(controller: controller!))));
  }
}
