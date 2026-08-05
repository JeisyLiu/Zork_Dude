import 'dart:math';

final _rng = Random();

int rollDice(int sides, [int times = 1]) {
  var total = 0;
  for (var i = 0; i < times; i++) {
    total += _rng.nextInt(sides) + 1;
  }
  return total;
}
