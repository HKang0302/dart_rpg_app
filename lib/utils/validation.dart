/* 
  캐릭터 이름 유효성 검사
  - 영어, 한글만 사용 가능
  - 최소 2글자, 최대 10글자
*/
bool isCharacterNameValid(String name) {
  RegExp regExp = RegExp(r'^[a-zA-Z가-힣]{2,10}$');
  if (!regExp.hasMatch(name)) {
    throw '사용 불가능한 이름입니다.\n';
  }
  return true;
}
