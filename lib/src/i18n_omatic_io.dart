import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:i18n_omatic/src/i18n_omatic_data.dart';

/// Manages IO operations for storage of translations tables.
class I18nOMaticIO {
  static const _formatVersion = 1;
  static const _formatVersionKey = 'format_version';
  static const _stringsKey = 'strings';
  static const _unusedStringsKey = 'unused_strings';

  /// Builds the translations YAML file name
  /// for the given language code named [langCode] and country code named [ctryCode]
  static String buildFilename(String langCode, [String? ctryCode]) {
    var fileRoot = '$langCode';

    if (ctryCode != null && ctryCode.isNotEmpty) {
      fileRoot += '_$ctryCode';
    }

    return '$fileRoot.yaml';
  }

  // YAML format of translation files

  // version: 1  # the format version number

  // strings:  # strings and their translations, null if no translation yet
  //   "Hello World" : "Bonjour le Monde"
  //   "Follow the white rabbit!" : null

  // unused_strings: # strings already present in the translation file but not found in the source code
  //   "Please allow me to introduce myself" : "Veuillez me permettre de me présenter"
  static Map<String, String?> _extractTranslatedString(
      YamlMap data, String strKey) {
    var strings = <String, String?>{};

    if (data.containsKey(strKey) && data[strKey].runtimeType == YamlMap) {
      data[strKey].forEach((key, value) {
        if (key.runtimeType == String &&
            (value == null || value.runtimeType == String)) {
          strings[key] = value;
        }
      });
    }

    return strings;
  }

  static String _buildStringsPairs(
      String entryKey, Map<String, String?> values) {
    var strings = '';

    if (values.isNotEmpty) {
      strings += '$entryKey : \n';
      values.forEach((key, value) {
        var escapedKey = key;
        escapedKey = escapedKey.replaceAll("\\'", "'");
        escapedKey = escapedKey.replaceAll('\\\"', '\"');
        escapedKey = escapedKey.replaceAll('\"', '\\\"');

        // do not add quotes if value is null
        strings += (value == null)
            ? '  \"$escapedKey\" : null\n'
            : '  \"$escapedKey\" : \"$value\"\n';
      });
      strings += '\n';
    }
    return strings;
  }

  /// Loads a YAML file from the given [filePath]
  /// and returns an [I18nOMaticData]
  static I18nOMaticData loadFromFile(String filePath) {
    var i18nData = I18nOMaticData();

    var content = '';
    content = File(filePath).readAsStringSync();

    if (content.isNotEmpty) {
      var data = loadYaml(content);

      if (data != null) {
        if (data.containsKey(I18nOMaticIO._formatVersionKey) &&
            data[I18nOMaticIO._formatVersionKey] == _formatVersion) {
          i18nData.existingStrings =
              _extractTranslatedString(data, _stringsKey);
          i18nData.unusedStrings =
              _extractTranslatedString(data, _unusedStringsKey);
        }
      }
    }

    return i18nData;
  }

  /// Writes a YAML file to the given [filePath]
  /// containing the [I18nOMaticData] [data]
  static void writeToFile(String filePath, I18nOMaticData data) {
    var content = '';

    content += '# file updated using i18n_omatic\n';
    content += '\n';
    content += 'format_version : ${I18nOMaticIO._formatVersion}\n';
    content += '\n';
    content += _buildStringsPairs(_stringsKey, data.existingStrings);
    content += _buildStringsPairs(_unusedStringsKey, data.unusedStrings);

    File(filePath).writeAsStringSync(content);
  }

  /// Returns a [Map] of translated strings from a YAML formatted [content].
  ///
  /// The returned key-value map contains the translated strings (values)
  /// with the corresponding source strings (keys)
  static Map<String, String?>? getTranslatedStringsFromYamlContent(
      String content) {
    try {
      Map<String, String?>? data;

      if (content.isNotEmpty) {
        var yamlData = loadYaml(content);

        if (yamlData != null) {
          if (yamlData.containsKey(I18nOMaticIO._formatVersionKey) &&
              yamlData[I18nOMaticIO._formatVersionKey] == _formatVersion) {
            data = _extractTranslatedString(yamlData, _stringsKey);
          }
        }
      }
      return data;
    } catch (e) {
      return null;
    }
  }
}
