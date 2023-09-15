import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'utils/golden/base_golden_file_comparator.dart';
import 'utils/golden/golden_test_helper.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  goldenFileComparator = BaseGoldenFileComparator();
  await loadAppFonts();

  return GoldenToolkit.runWithConfiguration(
    () async {
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      skipGoldenAssertion: () => !Platform.isMacOS,
      deviceFileNameFactory: GoldenTestHelper.goldenPathFactory,
      defaultDevices: GoldenTestHelper.devicesToTest,
      enableRealShadows: true,
    ),
  );
}
