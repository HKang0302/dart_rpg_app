import 'dart:io';
import 'dart:math';

import 'package:rpg_app/character.dart';
import 'package:rpg_app/monster.dart';
import 'package:rpg_app/utils/validation.dart';

class Game {
  late Character character;
  int killedMonster = 0;
  List<Monster> monsters = [];

  /* 
    게임 시작 전 setup

    1. 캐릭터 이름 입력
    2. load 캐릭터 stat from file & 확인
    3. load 몬스터 stats from file
 */
  void startGame() {
    bool isValid = false;
    while (!isValid) {
      stdout.write("캐릭터의 이름을 입력하세요. (한글, 영문 대소문자만 가능): ");
      String name = stdin.readLineSync() ?? '';
      try {
        isValid = isCharacterNameValid(name);
        if (isValid) {
          character =
              createCharacter(name) ??
              (() {
                print('캐릭터 생성에 실패했습니다. 게임을 종료합니다.');
                exit(0);
              })();
          character.getBonusHP();
          character.showStatus();
          break;
        }
      } catch (e) {
        print(e);
      }
    }

    loadMonsterFile();
  }

  Character? createCharacter(String name) {
    try {
      final file = File('lib/files/characters.txt');
      if (!file.existsSync()) {
        // 파일 존재하지 않는 경우 게임 종료 (return null)
        throw '캐릭터 데이터 파일이 없습니다. 파일 확인 후 다시 시작해주세요.';
      }

      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      if (stats.length != 3) throw '캐릭터 정보가 올바르지 않습니다.';

      int hp = int.tryParse(stats[0]) ?? 50;
      int power = int.tryParse(stats[1]) ?? 10;
      int defense = int.tryParse(stats[2]) ?? 0;

      return Character(name: name, hp: hp, power: power, defense: defense);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void loadMonsterFile() {
    try {
      final file = File('lib/files/monsters.txt');
      if (!file.existsSync()) {
        throw '몬스터 데이터 파일이 없습니다. 파일 확인 후 다시 시작해주세요.';
      }
      final contents = file.readAsStringSync();
      final monsters = contents.split('\n');
      monsters.forEach((monster) {
        final stats = monster.split(',');
        if (stats.length != 3) throw '몬스터 정보가 올바르지 않습니다.';
        this.monsters.add(
          Monster(
            name: stats[0],
            hp: int.tryParse(stats[1]) ?? 50,
            power: int.tryParse(stats[2]) ?? 10,
          ),
        );
      });
    } catch (e) {
      print(e.toString());
      print('몬스터 데이터를 불러오는 중 오류가 발생했습니다. 게임을 종료합니다.');
      exit(0);
    }
  }

  bool battle() {
    Monster monster = getRandomMonster();
    print('\n새로운 몬스터가 나타났습니다!');
    monster.showStatus();

    // 배틀 전 캐릭터 옵션 초기화
    character.init4Battle();
    int round = 0;

    while (character.hp > 0 && monster.hp > 0) {
      print('\n${character.name}의 턴');
      stdout.write('행동을 선택하세요. (1: 공격, 2: 방어, 3: 아이템 사용)');
      String action = stdin.readLineSync() ?? '';
      switch (action) {
        case '1':
          character.attackMonster(monster);
          break;
        case '2':
          character.defend();
          break;
        case '3':
          character.useItem();
          break;
        default:
          print('잘못된 입력입니다.');
          break;
      }

      if (action != '3' && monster.hp > 0) {
        round += 1;
        print('\n${monster.name}의 턴');
        monster.attackCharacter(character);
        if (round % 3 == 0) {
          monster.increaseDefense();
        }
      }
    }

    if (character.hp <= 0) {
      print('패배했습니다. 게임을 종료합니다.');
      return false;
    } else {
      print('${monster.name}을(를) 물리쳤습니다!');
      monsters.remove(monster);
      killedMonster++;
      character.getRandomItem(); // 몬스터가 일정 확률로 아이템 drop
      character.showStatus();
      return true;
    }
  }

  Monster getRandomMonster() {
    final random = Random();
    final index = random.nextInt(monsters.length);
    return monsters[index];
  }

  void showGameReault() {
    print('\n게임 결과');
    print(
      '캐릭터: ${character.name} | 남은 체력: ${character.hp} | 물리친 몬스터 수: $killedMonster',
    );
  }

  void saveResult(bool didDefeat) {
    final file = File('lib/files/result.txt');
    file.writeAsStringSync(
      '${character.name}, ${character.hp}, $killedMonster, ${didDefeat ? '패배' : '승리'}',
    );
    print('게임 결과를 저장했습니다.');
  }
}
