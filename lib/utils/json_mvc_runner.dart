import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'model_template.dart';

class JsonMVCRunner {
  String srcDir;
  String distDir;
  List<FileSystemEntity> list = [];

  JsonMVCRunner({
    this.srcDir,
    this.distDir,
  });

  void setup() {
    if (srcDir.endsWith('/')) srcDir = srcDir.substring(0, srcDir.length - 1);
    if (distDir.endsWith('/')) distDir = distDir.substring(0, distDir.length - 1);
  }

  bool run({command}) {
    // run
    // get all json files ./jsons
    list = getAllJsonFiles();

    if (!generateModelsDirectory()) return false;
    if (!iterateJsonFile()) return false;

    return true;
  }

  // all json files
  List<FileSystemEntity> getAllJsonFiles() {
    var src = Directory(srcDir);
    return src.listSync(recursive: true);
  }

  bool generateModelsDirectory() {
    if (list.isEmpty) return false;
    if (!Directory(distDir).existsSync()) {
      Directory(distDir).createSync(recursive: true);
    }
    return true;
  }

  // iterate json files
  bool iterateJsonFile() {
    var indexFile = '';
    list.forEach((f) {
      if (FileSystemEntity.isFileSync(f.path)) {
        var fileExtension = '.json';
        if (f.path.endsWith(fileExtension)) {
          var file = File(f.path);
          var dartPath = f.path.replaceFirst(srcDir, distDir).replaceFirst(
                fileExtension,
                '.dart',
                f.path.length - fileExtension.length - 1,
              );
          List basenameString = path.basename(f.path).split('.');
          String fileName = basenameString.first;
          Map jsonMap = json.decode(file.readAsStringSync());

          generateFileFromJson(dartPath, jsonMap, fileName);

          var relative = dartPath
              .replaceFirst(distDir + path.separator, '')
              .replaceAll(path.separator, '/');
          print('generated: $relative');
          indexFile += "export '$relative';\n";
        }
      }
    });
    return indexFile.isNotEmpty;
  }

  void warningIfImportNotExists(jsonModel, jsonFile) {
    jsonModel.imports_raw.forEach((importPath) {
      var parentPath =
          jsonFile.path.substring(0, jsonFile.path.lastIndexOf(path.separator));
      if (!File(path.join(parentPath, '$importPath.json')).existsSync()) {
        print(
            "[Warning] File '$importPath.json' not exist, import attempt on '${jsonFile.path}'");
      }
    });
  }

  // generate models from the json file
  void generateFileFromJson(outputPath, Map jsonMap, String fileName) {
    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsStringSync(
        defaultTemplate(jsonMap, fileName),
      );
  }
}
