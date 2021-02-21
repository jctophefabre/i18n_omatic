# i18n-o-matic

[![Pub Version](https://img.shields.io/pub/v/i18n_omatic?color=blue)](https://pub.dev/packages/i18n_omatic) 
[![CI](https://github.com/jctophefabre/i18n_omatic/workflows/CI/badge.svg)](https://github.com/jctophefabre/i18n_omatic/actions/workflows/ci.yml)

i18n-o-matic is a dart package to make translations easier in Flutter apps. 
It provides the ability to automatically search for translatable strings in the source code and builds translations tables for each language.
This approach is inspired by the one used in the [Qt framework](https://doc.qt.io/qt-5/internationalization.html).

* :beach_umbrella:  Painless translation workflow
* :mag_right:  Automatic discovery of translatable strings
* :woman_technologist:  Human readable YAML format for translations files
* :hash:  Formatable strings for variable substitutions



Contributions to this package are welcome :tada::+1:, see the [CONTRIBUTING Guidelines](https://github.com/jctophefabre/i18n_omatic/blob/master/CONTRIBUTING.md) for more information. 


## How it works

i18n-o-matic uses original strings marked as translatable in the source code and use them as as translation keys. 
The `I18nOMatic` class replaces each translatable string by the corresponding string of the current language. 
It is advisable to use English as the reference language of the strings to be translated in the application.

First of all, each source file with translatable strings must import the `i18n_omatic` package:
```dart
import 'package:i18n_omatic/i18n_omatic.dart'; 
```

### Mark strings as translatable

To mark a string as translatable, it must be applied the `tr()` method provided by `i18n_omatic`:
```dart
String firstString = 'My first string'.tr();
// ...
Text('Share on network'.tr());
```

When parts of the translatable string are based on external values (aka string interpolation), placeholders in the string can be used with a provided key-value table. These placeholders begins with a `%` character and must be named with the corresponding key in the table:

```dart
String birthdayMsg = 'Happy birthday %name, you are %age years old'.tr({name: 'Peter', age: '21'});
```

### Prepare configuration for translations

Once the strings to translate are marked, you have to create an empty YAML file for each language you want to translate strings into and name it with the "language_country" code (e.g. fr_FR.yaml for France, es_ES.yaml for Spain, ...). For Flutter applications, these files must be located in the `assets/i18nomatic` directory and added in the corresponding section in the pubspec.yaml configuration file.

Example below is the pubspec.yaml section for french and spanish languages, once the files have been effectively created:
```yaml
flutter:
  assets:
    - assets/
    - assets/i18nomatic/es_ES.yaml
    - assets/i18nomatic/fr_FR.yaml
```

For iOS, the file `ios/Runner/info.plist` must be updated to register the supported locales. 
The `CFBundleLocalizations` must be added or updated with an array of the supported languages. The example below is an example for french and spanish languages:
```xml
<key>CFBundleLocalizations</key>
<array>
    <string>es_ES</string>
    <string>fr_FR</string>
</array>
```

### Automatically build translation tables

The `i18n_omatic` package provides a command line tool that will scan the source code of the application and search for the translatable strings. Then, it will update the translation files with the found strings.
The following command line has to be run in the root directory of the project:
```
dart pub run i18n_omatic:update
```
By default, this command line tool wil scan the `lib` directory recursively, looking for `.dart` files, and will update the translations files located in the `assets/i18nomatic` directory.  

You can run this tool whenever needed to update the translation tables 
with the newly translatable strings introduced in your source code. The previously translated string will remain in the translation files.


### Enable translations in application

You have to enable the i18n_omatic localization delegate and add the supported locales in your application definition class.
Do not forget to add the locale of the translatable strings in your source code, as it can be considered as the default application language (usually en/US).

```dart
MaterialApp(
    // ...
    localizationsDelegates: [
      I18nOMatic.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', 'US'),
      const Locale('fr', 'FR'),
      const Locale('es', 'ES'), 
    ],
```
Once this is done, every string with the `.tr()` method will be translated if it is available in the target language.


### Edit translation files

Given the following part of ource code:
```dart
String firstString = 'My first string'.tr();
// ...
Text('Share on network'.tr());
// ...
String birthdayMsg = 'Happy birthday %name, you are %age years old'.tr({name: 'Peter', age: '21'});
// ...
String ingnoredString = 'ignored string';
````
At the first run of the `i18n_omatic:update` command line tool, 
the following file will be generated for the french language (`assets/i18nomatic/fr_FR.yaml`):
```yaml
format_version: 1

strings:
  "My first string" : null
  "Share on network" : null
  "Happy birthday %name, you are %age years old" : null
```
The 3 collected strings are now available for translation but are null by default. You have to edit the file and provide correct translations as follow (example for french):
```yaml
format_version: 1

strings:
  "My first string" : "Ma première chaîne de caractères"
  "Share on network" : "Partager sur le réseau"
  "Happy birthday %name, you are %age years old" : "Bon anniversaire %name, tu as %age ans"
```

If you remove one or more translatable string (e.g. `firstString` in the example above) in a further development 
and run again the `i18n_omatic:update` command line tool, 
these translated strings will not be lost and will be placed in a `unused_strings` category:
```yaml
format_version: 1

strings:
  "Share on network" : "Partager sur le réseau"
  "Happy birthday %name, you are %age years old" : "Bon anniversaire %name, tu as %age ans"

unused_strings:
  "My first string" : "Ma première chaîne de caractères"
```
Once you are sure you will not use these strings anaymore, you can remove them from the yaml files. 
You are encouraged to clean up these files before releasing a new version of your application.

## How to test a Widget which uses i18n_omatic

 You can use the [Mockito package](https://pub.dev/packages/mockito) to mock the translation of the `tr()` function :

 ```dart
import 'package:i18n_omatic/i18n_omatic.dart';
import 'package:mockito/mockito.dart';

class MockI18nOMatic extends Mock implements I18nOMatic {}

class MockSetUp {
  static void mockI18nOMatic() {
    I18nOMatic.instance = MockI18nOMatic();
    when(I18nOMatic.instance.tr(any, any)).thenAnswer((realInvocation) {
      var strTranslated = realInvocation.positionalArguments[0].toString();
      if (realInvocation.positionalArguments[1] != null) {
        realInvocation.positionalArguments[1].forEach((String key, String value) {
          value ??= '';
          strTranslated = strTranslated.replaceAll('%$key', value.toString());
        });
      }
      return strTranslated;
    });
  }
}
```
and call `MockSetUp.mockI18nOMatic()` at the beginning of the Flutter widget test  :
```dart
void main() {
  setUp(()  {
    MockSetUp.mockI18nOMatic();
  });
  [...]
```

## Known limitations

Currently, `i18n_omatic` does not support
* multiline strings
* left-to-right languages such as Arabic or Hebrew
* automatic management of plural forms


## Author

The i18n-o-matic package is developped by [Jean-Christophe Fabre](https://github.com/jctophefabre).

Contributors:

* [Aurélien Joubert](https://github.com/Jouby) 💻 📖
