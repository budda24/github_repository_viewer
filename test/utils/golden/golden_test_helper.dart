// ignore_for_file: avoid-top-level-members-in-tests, prefer-correct-identifier-length, invalid_use_of_protected_member, avoid-substring, prefer_asserts_with_message, invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class GoldenTestHelper {
  static final defaultShowcaseTestDevices = [
    GoldenTestHelper.getDevice(DeviceNameEnum.iphone13mini),
    GoldenTestHelper.getDevice(DeviceNameEnum.tabletPortrait),
  ];
  static const safeArea = EdgeInsets.only(top: 44, bottom: 34);
  static final _devicesMap = <DeviceNameEnum, Device>{
    DeviceNameEnum.phone: Device.phone.copyWith(size: const Size(374, 667)),
    DeviceNameEnum.iphone11: Device.iphone11.copyWith(safeArea: safeArea),
    DeviceNameEnum.iphone11TS2: Device.iphone11.copyWith(
      name: 'iphone11_ts2',
      textScale: 2,
    ),
    DeviceNameEnum.tabletPortrait: Device.tabletPortrait.copyWith(safeArea: safeArea),
    DeviceNameEnum.iphone13mini: const Device(
      size: Size(375, 812),
      name: 'iphone_13_mini',
      safeArea: safeArea,
    ),
    DeviceNameEnum.sonyXperia1: const Device(
      size: Size(411, 960),
      name: 'sony_xperia_1',
      safeArea: safeArea,
    ),
  };

  static List<Device> get devicesToTest => _devicesMap.values.toList();

  static Future<void> onSetup() {
    return loadAppFonts();
  }

  static Device getDevice(DeviceNameEnum deviceNameEnum) => _devicesMap[deviceNameEnum]!;

  static String goldenPathFactory(String name, Device device) {
    return 'goldens/${_pathFactory(name, device)}.png';
  }

  /// used with [screenMatchesGolden] and [multiScreenGolden] function as they internally add "goldens/" as suffix and the image-type ".png"
  static String _pathFactory(String name, Device device) {
    return '$name/${device.name}';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (length <= 1) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toLowerSnakeCase() {
    return replaceAllMapped(
      RegExp('(?<=[a-z])([A-Z])'),
      (match) => '_${match.group(0)?.toLowerCase()}',
    ).replaceAllMapped(
      RegExp('(?<=/)([A-Z])'),
      (match) => '${match.group(0)?.toLowerCase()}',
    );
  }
}

enum DeviceNameEnum { phone, iphone11, iphone11TS2, tabletPortrait, iphone13mini, sonyXperia1 }
