import 'package:json_mvc/utils/Info.dart';

StringBuffer getStringBuffer(List<Info> infos, String Function(Info) getInfo, {bool writeLn = true}) {
  final Set<String> strings = <String>{};

  for (final info in infos) {
    strings.add(getInfo(info));
  }

  final stringBuffer = StringBuffer();

  for (final string in strings) {
    if (writeLn) {
      stringBuffer.writeln(string);
    } else {
      stringBuffer.write(string);
    }
  }

  return stringBuffer;
}
