import 'dart:convert';
import 'package:json_mvc/utils/Info.dart';

import '../utils/extensions.dart';

List<Info> getInfos(Map json) {
  final List<Info> infos = <Info>[];

  for (final MapEntry entry in json.entries.toList()) {
    infos.add(Info(
        snake: jsonEncode(entry.key.toString().toSnakeCase()),
        title: entry.key.toString(),
        camel: entry.key.toString().toCamelCase(),
        type: entry.value["type"].toString(),
        values: jsonEncode(entry.value["values"]),
        hasValues: entry.value["values"] != null,
        value: entry.value["value"],
        hasValue: entry.value["value"] != null,
        toJsonValue: entry.value["to_json_value"],
        fromJsonValue: entry.value["from_json_value"],
        hasToJsonValue: entry.value["to_json_value"] != null,
        hasFromJsonValue: entry.value["from_json_value"] != null,
        compType: "${entry.value["view"]}Comp",
        comp: "${entry.key.toString().toCamelCase()}Comp",
        blocType: "${entry.value["view"]}Bloc",
        bloc: "${entry.key.toString().toCamelCase()}Bloc",
        hasView: entry.value["view"] != null,
        ignore: entry.value["ignore"] ?? false,
        spread: entry.value["spread"] ?? false
    ));
  }

  return infos;
}
