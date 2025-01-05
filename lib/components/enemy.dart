import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class Enemy extends PositionComponent with HasGameRef {
  static const double radius = 10; // 敵キャラの半径
  static const double speed = 100; // 敵キャラの速度
  final Paint paint = Paint()..color = const Color(0xFFFF0000); // 赤色
  final Random random = Random();
  Vector2 velocity = Vector2.zero();

  Enemy({Vector2? initialPosition}) {
    if (initialPosition != null) position = initialPosition;
    _setRandomVelocity();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 位置を更新
    position += velocity * dt;

    // 壁で反射
    _checkCollisionWithWalls();
  }

  void _setRandomVelocity() {
    velocity = Vector2(
      (random.nextDouble() - 0.5) * 2 * speed,
      (random.nextDouble() - 0.5) * 2 * speed,
    );
  }

  void _checkCollisionWithWalls() {
    final screenSize = gameRef.size;

    if (position.x - radius < 0 || position.x + radius > screenSize.x) {
      velocity.x = -velocity.x; // 水平方向の速度を反転
      position.x = position.x.clamp(radius, screenSize.x - radius); // 画面内に戻す
    }

    if (position.y - radius < 0 || position.y + radius > screenSize.y) {
      velocity.y = -velocity.y; // 垂直方向の速度を反転
      position.y = position.y.clamp(radius, screenSize.y - radius); // 画面内に戻す
    }
  }
}
