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

/// Utility class for invoking `dartfmt` from the SDK. This wrapper requires
/// the `dartfmt` from SDK 1.9 and greater.
class DartFmt {
  /// Run the `dartfmt` command with the `--overwrite` option. Format a file, a
  /// directory or a list of files or directories in place.
  static void format(fileOrPath, {int lineLength}) {
    _run('--overwrite', coerceToPathList(fileOrPath), lineLength: lineLength);
  }

  /// Run the `dartfmt` command with the `--dry-run` option. Return `true` if
  /// any files would be changed by running the formatter.
  static bool dryRun(fileOrPath, {int lineLength}) {
    String results =
    _run('--dry-run', coerceToPathList(fileOrPath), lineLength: lineLength);
    print(results);
    return results.trim().isNotEmpty;
  }

  static String _run(String option, List<String> targets,
      {bool quiet: false, int lineLength}) {
    var args = <String>[option];
    if (lineLength != null) args.add('--line-length=$lineLength');
    args.addAll(targets);
    return run(sdkBin('dartfmt'), quiet: quiet, arguments: args);
  }
}