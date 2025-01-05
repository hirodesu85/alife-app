import 'package:flame/components.dart';
import 'base_enemy.dart';
import 'random_enemy.dart';

class EnemyFactory {
  static BaseEnemy createEnemy(String type, Vector2 position) {
    switch (type) {
      case 'random':
        return RandomEnemy(initialPosition: position);
      default:
        throw Exception('Unknown enemy type: $type');
    }
  }
}
