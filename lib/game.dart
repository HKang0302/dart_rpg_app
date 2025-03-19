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
          character = createCharacter(name);
          print('게임을 시작합니다!');
          character.showStatus();
          break;
        }
      } catch (e) {
        print(e);
      }
    }

    loadMonsterFile();
  }

  Character createCharacter(String name) {
    try {
      final file = File('lib/files/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');

      int hp = int.parse(stats[0]);
      int power = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      return Character(name: name, hp: hp, power: power, defense: defense);
    } catch (e) {
      print('캐릭터 생성에 실패했습니다. 다시 이름을 입력해주세요.');
      String newName = stdin.readLineSync() ?? '';
      return createCharacter(newName);
    }
  }

  void loadMonsterFile() {
    try {
      final file = File('lib/files/monsters.txt');
      final contents = file.readAsStringSync();
      final monsters = contents.split('\n');
      monsters.forEach((monster) {
        final stats = monster.split(',');
        if (stats.length != 3) throw FormatException('Invalid moster data');
        this.monsters.add(
          Monster(
            name: stats[0],
            hp: int.parse(stats[1]),
            power: int.parse(stats[2]),
          ),
        );
      });
    } catch (e) {
      print('몬스터 데이터를 불러오는데 실패했습니다.');
    }
  }

  bool battle() {
    Monster monster = getRandomMonster();
    print('\n새로운 몬스터가 나타났습니다!');
    monster.showStatus();

    while (character.hp > 0 && monster.hp > 0) {
      print('\n${character.name}의 턴');
      stdout.write('행동을 선택하세요. (1: 공격, 2: 방어): ');
      String action = stdin.readLineSync() ?? '';
      if (action == '1') {
        character.attackMonster(monster);
      } else if (action == '2') {
        character.defend();
      } else {
        print('잘못된 입력입니다.');
      }

      if (monster.hp > 0) {
        print('\n${monster.name}의 턴');
        monster.attackCharacter(character);
      }
    }

    if (character.hp <= 0) {
      print('패배했습니다. 게임을 종료합니다.');
      return false;
    } else {
      print('${monster.name}을(를) 물리쳤습니다!');
      monsters.remove(monster);
      killedMonster++;
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
