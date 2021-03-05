/// The i18n_omatic library makes translations easier in Flutter apps.
/// It is associated to a provided command line tool to search for
/// translatable strings in the source code and builds translation tables.
///
/// See the i18n_omatic package documentation and provided example.

library i18n_omatic;

export 'src/i18n_omatic_data.dart';
export 'src/i18n_omatic_io.dart';

import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:i18n_omatic/src/i18n_omatic_io.dart';

/// Manages the automatic translation of strings in Flutter apps.
class I18nOMatic {
  Map<String, String?>? _localizedStrings;

  /// The current locale set on initialization
  Locale? locale;

  /// The instance created on initialization.
  static late I18nOMatic instance;

  I18nOMatic(this.locale);

  I18nOMatic._init(Locale locale) {
    instance = this;
    this.locale = locale;
  }

  /// The localization delegate to use in Flutter [WidgetsApps]
  static const LocalizationsDelegate<I18nOMatic> delegate =
      _I18nOMaticDelegate();

  static I18nOMatic? of(BuildContext context) {
    return Localizations.of<I18nOMatic>(context, I18nOMatic);
  }

  Future<void> load() async {
    try {
      var filePath = 'assets/i18nomatic/' +
          I18nOMaticIO.buildFilename(
              locale!.languageCode + '_' + locale!.countryCode!);
      var content = await rootBundle.loadString(filePath);

      _localizedStrings =
          I18nOMaticIO.getTranslatedStringsFromYamlContent(content);
    } catch (e) {
      // ignored
    }
  }

  /// See [I18nOMaticExt.tr()] for description.
  String tr(String strToTranslate, [Map<String, dynamic>? args]) {
    var strTranslated = strToTranslate;

    if (_localizedStrings != null &&
        _localizedStrings!.containsKey(strToTranslate)) {
      var foundStr = _localizedStrings![strToTranslate];
      if (foundStr != null) {
        // TODO to refactor for a better implementation
        strTranslated = foundStr;
      }
    }

    if (args == null || args.isEmpty) {
      return strTranslated;
    }

    args.forEach((key, value) {
      value ??= '';
      strTranslated = strTranslated.replaceAll('%$key', value.toString());
    });

    return strTranslated;
  }
}

/// The delegate class for [I18nOMatic]
class _I18nOMaticDelegate extends LocalizationsDelegate<I18nOMatic> {
  const _I18nOMaticDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<I18nOMatic> load(Locale locale) async {
    var localizations = I18nOMatic._init(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_I18nOMaticDelegate old) => false;
}

/// Extension to make translatable strings easily readable in source code.
extension I18nOMaticExt on String {
  /// Dynamically replaces the source string by the corresponding translated string
  /// in the current language if available.
  ///
  /// if the [args] [Map] si provided, the placeholders beginning with the % character
  /// and named by a key of the map are replaced by the corresponding value in the map.
  /// ```dart
  /// String birthdayMsg = 'Happy birthday %name, you are %age years old'.tr({name: 'Peter', age: '21'});
  /// // untranslated string value : 'Happy birthday Peter, you are 21 years old'
  /// // french string value : 'Bon anniversaire Peter, tu as 21 ans'
  /// ```
  String tr([Map<String, dynamic>? args]) => I18nOMatic.instance.tr(this, args);
}
