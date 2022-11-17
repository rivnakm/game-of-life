import "dart:io";

import 'package:game_of_life/game_of_life.dart' as game_of_life;

import 'package:args/args.dart';

void main(List<String> arguments) {
  String generationsString = "";
  ArgParser parser = ArgParser();
  parser.addOption("generations", abbr: 'g', defaultsTo: "-1");
  parser.addOption("size", abbr: 's');

  ArgResults argResults = parser.parse(arguments);

  final generations = int.parse(argResults["generations"]);

  int height;
  int width;
  if (argResults["size"] == null) {
    height = stdout.terminalLines - 1;
    width = (stdout.terminalColumns / 2).truncate();
  }
  else {
    RegExp re = RegExp(r"^(\d+)x(\d+)$");
    RegExpMatch match = re.firstMatch(argResults["size"])!;
    height = int.parse(match.group(2)!);
    width = int.parse(match.group(1)!);
  }

  game_of_life.runGame(height, width, generations);
}
