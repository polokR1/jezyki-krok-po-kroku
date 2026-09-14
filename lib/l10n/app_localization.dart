String localized(
  String interfaceLanguage, {
  required String pl,
  required String uk,
}) => interfaceLanguage == 'uk' ? uk : pl;
