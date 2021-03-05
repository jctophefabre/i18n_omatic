import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart'; // TODO import to remove
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'package:i18n_omatic/src/i18n_omatic_data.dart';
import 'package:i18n_omatic/src/i18n_omatic_io.dart';

class I18nOMaticGenerator {
  String _srcDir = '';

  String _outDir = '';

  final List<String> _srcFiles = <String>[];

  final List<String> _foundStrings = <String>[];

  final Map<String, String> _translationsFiles = <String, String>{};

  I18nOMaticGenerator(String srcDir, String outDir) {
    _srcDir = srcDir;
    _outDir = outDir;
  }

  List<String> get foundStrings {
    return _foundStrings;
  }

  void _scanSourceFile(String fileName) {
    print('$fileName');

    try {
      final file = File(fileName);
      var contents = file.readAsStringSync();

      var rules = <RegExp>[
        RegExp(r"\.tr\s*\(\s*'(.*?(?<!\\))'"), // TODO to remove
        RegExp(r'\.tr\s*\(\s*"(.*?(?<!\\))"'), // TODO to remove
        RegExp(r"'(.*?(?<!\\))'\s*\.tr\s*\("),
        RegExp(r'"(.*?(?<!\\))"\s*\.tr\s*\('),
      ];

      rules.forEach((rule) {
        Iterable<Match> matches = rule.allMatches(contents);
        matches.forEach((match) {
          if (match.groupCount >= 1 && match.group(1).isNotEmpty) {
            var currentStr = match.group(1);
            // exclude """ and ''' that are not correctly handled yet
            if (currentStr != "'" && currentStr != '"') {
              // replace escape chars associated to quotes
              currentStr =
                  currentStr.replaceAll('\\\"', '\"').replaceAll('\\\'', '\'');
              _foundStrings.add(currentStr);
            }
          }
        });
      });
    } catch (e) {
      print('Error reading file $fileName. Skipped.');
    }
  }

  void addSourceFile(String filePath) {
    _srcFiles.add(filePath);
  }

  void addLang(String langCode, String filePath) {
    _translationsFiles[langCode] = filePath;
  }

  void _updateTranslationFile(String langCode) {
    print('### Updating translation for $langCode');

    I18nOMaticData i18nData;

    // Create emptyfile
    if (!File(_translationsFiles[langCode]).existsSync()) {
      print('Creating empty translation file');
      File(_translationsFiles[langCode]).createSync(recursive: true);
      i18nData = I18nOMaticData();
    } else {
      print('Loading existing translated strings');

      try {
        i18nData = I18nOMaticIO.loadFromFile(_translationsFiles[langCode]);
      } catch (e) {
        print('Unable to load translations for $langCode.');
      }
    }

    print('Processing strings');
    // move unused to existing if present in found strings
    var unusedKeys = List<String>.from(i18nData.unusedStrings.keys);
    unusedKeys.forEach((value) {
      if (_foundStrings.contains(value) &&
          !i18nData.existingStrings.containsKey(value)) {
        i18nData.existingStrings[value] = i18nData.unusedStrings[value];
        i18nData.unusedStrings.remove(value);
      }
    });

    // move existing to unused if not present in found strings
    var existingKeys = List<String>.from(i18nData.existingStrings.keys);
    existingKeys.forEach((value) {
      if (!_foundStrings.contains(value) &&
          !i18nData.unusedStrings.containsKey(value)) {
        i18nData.unusedStrings[value] = i18nData.existingStrings[value];
        i18nData.existingStrings.remove(value);
      }
    });

    // add found to existing with null value if not present in existing
    _foundStrings.forEach((value) {
      if (!i18nData.existingStrings.containsKey(value)) {
        i18nData.existingStrings[value] = null;
      }
    });

    print(
        'Writing ${i18nData.existingStrings.length} existing strings and ${i18nData.unusedStrings.length} unused strings in translations file');
    try {
      I18nOMaticIO.writeToFile(_translationsFiles[langCode], i18nData);
    } catch (e) {
      print('Unable to write translations for $langCode.');
    }
  }

  void scanSourcesFiles() {
    print('### Scanning source files');

    for (var file in _srcFiles) {
      _scanSourceFile(file);
    }
  }

  void discoverSourcesFiles() {
    final filesToScan = Glob(path.join(_srcDir, '**.dart')).listSync();

    for (var f in filesToScan) {
      addSourceFile(f.path);
    }
  }

  void discoverTranslationsFiles() {
    // discover files from flutter/assets section in app pubspec file
    final pubspecPath = path.join(Directory.current.path, 'pubspec.yaml');
    final pubspecFile = File(pubspecPath);

    if (pubspecFile.existsSync()) {
      try {
        var content = pubspecFile.readAsStringSync();
        var pattern = RegExp(r'assets\/i18nomatic\/([a-z]{2}_[A-Z]{2})\.yaml');

        if (content.isNotEmpty) {
          var data = loadYaml(content);

          if (data != null) {
            if (data.containsKey('flutter') &&
                data['flutter'].containsKey('assets')) {
              var assets = data['flutter']['assets'];
              if (assets.runtimeType == YamlList) {
                assets.forEach((value) {
                  var match = pattern.firstMatch(value);

                  if (match != null &&
                      match.groupCount >= 1 &&
                      match.group(1).isNotEmpty) {
                    addLang(match.group(1), value);
                  }
                });
              }
            }
          }
        }
      } catch (e) {
        print('Unable to read assets from pubspec.yaml / ${e.toString()}');
      }
    }

    // discover existing files
    try {
      final filesToScan =
          Glob(path.join(_outDir, I18nOMaticIO.buildFilename('*'))).listSync();
      for (var f in filesToScan) {
        var langCode = path.basenameWithoutExtension(f.path);
        addLang(langCode, f.path);
      }
    } catch (e) {
      print(
          'Unable to access to existing translations files / ${e.toString()}');
    }
  }

  void updateTranslationsFiles() {
    _translationsFiles.forEach((key, value) {
      _updateTranslationFile(key);
    });
  }

  void run() {
    discoverSourcesFiles();
    discoverTranslationsFiles();

    if (_translationsFiles.isNotEmpty) {
      scanSourcesFiles();
      updateTranslationsFiles();
    }
  }
}
