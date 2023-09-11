// ignore_for_file: avoid-top-level-members-in-tests, prefer-correct-identifier-length, invalid_use_of_protected_member, prefer-static-class, avoid-substring, avoid-global-state

import 'package:flutter/material.dart';

typedef TestWidgetBuilder = Widget Function(
  Widget widget, {
  bool needsScaffold,
});

TestWidgetBuilder testWidgetBuilder = throw UnimplementedError();
