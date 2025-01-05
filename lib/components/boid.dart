import 'dart:math';
import 'package:alife_app/components/boid_flock.dart';
import 'package:alife_app/components/enemy.dart';
import 'package:alife_app/components/enemy_manager.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class Boid extends PositionComponent with HasGameRef {
  static const double radius = 5; // ボイドの半径
  Paint paint = Paint()..color = const Color(0xFF00FF00); // ボイドの描画色
  static const double Speed = 225; // ボイドの最大速度
  static const double perceptionRadius = 100; // 周囲を感知する半径
  static const double avoidanceRadius = 30; // 衝突回避の距離
  static const double alignmentStrength = 1.5; // 整列の影響力
  static const double cohesionStrength = 1.0; // 結合の影響力
  static const double separationStrength = 1.0; // 分離の影響力
  static const double noiseStrength = 5.0; // ノイズの影響力

  Vector2 velocity = Vector2.zero(); // 現在の速度
  BoidFlock? flock; // 群れの参照
  final Random random = Random(); // 乱数生成器

  Boid({Vector2? initialPosition, Vector2? initialVelocity, this.flock}) {
    if (initialPosition != null) position = initialPosition;
    if (initialVelocity != null) velocity = initialVelocity;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 円を描画
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 近くの他のボイドを取得
    final nearbyBoids = getNearbyBoids();

    // 各ルールを適用
    final alignment = align(nearbyBoids) * alignmentStrength;
    final cohesion = cohere(nearbyBoids) * cohesionStrength;
    final separation = separate(nearbyBoids) * separationStrength;

    // ノイズを生成
    final noise = Vector2(
      (random.nextDouble() - 0.5) * 2 * noiseStrength,
      (random.nextDouble() - 0.5) * 2 * noiseStrength,
    );

    // 力を合成
    velocity += alignment + cohesion + separation + noise;

    // 速度を一定に揃える
    velocity = velocity.normalized() * Speed;

    // 位置を更新
    position += velocity * dt;

    // 画面端で速度を反転させる
    checkCollisionWithWalls();

    // 敵キャラとの衝突判定
    if (flock?.gameRef.children.whereType<EnemyManager>().isNotEmpty ?? false) {
      final enemyManager =
          flock!.gameRef.children.whereType<EnemyManager>().first;
      checkCollisionWithEnemies(enemyManager.getEnemies());
    }
  }

  // 周囲のボイドを取得
  List<Boid> getNearbyBoids() {
    if (flock == null) return []; // 群れが未設定の場合は空リストを返す

    return flock!.boids.where((boid) {
      if (boid == this) return false; // 自分自身は除外
      return position.distanceTo(boid.position) < perceptionRadius;
    }).toList();
  }

  // 整列（Alignment）: 周囲のボイドの平均速度に合わせる
  Vector2 align(List<Boid> nearbyBoids) {
    if (nearbyBoids.isEmpty) return Vector2.zero();

    final averageVelocity = nearbyBoids
        .map((boid) => boid.velocity)
        .reduce((a, b) => a + b)
        .scaled(1 / nearbyBoids.length.toDouble());
    return (averageVelocity - velocity).normalized();
  }

  // 結合（Cohesion）: 群れの中心に向かう
  Vector2 cohere(List<Boid> nearbyBoids) {
    if (nearbyBoids.isEmpty) return Vector2.zero();

    // 平均位置を計算し、Vector2として返す
    final averagePosition = nearbyBoids
        .map((boid) => Vector2(boid.position.x, boid.position.y)) // Vector2に変換
        .reduce((a, b) => a + b)
        .scaled(1 / nearbyBoids.length.toDouble());

    return (averagePosition - position).normalized();
  }

  // 分離（Separation）: 他のボイドから離れる
  Vector2 separate(List<Boid> nearbyBoids) {
    Vector2 steering = Vector2.zero();
    for (final boid in nearbyBoids) {
      final distance = position.distanceTo(boid.position);
      if (distance < avoidanceRadius) {
        steering += (position - boid.position).normalized() / distance;
      }
    }
    return steering.normalized();
  }

  // 画面端で位置をループさせる（画面外に出ないようにする）
  void checkCollisionWithWalls() {
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

  void checkCollisionWithEnemies(List<Enemy> enemies) {
    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);
      const combinedRadius = radius + Enemy.radius;

      if (distance < combinedRadius) {
        removeFromParent();
        return; // 一度の衝突で処理を終える
      }
    }
  }
}
