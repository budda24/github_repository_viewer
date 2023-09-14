import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future<void> showNoConnectionToast({
  required BuildContext context,
  required String message,
}) async {
  await showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return CustomDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 60,
          width: double.infinity,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
    barrierColor: Colors.black.withOpacity(0.5),
  );
}
