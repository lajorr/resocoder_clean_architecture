import 'dart:io';

class FixtureReader {
  static String fixture(String name) =>
      File('test/fixtures/$name').readAsStringSync();
}
