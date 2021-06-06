import 'package:json_mvc/utils/Info.dart';

StringBuffer getLazyTitles(List<Info> infos) {
  final infoBuffer = StringBuffer();

  infoBuffer.writeAll({for (final info in infos) '${info.camel}Title = ${info.title};'});

  return infoBuffer;
}

StringBuffer getLazyBlocs(List<Info> infos) {
  final infoBuffer = StringBuffer();

  infoBuffer.writeAll({for (final info in infos) () {
    if (info.hasView) {
      final value = info.hasValue ? '..data = ${info.value}' : '';
      return '${info.camel}Bloc = ${info.blocType}(info: Info(title: ${info.camel}Title, values: ${info.camel}Values))$value;';
    } else {
      return '';
    }
  }()});

  return infoBuffer;
}

StringBuffer getLazyInfos(List<Info> infos) {
  final infoBuffer = StringBuffer();

  infoBuffer.write('infos = [');

  infoBuffer.writeAll({for (final info in infos) () {
    final base = 'title: ${info
        .camel}Title, values: ${info.camel}Values, snake: ${info.camel}Snake';

    String text;

    if (info.hasView) {
      text = 'Info(controller: ${info.bloc}, buildView: ${info
          .comp}, $base),';
    } else {
      text = 'Info($base),';
    }

    return text;
  }()});

  infoBuffer.write('];');

  return infoBuffer;
}

StringBuffer getConstructor(String className, List<StringBuffer> buffers) {
  final infoBuffer = StringBuffer();

  infoBuffer.writeln('$className() {');
  for (final buffer in buffers) {
    infoBuffer.writeln(buffer);
  }
  infoBuffer.writeln('}');

  return infoBuffer;
}