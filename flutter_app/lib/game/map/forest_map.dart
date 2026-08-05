import 'package:bonfire/bonfire.dart';
import 'package:zork_dude/game/enemies/mist_slime.dart';
import 'package:zork_dude/shared/game_constants.dart';

/// Tile codes for the matrix map.
/// 0 = grass, 1 = wall/tree, 2 = path, 3 = stone
abstract final class ForestMap {
  static const double tile = GameConstants.tileSize;

  /// Axis-inverted for readable ASCII layout (rows = Y).
  static final List<List<double>> _matrix = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 3, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 3, 0, 0, 1],
    [1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 2, 0, 0, 1, 1, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 2, 0, 0, 1, 1, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 1, 1, 0, 0, 0, 2, 2, 0, 0, 0, 1, 1, 0, 0, 0, 1],
    [1, 0, 3, 0, 1, 1, 0, 0, 0, 2, 2, 0, 0, 0, 1, 1, 0, 3, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  static WorldMap build() {
    return MatrixMapGenerator.generate(
      layers: [
        MatrixLayer(matrix: _matrix, axisInverted: true),
      ],
      builder: (props) {
        final value = props.value;
        final pos = props.position;
        final color = switch (value) {
          1 => GameConstants.tree,
          2 => GameConstants.path,
          3 => GameConstants.wall,
          _ => GameConstants.grass,
        };
        final solid = value == 1 || value == 3;

        return Tile(
          x: pos.x,
          y: pos.y,
          width: tile,
          height: tile,
          color: color,
          collisions: solid
              ? [
                  RectangleHitbox(size: Vector2.all(tile)),
                ]
              : null,
        );
      },
    );
  }

  /// Spawn near the crossroads.
  static Vector2 playerSpawn() => Vector2(tile * 9.5, tile * 8);

  static List<GameComponent> enemies() => [
        MistSlime(position: Vector2(tile * 4, tile * 3)),
        MistSlime(position: Vector2(tile * 14, tile * 12)),
        MistSlime(position: Vector2(tile * 15, tile * 4)),
      ];
}
