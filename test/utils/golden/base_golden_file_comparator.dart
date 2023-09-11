// ignore_for_file: avoid-top-level-members-in-tests, prefer-correct-identifier-length, depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:image_compare/image_compare.dart' as image_compare;
import 'package:path/path.dart' as path;

// this Comparator checks the image difference pixel by pixel instead of byte by byte
class BaseGoldenFileComparator extends LocalFileComparator {
  factory BaseGoldenFileComparator() {
    final currentDirUri = goldenFileComparator is LocalFileComparator
        ? (goldenFileComparator as LocalFileComparator).basedir
        : Uri.file(Directory.current.path);

    final currentFileUri = Directory(currentDirUri.toFilePath()).listSync().first.uri;

    return BaseGoldenFileComparator._(
      currentFileUri,
    );
  }

  BaseGoldenFileComparator._(super.uri, {super.pathStyle}) : _path = _getPath(pathStyle);

  final maxImageDiffThreshold = 0.0;
  final path.Context _path;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    // Don't update goldens if images are identical
    if (!await _equals(golden, imageBytes, isTest: false)) {
      return super.update(golden, imageBytes);
    }
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) {
    return _equals(golden, imageBytes);
  }

  @override
  File getFailureFile(String failure, Uri golden, Uri basedir) {
    final fileName = golden.pathSegments.last;
    final testName = '${fileName.split(path.extension(fileName)).first}_$failure.png';

    return File(
      path.join(
        path.fromUri(_goldenFailuresPath(golden)),
        path.fromUri(testName),
      ),
    );
  }

  Future<bool> _equals(
    Uri golden,
    Uint8List imageBytes, {
    bool isTest = true,
  }) async {
    final goldenFile = _getGoldenFile(golden);

    if (!goldenFile.existsSync()) {
      if (isTest) {
        fail('Could not be compared against non-existent file: "$golden"');
      }

      return false;
    }

    final goldenBytes = await goldenFile.readAsBytes();
    final image1 = decodePng(goldenBytes)!;
    final image2 = decodePng(imageBytes)!;

    final imagesEqualSize = _haveSameSize(
      firstImg: image1,
      secondImg: image2,
    );

    if (!imagesEqualSize) {
      if (isTest) {
        await _generateFailureOutput(
          'Pixel test failed, image sizes do not match.\n'
          'Master Image: ${image1.width} X ${image1.height}\n'
          'Test Image: ${image2.width} X ${image2.height}',
          golden,
          false,
          masterImage: image1,
          testImage: image2,
        );
      }

      return false;
    }

    final diffValue = await image_compare.compareImages(
      src1: image1,
      src2: image2,
      algorithm: image_compare.PixelMatching(),
    );

    final isEqual = diffValue <= maxImageDiffThreshold;
    if (!isEqual) {
      if (isTest) {
        await _generateFailureOutput(
          'Pixel test failed, '
          '${diffValue * 100}% '
          'diff detected.',
          golden,
          true,
          masterImage: image1,
          testImage: image2,
        );
      } else {
        debugPrint(
          'Goldens will generate a new golden for $golden because the difference was ${diffValue * 100}% and the maximum allowed is $maxImageDiffThreshold.',
        );
      }
    }

    return isEqual;
  }

  File _getGoldenFile(Uri golden) => File(_path.join(_path.fromUri(basedir), _path.fromUri(golden.path)));

  static path.Context _getPath(path.Style? style) {
    return path.Context(style: style ?? path.Style.platform);
  }

  Image _generateDiffImage(Image firstImg, Image secondImg) {
    final width = firstImg.width;
    final height = firstImg.height;
    final diffImg = Image(width, height);

    for (var y = 0; y < height; ++y) {
      for (var x = 0; x < width; ++x) {
        final pixel1 = firstImg.getPixel(x, y);
        final pixel2 = secondImg.getPixel(x, y);

        if (pixel1 != pixel2) {
          diffImg.setPixelRgba(x, y, 255, 0, 0);
        } else {
          diffImg.setPixelRgba(x, y, 0, 0, 0);
        }
      }
    }

    return diffImg;
  }

  bool _haveSameSize({
    required Image firstImg,
    required Image secondImg,
  }) {
    return firstImg.width == secondImg.width && firstImg.height == secondImg.height;
  }

  Future<String> _generateFailureOutput(
    String error,
    Uri golden,
    bool generateDiffImage, {
    required Image masterImage,
    required Image testImage,
  }) {
    var additionalFeedback = '';
    additionalFeedback = '\nFailure feedback can be found at ${_goldenFailuresPath(golden)}';
    final diffs = <String, Image>{
      'masterImage': masterImage,
      'testImage': testImage,
    };
    if (generateDiffImage) {
      diffs.putIfAbsent(
        'maskedDiff',
        () => _generateDiffImage(masterImage, testImage),
      );
    }
    for (final entry in diffs.entries) {
      final output = getFailureFile(
        entry.key,
        golden,
        basedir,
      );
      output.parent.createSync(recursive: true);
      final png = encodePng(entry.value);

      output.writeAsBytesSync(png);
    }
    fail('Golden "$golden":$error $additionalFeedback');
  }

  String _goldenFailuresPath(Uri golden) {
    final goldenFolderPath = golden.toString().replaceFirst(golden.pathSegments.last, '');

    return path.join(
      path.fromUri(basedir),
      path.fromUri(Uri.parse(goldenFolderPath)),
      path.join('failures'),
    );
  }
}
