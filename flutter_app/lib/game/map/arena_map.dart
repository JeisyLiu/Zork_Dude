import 'package:bonfire/bonfire.dart';
import 'package:zork_dude/shared/game_constants.dart';

/// Small combat arena (not the Zork world map).
class ArenaMap {
  static const double tile = GameConstants.tileSize;

  static final List<List<double>> _matrix = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ];

  static WorldMap build() {
    return MatrixMapGenerator.generate(
      layers: [MatrixLayer(matrix: _matrix, axisInverted: true)],
      builder: (props) {
        final solid = props.value == 1;
        return Tile(
          x: props.position.x,
          y: props.position.y,
          width: tile,
          height: tile,
          color: solid ? GameConstants.wall : GameConstants.grass,
          collisions: solid ? [RectangleHitbox(size: Vector2.all(tile))] : null,
        );
      },
    );
  }

  static Vector2 playerSpawn() => Vector2(tile * 3, tile * 4);
  static Vector2 enemySpawn() => Vector2(tile * 8, tile * 4);
}
