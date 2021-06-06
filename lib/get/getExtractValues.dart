List getExtractValues(String type) {
  type = type.replaceRange(0, type.indexOf("<") + 1, "");

  type = type.replaceRange(type.lastIndexOf(">"), type.length, "");

  return type.replaceFirst(", ", ".").split(".");
}
