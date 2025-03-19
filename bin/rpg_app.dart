import 'dart:io';
import 'package:rpg_app/game.dart';

void main(List<String> arguments) {
  bool isRunning = true;
  Game game = Game();
  game.startGame(); // game setup

  while (isRunning) {
    if (!game.battle()) {
      break;
    } // battle
    stdout.write("\n다음 몬스터와 대결하시겠습니까? (y/n)");
    String answer = stdin.readLineSync() ?? '';
    if (answer != 'y') {
      isRunning = false;
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
