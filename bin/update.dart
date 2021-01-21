import 'package:args/args.dart';

import 'package:i18n_omatic/i18n_omatic_generator.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser
    ..addOption('src-dir', defaultsTo: 'lib')
    ..addOption('out-dir', defaultsTo: 'assets/i18nomatic');
  var parsedArgs = parser.parse(args);

  var gen = I18nOMaticGenerator(parsedArgs['src-dir'], parsedArgs['out-dir']);

  gen.run();
}
