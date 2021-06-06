import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:json_mvc/utils/Info.dart';

StringBuffer getImports(List<Info> infos) {
  final importsBuffer = StringBuffer();

  importsBuffer.writeAll([
    "import 'package:eatwell/Models/Info.dart';",
    "import 'package:json_annotation/json_annotation.dart';",
    "import 'package:flutter/material.dart';",
    "import 'package:jiffy/jiffy.dart';",
    "import 'package:uuid/uuid.dart';",
    "import 'package:flutter_helper/flutter_helper.dart';",
    "import 'package:intl/intl.dart';",
    "import 'dart:collection';"
  ]);

  importsBuffer.writeAll({for (final info in infos) () {
    if (info.hasView) {
      return  "import 'package:eatwell/Blocs/${info.blocType}.dart';";
    } else {
      return '';
    }
  }()});

  importsBuffer.writeAll({for (final info in infos) () {
    if (info.hasView) {
      return "import 'package:eatwell/Comps/${info.compType}.dart';";
    } else {
      return '';
    }
  }()});

  importsBuffer.writeAll({for (final info in infos) () {
    final Glob glob = Glob('/Users/michalkubizna/Desktop/eat_well/lib/**/${info.type}.dart');

    String import;

    if (glob.listSync().isNotEmpty) {
      import = "import 'package:eatwell/${glob.listSync().first.path.replaceAll('/Users/michalkubizna/Desktop/eat_well/lib/', '')}';";
    } else {
      import = '';
    }

    return import;
  }()});

  return importsBuffer;
}