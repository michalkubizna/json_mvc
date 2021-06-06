import 'package:recase/recase.dart';

extension StringExtension on String {
  String toTitleCase() {
    var firstWord = toCamelCase();
    return '${firstWord.substring(0, 1).toUpperCase()}${firstWord.substring(1)}';
  }

  String toCamelCase() {
    var words = getWords();
    var leadingWords = words.getRange(1, words.length).toList();
    var leadingWord = leadingWords.map((e) => e.toTitleCase()).join('');
    return '${words[0].toLowerCase()}${leadingWord}';
  }

  String toSnakeCase() {
    return ReCase(toCamelCase()).snakeCase;
  }

  List<String> getWords() {
    var trimmed = trim();
    List<String> value;

    value = trimmed.split(RegExp(r'[_\W]'));
    value = value.where((element) => element.isNotEmpty).toList();
    value = value.expand((e) => e.split(RegExp(r'(?=[A-Z])'))).where((element) => element.isNotEmpty).toList();

    return value;
  }
}