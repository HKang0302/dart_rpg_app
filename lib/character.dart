import 'dart:math';
import 'dart:io';

import 'package:rpg_app/monster.dart';

class Character {
  static const double ITEM_DROP_PROBABILITY = 0.8;
  static const double BONUS_HP_PROBABILITY = 0.3;
  static const double RUN_PROBABILITY = 0.2;

  static const int BONUS_HP = 10;
  static const int ITEM_DEFENSE = 20;

  String name;
  int hp;
  int power;
  int defense;
  int currentDefense = 0;

  int numPowerItems = 0;
  int numDefenseItems = 0;
  bool usingPowerItem = false;

  Character({
    required this.name,
    required this.hp,
    required this.power,
    required this.defense,
  });

  void init4Battle() {
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

  /* 도망가기 */
  bool didRunAway() {
    Random random = Random();
    return random.nextDouble() < RUN_PROBABILITY ? true : false;
  }

  /* 몬스터와의 대결에서 이길 시 특정 확률로 아이템 습득 */
  void getRandomItem() {
    Random random = Random();
    if (random.nextDouble() < ITEM_DROP_PROBABILITY) {
      if (random.nextBool()) {
        numDefenseItems += 1;
        print('방어 아이템을 얻었습니다!');
      } else {
        numPowerItems += 1;
        print('공격 아이템을 얻었습니다!');
      }
    }
  }

  /* 아이템 사용 */
  void useItem() {
    print('현재 보유하고 계신 아이템: 공격(${numPowerItems}개), 방어(${numDefenseItems}개)');
    stdout.write('어떤 아이템을 사용하시겠습니까? (공격: 1, 방어: 2, 아이템 사용 안함: 0): ');
    String answer = stdin.readLineSync() ?? '';

    try {
      switch (answer) {
        case '1':
          if (numPowerItems > 0) {
            print('이번 턴에 공격력이 2배로 증가합니다.');
            usingPowerItem = true;
            numPowerItems -= 1;
          } else {
            throw '공격 아이템이 없습니다.';
          }
          break;
        case '2':
          if (numDefenseItems > 0) {
            print('방어력이 ${ITEM_DEFENSE} 증가합니다.');
            currentDefense += ITEM_DEFENSE;
            numDefenseItems -= 1;
          } else {
            throw '방어 아이템이 없습니다.';
          }
          break;
        case '0':
          break;
        default:
          throw '잘못된 입력입니다.';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showStatus() {
    print(
      '$name - 체력: $hp, 공격력: $power, 방어력: $currentDefense (방어 시, 방어력 ${defense}만큼 증가)',
    );
  }
}
