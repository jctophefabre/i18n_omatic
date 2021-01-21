import 'package:i18n_omatic/i18n_omatic.dart';

void main() {
  var testSingle = 'Single hello %arg1 !'.tr({'arg1': 'world'});
  // ignore: prefer_single_quotes
  var testDouble = "Double hello %arg1 !".tr({"arg1": "world"});

  var testSingleMulti = '''%nbr1
multiplied by
%nbr2
equals %result
'''
      .tr({'term1': 6, 'term2': 7, 'result': (6 * 7)});

  // ignore: prefer_single_quotes
  var testDoubleMulti = """
6 + 11
=
17"""
      .tr({'unusedarg': 'none', 'fakearg': 0});

  print(testSingle);
  print(testDouble);
  print(testSingleMulti);
  print(testDoubleMulti);
}
