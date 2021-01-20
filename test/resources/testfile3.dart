void main() {
  String testSingle = 'Ignored Single quotes';
  String testDouble = "Ignored Double quotes";

  String testSingleDouble = 'Ignored Double quotes in "single" quotes';
  String testDoubleSingle = "Ignored Single quotes in 'double' quotes";

  String testSingleEscaped = 'Ignored Double quotes in \'single\‘ quotes';
  String testDoubleEscaped = "Ignored Single quotes in \"double\" quotes";

  String testSingleMulti = '''Ignored A
multiline
string''';

  String testDoubleMulti = """
Ignored 
Another
multiline
string""";

  print(testSingle);
  print(testDouble);
  print(testSingleDouble);
  print(testDoubleSingle);
  print(testSingleEscaped);
  print(testDoubleEscaped);
  print(testSingleMulti);
  print(testDoubleMulti);
}
