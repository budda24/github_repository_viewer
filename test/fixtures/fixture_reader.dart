// ignore_for_file: unnecessary_string_escapes

import 'dart:io';

class FixtureReader<T> {}

String fixture(String name) => File('test\/fixtures\/$name').readAsStringSync();
