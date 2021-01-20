library i18n_omatic;

import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:i18n_omatic/i18n_omatic_io.dart';

class I18nOMatic {
  I18nOMatic(this.locale);

  static I18nOMatic of(BuildContext context) {
    return Localizations.of<I18nOMatic>(context, I18nOMatic);
  }

  static I18nOMatic instance;

  I18nOMatic._init(Locale locale) {
    instance = this;
    this.locale = locale;
  }

  static const LocalizationsDelegate<I18nOMatic> delegate =
      _I18nOMaticDelegate();

  Locale locale;
  Map<String, String> _localizedStrings;

  Future<void> load() async {
    try {
      String filePath = "assets/i18nomatic/" +
          I18nOMaticIO.buildFilename(
              locale.languageCode + "_" + locale.countryCode);
      String content = await rootBundle.loadString(filePath);

      _localizedStrings =
          I18nOMaticIO.getTranslatedStringsFromYamlContent(content);
    } catch (e) {}
  }

  String tr(String strToTranslate, [Map<String, dynamic> args]) {
    String strTranslated = strToTranslate;

    if (_localizedStrings != null &&
        _localizedStrings.containsKey(strToTranslate)) {
      String foundStr = _localizedStrings[strToTranslate];
      if (foundStr != null) {
        // TODO to refactor for a better implementation
        strTranslated = foundStr;
      }
    }

    if (args == null || args.length == 0) {
      return strTranslated;
    }

    args.forEach((key, value) {
      if (value == null) {
        value = "";
      }
      strTranslated = strTranslated.replaceAll("%$key", value.toString());
    });

    return strTranslated;
  }
}

class _I18nOMaticDelegate extends LocalizationsDelegate<I18nOMatic> {
  const _I18nOMaticDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<I18nOMatic> load(Locale locale) async {
    I18nOMatic localizations = I18nOMatic._init(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_I18nOMaticDelegate old) => false;
}

extension I18nOMatricExt on String {
  String tr([Map<String, dynamic> args]) => I18nOMatic.instance.tr(this, args);
}
