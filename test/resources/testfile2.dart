import 'package:i18n_omatic/i18n_omatic.dart';

void main() {
  String testSingle = 'Single hello %arg1 !'.tr({"arg1": "world"});
  String testDouble = "Double hello %arg1 !".tr({"arg1": "world"});

  String testSingleMulti = '''%nbr1
multiplied by
%nbr2
equals %result
'''
      .tr({"term1": 6, "term2": 7, "result": (6 * 7)});

  String testDoubleMulti = """
6 + 11
=
17"""
      .tr({"unusedarg": "none", "fakearg": 0});

  print(testSingle);
  print(testDouble);
  print(testSingleMulti);
  print(testDoubleMulti);
}
