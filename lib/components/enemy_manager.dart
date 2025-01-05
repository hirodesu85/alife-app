import 'package:flame/components.dart';
import 'enemy.dart';
import 'dart:math';

class EnemyManager extends Component with HasGameRef {
  final List<Enemy> enemies = [];
  final Random random = Random();

  void spawnEnemy(Vector2 screenSize) {
    final position = Vector2(
      random.nextDouble() * screenSize.x,
      random.nextDouble() * screenSize.y,
    );
    final enemy = Enemy(initialPosition: position);
    enemies.add(enemy);
    add(enemy);
  }

  void initializeEnemies(int count, Vector2 screenSize) {
    for (int i = 0; i < count; i++) {
      spawnEnemy(screenSize);
    }
  }

  List<Enemy> getEnemies() {
    return children.whereType<Enemy>().toList();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 必要に応じて敵キャラ全体のロジックを記述
  }
}
