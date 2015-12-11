import 'dart:io';

import 'package:grinder/grinder.dart';

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


@Task('Gather and send coverage data.')
void coverage() {
  final String coverageToken = Platform.environment['COVERAGE_TOKEN'];

  if (coverageToken != null) {
    PubApp coverallsApp = new PubApp.global('dart_coveralls');
    coverallsApp.run([
      'report',
      '--retry',
      '2',
      '--exclude-test-files',
      '--token',
      coverageToken,
      'test/all.dart'
    ]);
  } else {
    log('Skipping coverage task: no environment variable `COVERAGE_TOKEN` found.');
  }
}