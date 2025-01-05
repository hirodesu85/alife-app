import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/boid_flock.dart';
import 'components/enemy_manager.dart';

void main() {
  runApp(GameWidget(game: AlifeAppGame()));
}

class AlifeAppGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final boidFlock = BoidFlock();
    boidFlock.initializeFlock(20, size);

    final enemyManager = EnemyManager();
    enemyManager.initializeEnemies(5, size);

    add(boidFlock);
    add(enemyManager);
  }
}
