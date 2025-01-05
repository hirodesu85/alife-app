import 'package:alife_app/components/enemies/base_enemy.dart';
import 'package:alife_app/components/enemies/enemy_factory.dart';
import 'package:flame/components.dart';
import 'dart:math';

class EnemyManager extends Component with HasGameRef {
  final List<BaseEnemy> enemies = [];
  final Random random = Random();

  void spawnEnemy(Vector2 screenSize) {
    final position = Vector2(
      random.nextDouble() * screenSize.x,
      random.nextDouble() * screenSize.y,
    );
    final enemy = EnemyFactory.createEnemy('random', position);
    enemies.add(enemy);
    add(enemy);
  }

  void initializeEnemies(int count, Vector2 screenSize) {
    for (int i = 0; i < count; i++) {
      spawnEnemy(screenSize);
    }
  }

  List<BaseEnemy> getEnemies() {
    return children.whereType<BaseEnemy>().toList();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 必要に応じて敵キャラ全体のロジックを記述
  }
}
