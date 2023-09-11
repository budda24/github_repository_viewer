// ignore_for_file: prefer-match-file-name, avoid-top-level-members-in-tests, prefer-correct-identifier-length, invalid_use_of_protected_member, prefer-static-class, avoid-substring, avoid-global-state

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verify a valid link structure has been created. This routine checks for the
/// link text and the associated [TapGestureRecognizer] on the text span.
void expectValidLink(String linkText) {
  final richTextFinder = find.byType(RichText);
  expect(richTextFinder, findsOneWidget);
  final richText = richTextFinder.evaluate().first.widget as RichText;

  // Verify the link text.
  expect(richText.text, isNotNull);
  expect(richText.text, isA<TextSpan>());

  // Verify the link text is a onTap gesture recognizer.
  final textSpan = richText.text as TextSpan;
  expectLinkTextSpan(textSpan, linkText);
}

void expectLinkTextSpan(TextSpan textSpan, String linkText) {
  expect(textSpan.children, isNull);
  expect(textSpan.toPlainText(), linkText);
  expect(textSpan.recognizer, isNotNull);
  expect(textSpan.recognizer, isA<TapGestureRecognizer>());
  final tapRecognizer = textSpan.recognizer as TapGestureRecognizer?;
  expect(tapRecognizer?.onTap, isNotNull);

  // Execute the onTap callback handler.
  tapRecognizer!.onTap!();
}

@immutable
class MarkdownLink {
  const MarkdownLink(this.clickableText, this.destination);

  final String clickableText;
  final String? destination;

  @override
  bool operator ==(Object other) =>
      other is MarkdownLink && other.clickableText == clickableText && other.destination == destination;

  @override
  int get hashCode => '$clickableText$destination'.hashCode;

  @override
  String toString() {
    return '[$clickableText]($destination)';
  }
}

void expectLinkTap(MarkdownLink? actual, MarkdownLink expected) {
  expect(
    actual,
    equals(expected),
    reason: 'incorrect link tap results, actual: $actual expected: $expected',
  );
}
