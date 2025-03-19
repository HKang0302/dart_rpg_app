import 'dart:math';

import 'package:rpg_app/monster.dart';

class Character {
  static const double BONUS_HP_PROBABILITY = 0.3;
  static const int BONUS_HP = 10;

  String name;
  int hp;
  int power;
  int defense;
  int currentDefense = 0;

  bool hasItem = true;
  bool usingPowerItem = false;

  Character({
    required this.name,
    required this.hp,
    required this.power,
    required this.defense,
  });

  void init4Battle() {
    hasItem = true;
    usingPowerItem = false;
  }

  void getBonusHP() {
    Random random = Random();
    if (random.nextDouble() < BONUS_HP_PROBABILITY) {
      hp += BONUS_HP;
      print('\n보너스 체력을 얻었습니다! 현재 체력: ${hp}');
    }
  }

  /* 몬스터에게 캐릭터의 공격력만큼의 데미지 */
  void attackMonster(Monster monster) {
    int tempPower = usingPowerItem ? power * 2 : power;
    monster.hp -= tempPower;
    usingPowerItem = false;
    print('${name}이(가) ${monster.name}에게 ${tempPower}의 데미지를 입혔습니다.');
    showStatus();
    monster.showStatus();
  }

  /* 캐릭터의 방어력만큼의 방어력 증가 */
  void defend() {
    currentDefense = defense;
    usingPowerItem = false;
    print('$name의 방어력이 $defense만큼 증가했습니다.');
  }

  /* 아이템 사용 */
  void useItem() {
    if (hasItem) {
      hasItem = false;
      usingPowerItem = true;
      print('아이템을 사용했습니다. 공격력이 2배 증가합니다.');
    } else {
      print('이미 아이템을 사용했습니다.');
    }
  }

  void showStatus() {
    print(
      '$name - 체력: $hp, 공격력: $power, 방어력: $currentDefense (방어 시, 방어력 ${defense}만큼 증가)',
    );
  }
}
