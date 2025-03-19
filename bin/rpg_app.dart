import 'dart:io';
import 'package:rpg_app/game.dart';

void main(List<String> arguments) {
  bool isRunning = true;
  Game game = Game();

  game.startGame(); // game setup

  // 몬스터를 모두 물리치거나 게임이 종료될 때까지 반복
  while (isRunning) {
    if (!game.battle()) {
      break;
    } // battle

    if (game.monsters.isEmpty) {
      print('모든 몬스터를 물리쳤습니다! YAY!!');
      isRunning = false;
    } else {
      stdout.write("\n다음 몬스터와 대결하시겠습니까? (y/n)");
      String answer = stdin.readLineSync() ?? '';
      if (answer != 'y') {
        isRunning = false;
      }
    }
  }

  game.showGameReault(); // game result
  stdout.write('게임 결과를 저장하시겠습니까? (y/n)');
  String answer = stdin.readLineSync() ?? '';
  if (answer == 'y') {
    game.saveResult(isRunning); // game result
  }

  print('게임을 종료합니다.');
}
