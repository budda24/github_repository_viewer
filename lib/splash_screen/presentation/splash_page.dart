import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:repository_search/core/routes/app_routes.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      Timer(const Duration(seconds: 2), () {
        context.router.popAndPush(
          const HomeRoute(),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cable,
              size: 150,
            ),
            SizedBox(
              height: 15,
            ),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
