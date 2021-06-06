import 'dart:io';
import 'package:glob/glob.dart';
import 'package:args/args.dart';
import 'package:glob/list_local_fs.dart';
import 'package:json_mvc/utils/json_mvc_runner.dart';

void main(List<String> arguments) {
  var argParser = ArgParser();

  argParser.parse(arguments);

  final String root = "/Users/michalkubizna/Desktop/eat_well/lib";

  final dartFile = Glob('$root/**/*.json');

  for (final FileSystemEntity fileSystemEntity in dartFile.listSync()) {
    final String path = fileSystemEntity.parent.parent.path;

    final srcDir = path + "/Jsons";

    final distDir = path + "/Models";

    var runner =
    JsonMVCRunner(srcDir: srcDir, distDir: distDir);
    runner.setup();

    print('Start generating');

    runner.run();
  }
}
