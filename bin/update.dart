import 'package:args/args.dart';

import 'package:i18n_omatic/src/i18n_omatic_generator.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser
    ..addOption(
      'src-dir',
      defaultsTo: 'lib',
      help: 'path to sources directory',
    )
    ..addOption(
      'out-dir',
      defaultsTo: 'assets/i18nomatic',
      help: 'path to translations files directory',
    )
    ..addFlag(
      'help',
      negatable: false,
      help: 'displays this help message',
    );

  var parsedArgs;
  try {
    parsedArgs = parser.parse(args);
  } on ArgParserException catch (e) {
    print(e.message);
    print('');
    print('Usage:');
    print(parser.usage);
  }

  if (parsedArgs != null) {
    if (parsedArgs['help']) {
      print(parser.usage);
    } else {
      var gen =
          I18nOMaticGenerator(parsedArgs['src-dir'], parsedArgs['out-dir']);
      gen.run();
    }
  }
}
