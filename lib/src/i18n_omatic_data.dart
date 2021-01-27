/// Manages the data structure for translation operations.
class I18nOMaticData {
  /// A [Map] of strings that have been found in the source code
  /// with the corresponding translation if available (null otherwise)
  Map<String, String> existingStrings = <String, String>{};

  /// A [Map] of strings that have not been found in the source code
  /// with the corresponding translation if available (null otherwise)
  Map<String, String> unusedStrings = <String, String>{};
}
