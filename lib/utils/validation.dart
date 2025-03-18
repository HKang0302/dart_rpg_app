bool isCharacterNameValid(String name) {
  RegExp regExp = RegExp(r'^[a-zA-Z가-힣]+$');
  if (!regExp.hasMatch(name)) {
    throw FormatException('사용 불가능한 이름입니다.');
  }
  return true;
}
