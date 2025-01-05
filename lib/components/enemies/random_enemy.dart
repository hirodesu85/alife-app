import 'package:flame/components.dart';
import 'base_enemy.dart';

class RandomEnemy extends BaseEnemy {
  RandomEnemy({super.initialPosition});

  @override
  void setInitialVelocity() {
    velocity = Vector2.random()..scale(baseSpeed);
  }
}
