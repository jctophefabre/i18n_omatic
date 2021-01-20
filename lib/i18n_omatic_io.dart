import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:i18n_omatic/i18n_omatic_data.dart';

class I18nOMaticIO {
  static const formatVersion = 1;
  static const formatVersionKey = "format_version";
  static const stringsKey = "strings";
  static const unusedStringsKey = "unused_strings";

  static buildFilename(String langCode, [String ctryCode]) {
    String fileRoot = "$langCode";

    if (ctryCode != null && ctryCode.isNotEmpty) {
      fileRoot += "_$ctryCode";
    }

    return "$fileRoot.yaml";
  }

  /*
    YAML format of translation files

    version: 1  # the format version number

    strings:  # strings and their translations, null if no translation yet
      "Hello World" : "Bonjour le Monde"
      "Follow the white rabbit!" : null 

    unused_strings: # strings already present in the translation file but not found in the source code
      "Please allow me to introduce myself" : "Veuillez me permettre de me présenter"
    */

  static Map<String, String> _extractTranslatedString(
      YamlMap data, String strKey) {
    Map<String, String> strings = Map<String, String>();

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
      String entryKey, Map<String, String> values) {
    String strings = "";

    if (values.isNotEmpty) {
      strings += "$entryKey : \n";
      values.forEach((key, value) {
        String escapedKey = key;
        escapedKey = escapedKey.replaceAll("\\'", "'");
        escapedKey = escapedKey.replaceAll("\\\"", "\"");
        escapedKey = escapedKey.replaceAll("\"", "\\\"");

        // do not add quotes if value is null
        strings += (value == null)
            ? "  \"$escapedKey\" : null\n"
            : "  \"$escapedKey\" : \"$value\"\n";
      });
      strings += "\n";
    }
    return strings;
  }

  static I18nOMaticData loadFromFile(String filePath) {
    I18nOMaticData i18nData = I18nOMaticData();

    String content = "";
    content = File(filePath).readAsStringSync();

    if (content.isNotEmpty) {
      var data = loadYaml(content);

      if (data != null) {
        if (data.containsKey(I18nOMaticIO.formatVersionKey) &&
            data[I18nOMaticIO.formatVersionKey] == formatVersion) {
          i18nData.existingStrings = _extractTranslatedString(data, stringsKey);
          i18nData.unusedStrings =
              _extractTranslatedString(data, unusedStringsKey);
        }
      }
    }

    return i18nData;
  }

  static void writeToFile(String filePath, I18nOMaticData data) {
    String content = "";

    content += "# file updated using i18n_omatic\n";
    content += "\n";
    content += "format_version : ${I18nOMaticIO.formatVersion}\n";
    content += "\n";
    content += _buildStringsPairs(stringsKey, data.existingStrings);
    content += _buildStringsPairs(unusedStringsKey, data.unusedStrings);

    File(filePath).writeAsStringSync(content);
  }

  static Map<String, String> getTranslatedStringsFromYamlContent(
      String content) {
    try {
      Map<String, String> data;

      if (content != null && content.isNotEmpty) {
        var yamlData = loadYaml(content);

        if (yamlData != null) {
          if (yamlData.containsKey(I18nOMaticIO.formatVersionKey) &&
              yamlData[I18nOMaticIO.formatVersionKey] == formatVersion) {
            data = _extractTranslatedString(yamlData, stringsKey);
          }
        }
      }
      return data;
    } catch (e) {
      return null;
    }
  }
}
