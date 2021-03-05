import 'package:i18n_omatic/i18n_omatic.dart';

void main() {
  var testSingle = I18nOMatic.instance.tr('Single quotes');
  // ignore: prefer_single_quotes
  var testDouble = I18nOMatic.instance.tr("Double quotes");

  var testSingleDouble = 'Double quotes in "single" quotes'.tr();
  var testDoubleSingle = "Single quotes in 'double' quotes".tr();

  var testSingleEscaped = 'Single quotes in \'single\' quotes'.tr();
  // ignore: prefer_single_quotes
  var testDoubleEscaped = "Double quotes in \"double\" quotes".tr();

  var testSingleMulti = '''A
multiline
string'''
      .tr();

  // ignore: prefer_single_quotes
  var testDoubleMulti = I18nOMatic.instance.tr("""
Another
multiline
string""");

  print(testSingle);
  print(testDouble);
  print(testSingleDouble);
  print(testDoubleSingle);
  print(testSingleEscaped);
  print(testDoubleEscaped);
  print(testSingleMulti);
  print(testDoubleMulti);
}
