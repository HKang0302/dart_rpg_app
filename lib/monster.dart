import 'package:rpg_app/character.dart';

class Monster {
  String name;
  int hp;
  int power;
  int defense = 0;

  Monster({required this.name, required this.hp, required this.power});

  /* power만큼 캐릭터 공격 */
  void attackCharacter(Character character) {
    // 방어력이 있으면 방어력만큼 데미지 감소
    print('${name}이(가) ${character.name}에게 ${power}의 데미지를 입혔습니다.');
    if (character.currentDefense > 0) {
      print('${name}이(가) ${character.name}의 방어력을 깎았습니다.');
      character.currentDefense -= power;
      if (character.currentDefense < 0) {
        character.hp += character.currentDefense;
        character.currentDefense = 0;
      }
    } else {
      character.hp -= power;
    }

    showStatus();
    character.showStatus();
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $power');
  }
}
