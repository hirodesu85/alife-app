import 'package:flame/components.dart';
import 'boid.dart';
import 'dart:math';

class BoidFlock extends Component with HasGameRef {
  final List<Boid> boids = []; // 群れの全ボイドを管理
  final Random random = Random(); // 乱数生成器

  /// 群れにボイドを追加
  void addBoid(Boid boid) {
    boids.add(boid);
    add(boid);
    boid.flock = this; // Boidに群れの参照を設定
  }

  /// 初期化用のメソッド
  void initializeFlock(int count, Vector2 screenSize) {
    for (int i = 0; i < count; i++) {
      final position = Vector2(
        random.nextDouble() * screenSize.x, // 0 〜 画面幅
        random.nextDouble() * screenSize.y, // 0 〜 画面高さ
      );
      final velocity = Vector2.random()..scale(100); // ランダムな速度
      addBoid(Boid(initialPosition: position, initialVelocity: velocity));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 必要に応じて群れ全体のロジックを記述
  }
}
