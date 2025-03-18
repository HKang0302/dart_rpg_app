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
    print("\n다음 몬스터와 대결하시겠습니까? (y/n)");
    String answer = stdin.readLineSync() ?? '';
    if (answer != 'y') {
      isRunning = false;
    }
  }
}
