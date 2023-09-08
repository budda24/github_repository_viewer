import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

extension BuildContextExt on BuildContext {
  StackRouter get routing => AutoRouter.of(this);
}
