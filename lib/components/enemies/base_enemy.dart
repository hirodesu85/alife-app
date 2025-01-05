import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

abstract class BaseEnemy extends PositionComponent with HasGameRef {
  final double baseSpeed = 100; // 基本速度
  final double baseRadius = 10; // 基本半径
  Paint paint = Paint()..color = const Color(0xFFFF0000); // デフォルト色

  Vector2 velocity = Vector2.zero();

  BaseEnemy({Vector2? initialPosition}) {
    if (initialPosition != null) position = initialPosition;
    setInitialVelocity();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, baseRadius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    checkCollisionWithWalls();
  }

  /// 初期速度を設定（派生クラスでオーバーライド可能）
  void setInitialVelocity() {
    velocity = Vector2.random()..scale(baseSpeed);
  }

  /// 壁との衝突処理
  void checkCollisionWithWalls() {
    final screenSize = gameRef.size;

    if (position.x - baseRadius < 0 || position.x + baseRadius > screenSize.x) {
      velocity.x = -velocity.x;
      position.x = position.x.clamp(baseRadius, screenSize.x - baseRadius);
    }

    if (position.y - baseRadius < 0 || position.y + baseRadius > screenSize.y) {
      velocity.y = -velocity.y;
      position.y = position.y.clamp(baseRadius, screenSize.y - baseRadius);
    }
  }
}
