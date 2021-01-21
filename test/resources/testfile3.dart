void main() {
  var testSingle = 'Ignored Single quotes';
  // ignore: prefer_single_quotes
  var testDouble = "Ignored Double quotes";

  var testSingleDouble = 'Ignored Double quotes in "single" quotes';
  var testDoubleSingle = "Ignored Single quotes in 'double' quotes";

  var testSingleEscaped = 'Ignored Double quotes in \"single\" quotes';
  var testDoubleEscaped = "Ignored Single quotes in \'double\' quotes";

  var testSingleMulti = '''Ignored A
multiline
string''';

  // ignore: prefer_single_quotes
  var testDoubleMulti = """
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
