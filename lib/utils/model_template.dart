import '../get/getImports.dart';
import '../get/getInfos.dart';
import '../get/getTopLevel.dart';
import '../get/getJson.dart';
import '../get/getLazy.dart';
import 'extensions.dart';

String defaultTemplate(
  Map jsonMap,
  String fileName,
) {
  final className = fileName.toTitleCase();

  final infos = getInfos(jsonMap);

  var template = '';

  template += '''
${getImports(infos)}

''';

  template += '''
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class $className {
${getCamels(infos)}
${getComps(infos)}
${getBlocs(infos)}
${getValues(infos)}
${getSnakes(infos)}
${getTitles(infos)}
factory $className.copy($className object) => $className.fromJson(object.toJson());
List<Info> infos;
${getConstructor(className, [
    getLazyTitles(infos),
    getLazyBlocs(infos),
    getLazyInfos(infos),
  ])}
${getFromJson(className, infos)}
${getToJson(infos)}
}
''';

  return template;
}
