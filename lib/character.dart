import 'dart:math';
import 'dart:io';

import 'package:rpg_app/monster.dart';

/* 
  캐릭터 클래스
  - 캐릭터 이름, 체력, 공격력, 방어력 정보를 가지고 있음
  - 캐릭터의 상태를 출력하는 메서드를 가지고 있음
  - 캐릭터의 공격력을 증가시키는 메서드를 가지고 있음
  - 캐릭터의 방어력을 증가시키는 메서드를 가지고 있음
  - 캐릭터의 방어력을 증가시키는 메서드를 가지고 있음
*/
class Character {
  static const double ITEM_DROP_PROBABILITY = 0.8; // 아이템 드롭 확률
  static const double BONUS_HP_PROBABILITY = 0.3; // 보너스 체력 확률
  static const double RUN_PROBABILITY = 0.2; // 도망가기 확률

  static const int BONUS_HP = 10; // 보너스 체력
  static const int ITEM_DEFENSE = 20; // 아이템 방어력
  static const int SHIELD_DEFENSE = 10; // 방패 방어력

  static const int POWER_ITEM = 1; // 공격 아이템
  static const int DEFENSE_ITEM = 2; // 방어 아이템
  static const int SHEILD = 3; // 방패
  static const List<int> DROPS = [
    POWER_ITEM,
    DEFENSE_ITEM,
    SHEILD,
  ]; // 아이템 드롭 목록

  String name;
  int hp;
  int power;
  int defense; // 기본 방어력
  int shield = 0; // 장비에 의한 방어력 증가

  int numPowerItems = 0;
  int numDefenseItems = 0;

  bool defending = false; // 방어 상태
  bool usingPowerItem = false; // 공격 아이템 사용 여부
  bool usingDefendItem = false; // 방어 아이템 사용 여부

  Character({
    required this.name,
    required this.hp,
    required this.power,
    required this.defense,
  });

  /* 몬스터와의 대결 준비 */
  void init4Battle() {
    defending = false;
    usingPowerItem = false;
    usingDefendItem = false;
  }

  /* 보너스 체력 획득 */
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
    init4Battle();
    print('${name}이(가) ${monster.name}에게 ${tempPower}의 데미지를 입혔습니다.');
    showStatus();
    monster.showStatus();
  }

  /* 캐릭터의 방어력만큼의 방어력 증가 */
  void defend() {
    defending = true;
    print('$name의 방어력이 $shield만큼 증가했습니다.');
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
      int randomItem = DROPS[random.nextInt(DROPS.length)];
      switch (randomItem) {
        case POWER_ITEM:
          numPowerItems += 1;
          print('공격 아이템을 얻었습니다!');
          break;
        case DEFENSE_ITEM:
          numDefenseItems += 1;
          print('방어 아이템을 얻었습니다!');
          break;
        case SHEILD:
          shield += SHIELD_DEFENSE;
          print('방패를 주웠습니다. 방패의 방어력이 ${SHIELD_DEFENSE}만큼 증가합니다.');
          print('방어 시, ${shield}만큼 방어');
          break;
        default:
          break;
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
            print('방어력이 ${ITEM_DEFENSE}만큼 증가합니다.');
            usingDefendItem = true;
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

  /* 캐릭터 상태 출력 */
  void showStatus() {
    print(
      '$name - 체력: $hp, 공격력: $power, 방어력: $defense (방어 시, ${shield}만큼 방어력 증가)',
    );
  }
}
