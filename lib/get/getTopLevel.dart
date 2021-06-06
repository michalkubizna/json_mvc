import 'package:json_mvc/utils/Info.dart';

StringBuffer getCamels(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) () {
    if (info.hasView) {
      return ''
          '${info.type} get ${info.camel} => ${info.camel}Bloc?.data;'
          'set ${info.camel}(${info.type} data) => ${info.camel}Bloc?.data = data;'
          '';
    } else {
      String text;

      if (info.hasToJsonValue) {
        text = '${info.type} ${info.camel};';
      } else {
        text = '${info.type} ${info.camel} = ${info.value};';
      }

      return '$text \n';
    }
  }()});
}

StringBuffer getComps(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) () {
    if (info.hasView) {
      return '${info.compType} ${info.comp}([Info info]) => ${info.compType}(info: Info(controller: ${info.bloc}, title: ${info.camel}Title, values: ${info.camel}Values).copyWith(info));';
    } else {
      return '';
    }
  }()});
}

StringBuffer getBlocs(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) () {
    if (info.hasView) {
      return '${info.blocType} ${info.bloc};';
    } else {
      return '';
    }
  }()});
}

StringBuffer getTitles(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) 'dynamic ${info.camel}Title;'});
}

StringBuffer getSnakes(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) 'final String ${info.camel}Snake = ${info.snake};'});
}

StringBuffer getValues(List<Info> infos) {
  return StringBuffer()..writeAll({for (final info in infos) 'final dynamic ${info.camel}Values = ${info.values};'});
}