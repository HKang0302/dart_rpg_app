import 'package:rpg_app/character.dart';

/* 
  몬스터 클래스
  - 몬스터 이름, 체력, 공격력, 방어력 정보를 가지고 있음
  - 몬스터의 상태를 출력하는 메서드를 가지고 있음
  - 몬스터의 공격력을 증가시키는 메서드를 가지고 있음
  - 몬스터의 방어력을 증가시키는 메서드를 가지고 있음
*/
class Monster {
  String name;
  int hp;
  int power;
  int defense = 0;

  Monster({required this.name, required this.hp, required this.power});

  /* power만큼 캐릭터 공격 */
  void attackCharacter(Character character) {
    // 방어력이 있으면 방어력만큼 데미지 감소
    int damage =
        power -
        (character.defense +
            character.shield +
            (character.usingDefendItem ? Character.ITEM_DEFENSE : 0));
    if (damage < 0) {
      damage = 0;
    }
    character.hp -= damage;
    if (character.hp < 0) {
      character.hp = 0;
    }

    print('$name이(가) ${character.name}에게 $power의 데미지를 입혔습니다.');
    print('${character.name}의 방어력으로 인해 $damage의 피해를 입었습니다.');

    character.init4Battle();
    showStatus();
    character.showStatus();
  }

  /* 방어력 증가 */
  void increaseDefense() {
    defense += 2;
    print('${name}의 방어력이 증가했습니다. 현재 방어력: $defense');
  }

  /* 몬스터 상태 출력 */
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $power, 방어력: $defense');
  }
}
