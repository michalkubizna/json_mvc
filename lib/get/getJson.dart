import 'package:json_mvc/utils/Info.dart';
import 'getExtractValues.dart';
import 'getStringBuffer.dart';

final List<String> _commonTypes = ["int", "double", "String", "bool"];

getFromJson(String className, List<Info> infos) {
  return '''
    factory ${className}.fromJson(Map<String, dynamic> json) {
      final object = ${className}();
    
      return object
${getStringBuffer(infos, (info) {
    if (info.hasFromJsonValue) {
      return '..${info.camel} = ${info.fromJsonValue}';
    } else {
      String json;

      if (info.spread) {
        json = 'json';
      } else {
        json = 'json[${info.snake}]';
      }

      return '..${info.camel} = ${getFromJsonValue(info, info.type, "$json")}';
    }
  })};
    }
  ''';
}

getToJson(List<Info> infos) {
  return '''
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
  ${getStringBuffer(infos, (Info info) {
    if (!info.ignore) {
      if (info.hasView) {
        if (info.hasToJsonValue) {
          return '${info.snake}: this.${info.bloc}.text != "" ? ${getToJsonValue(info, info.type, "this.${info.camel}")} : ${info.toJsonValue},';
        } else {
          return '${info.snake}: ${getToJsonValue(info, info.type, "this.${info.camel}")},';
        }
      } else {
        if (info.hasToJsonValue) {
          return '${info.snake}: ${info.toJsonValue},';
        } else {
          String spread;

          if (info.spread) {
            spread = '...';
          } else {
            spread = '${info.snake}: ';
          }

          return '$spread${getToJsonValue(info, info.type, "this.${info.camel}")},';
        }
      }
    } else {
      return '';
    }
  })}
  };
  }
  ''';
}

String getFromJsonValue(Info info, String type, String field) {
  return _getJson(info, type, field, true);
}

String getToJsonValue(Info info, String type, String field) {
  return _getJson(info, type, field, false);
}

String _getJson(Info info, String type, String field, bool isFromJson) {
  var cast = field;

  if (type.startsWith("String")) {
    cast = "$field?.toString() ?? ''";
  } else if (type.startsWith("double")) {
    cast = "$field?.toDouble() ?? 0.0";
  } else if (type.startsWith("int")) {
    cast = "$field?.toInt() ?? 0";
  } else if (type.startsWith("bool")) {
    cast = "$field ?? false";
  } else if (type.startsWith("DateTime")) {
    cast = isFromJson
        ? "DateTime.fromMillisecondsSinceEpoch($field?.toInt() ?? DateTime.now().millisecondsSinceEpoch)"
        : "$field.millisecondsSinceEpoch";
  } else if (type.startsWith("List<")) {
    final list = getExtractValues(type);

    final loop =
        "[for (final e in $field ?? []) ${isFromJson ? getFromJsonValue(info, list.last, "e") : getToJsonValue(info, list.last, "e")}]";

    cast = loop;
  } else if (type.startsWith("Set<")) {
    final list = getExtractValues(type);

    final loop =
        "{for (final e in $field ?? {}) ${isFromJson ? getFromJsonValue(info, list.last, "e") : getToJsonValue(info, list.last, "e")}}";

    cast = loop;
  } else if (type.startsWith("Map<")) {
    final list = getExtractValues(type);

    final firstType = list.first == "int" || list.first == "double"
        ? "${list.first}.parse(key)"
        : "entry.key";
    final secondType = list.last;

    final loop =
        "Map.fromEntries([for (final entry in (SplayTreeMap.from($field ?? {})).entries.toList()) MapEntry($firstType, ${isFromJson ? getFromJsonValue(info, secondType, "entry.value") : getToJsonValue(info, secondType, "entry.value")})])";

    cast = loop;
  } else if (!_commonTypes.contains(type)) {
    cast = isFromJson ? "$type.fromJson($field)" : "$field.toJson()";
  } else {
    cast = "$field";
  }

  return cast;
}
