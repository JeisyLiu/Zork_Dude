import 'dart:math';

/// Injectable random source for deterministic combat tests.
abstract class CombatRandom {
  int rollDice(int sides, [int times = 1]);
  double nextDouble();
}

class DefaultCombatRandom implements CombatRandom {
  DefaultCombatRandom([Random? random]) : _random = random ?? Random();

  final Random _random;

  @override
  int rollDice(int sides, [int times = 1]) {
    var total = 0;
    for (var i = 0; i < times; i++) {
      total += _random.nextInt(sides) + 1;
    }
    return total;
  }

  @override
  double nextDouble() => _random.nextDouble();
}

/// Fixed sequence random for unit tests.
class ScriptedCombatRandom implements CombatRandom {
  ScriptedCombatRandom({
    List<int>? diceRolls,
    List<double>? doubles,
  })  : _diceRolls = List<int>.from(diceRolls ?? const []),
        _doubles = List<double>.from(doubles ?? const []);

  final List<int> _diceRolls;
  final List<double> _doubles;
  var _diceIndex = 0;
  var _doubleIndex = 0;

  @override
  int rollDice(int sides, [int times = 1]) {
    var total = 0;
    for (var i = 0; i < times; i++) {
      if (_diceIndex < _diceRolls.length) {
        total += _diceRolls[_diceIndex++];
      } else {
        total += sides;
      }
    }
    return total;
  }

  @override
  double nextDouble() {
    if (_doubleIndex < _doubles.length) {
      return _doubles[_doubleIndex++];
    }
    return 0.5;
  }
}
