import 'package:rpg_app/monster.dart';

class Character {
  String name;
  int hp;
  int power;
  int defense;
  int currentDefense = 0;

  Character({
    required this.name,
    required this.hp,
    required this.power,
    required this.defense,
  });

  /* 몬스터에게 캐릭터의 공격력만큼의 데미지 */
  void attackMonster(Monster monster) {
    monster.hp -= power; // TODO: 몬스터 방어력만큼 데미지 감소 (power - monster.defense)
    print('${name}이(가) ${monster.name}에게 ${power}의 데미지를 입혔습니다.');
    showStatus();
    monster.showStatus();
  }

  /* 캐릭터의 방어력만큼의 방어력 증가 */
  void defend() {
    currentDefense = defense;
    print('$name의 방어력이 $defense만큼 증가했습니다.');
  }

  void showStatus() {
    print(
      '$name - 체력: $hp, 공격력: $power, 방어력: $currentDefense (방어 시, 방어력 ${defense}만큼 증가)',
    );
  }
}
