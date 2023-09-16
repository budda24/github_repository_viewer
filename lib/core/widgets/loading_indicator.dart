import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
      indicatorType: Indicator.ballPulse,
      colors: [Colors.black],
      strokeWidth: 2,
      backgroundColor: Colors.white,
      pathBackgroundColor: Colors.black,
    );
  }
}
