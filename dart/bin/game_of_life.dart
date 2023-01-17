import 'package:game_of_life/game_of_life.dart' as game_of_life;

void main(List<String> arguments) {
  final generations = 500;
  final height = 50;
  final width = 100;
  
  game_of_life.runGame(height, width, generations);
}
