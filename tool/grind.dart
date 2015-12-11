import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:grinder/src/utils.dart';

void main(List<String> args) {
  grind(args);
}

@Task()
void analyze() {
  new PubApp.global('tuneup')..runAsync(['check', '--ignore-infos']);
}

@Task()
void test() {
  new TestRunner().testAsync();
}

@Task('Apply dartfmt to all Dart source files')
void format() {
  DartFmt.format(existingSourceDirs);
}

@Task('Apply dartfmt to all Dart source files')
void testdartfmt() {
  if (DartFmt.dryRun(existingSourceDirs)) {
    throw "dartfmt failure";
  }
}
