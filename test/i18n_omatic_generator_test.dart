import 'dart:io';

import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:i18n_omatic/i18n_omatic_generator.dart';

void recreateDir(String dirPath) {
  final Directory dir = Directory(dirPath);

  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
  }

  dir.createSync(recursive: true);
}

void deployResources(String globExpr, String destPath) {
  final srcFiles = Glob(path.join("test/resources", globExpr)).listSync();

  for (var srcF in srcFiles) {
    final f = File(srcF.path);
    f.copySync(path.join(destPath, path.basename(srcF.path)));
  }
}

void main() {
  I18nOMaticGenerator testGen =
      I18nOMaticGenerator("test/_exec/lib", "test/_exec/assets/i18nomatic");

  setUpAll(() {
    recreateDir("test/_exec/lib");
    recreateDir("test/_exec/assets/i18nomatic");

    deployResources("**.dart", "test/_exec/lib");
    deployResources("**.yaml", "test/_exec/assets/i18nomatic");

    testGen.discoverTranslationsFiles();
    testGen.discoverSourcesFiles();
  });
  test('scan sources files', () {
    testGen.scanSourcesFiles();
    print(testGen.foundStrings);
    print(testGen.foundStrings.length);

    assert(testGen.foundStrings.length == 8);

    assert(testGen.foundStrings.contains("Single quotes"));
    assert(testGen.foundStrings.contains("Double quotes"));
    assert(testGen.foundStrings.contains('Double quotes in "single" quotes'));
    assert(testGen.foundStrings.contains("Single quotes in 'double' quotes"));
    assert(testGen.foundStrings.contains('Single quotes in \'single\' quotes'));
    assert(testGen.foundStrings.contains("Double quotes in \"double\" quotes"));
    assert(testGen.foundStrings.contains('Single hello %arg1 !'));
    assert(testGen.foundStrings.contains("Double hello %arg1 !"));

    assert(!testGen.foundStrings.contains("Ignored Double quotes"));
    assert(!testGen.foundStrings
        .contains("Ignored Single quotes in 'double' quotes"));
    assert(!testGen.foundStrings
        .contains("Ignored Single quotes in \"double\" quotes"));
  });

  test('update translations files', () {
    testGen.updateTranslationsFiles();
  });
}
