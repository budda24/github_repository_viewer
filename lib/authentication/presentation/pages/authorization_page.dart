import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class AuthorizationScreen extends StatefulWidget {
  final Uri authorizationUrl;
  final void Function(Uri redirectUrl) onAuthorizationCodeRedirectAttempt;

  const AuthorizationScreen({
    required this.authorizationUrl,
    required this.onAuthorizationCodeRedirectAttempt,
    super.key,
  });

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.authorizationUrl.toString(),
          onWebViewCreated: (controller) {
            controller.clearCache();
            CookieManager().clearCookies();
          },
          navigationDelegate: (navReq) {
            if (navReq.url.startsWith(
              GithubAuthenticationRepository.redirectUrl.toString(),
            )) {
              widget.onAuthorizationCodeRedirectAttempt(
                Uri.parse(navReq.url),
              );

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
