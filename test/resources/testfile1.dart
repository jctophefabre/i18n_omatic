import 'package:i18n_omatic/i18n_omatic.dart';

void main() {
  String testSingle = I18nOMatic.of(null).tr('Single quotes');
  String testDouble = I18nOMatic.instance.tr("Double quotes");

  String testSingleDouble = 'Double quotes in "single" quotes'.tr();
  String testDoubleSingle = "Single quotes in 'double' quotes".tr();

  String testSingleEscaped = 'Single quotes in \'single\' quotes'.tr();
  String testDoubleEscaped = "Double quotes in \"double\" quotes".tr();

  String testSingleMulti = '''A
multiline
string'''
      .tr();

  String testDoubleMulti = I18nOMatic.of(null).tr("""
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
