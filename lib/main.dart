import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/boid_flock.dart';

void main() {
  runApp(GameWidget(game: AlifeAppGame()));
}

class AlifeAppGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final boidFlock = BoidFlock();

    // 群れを初期化
    boidFlock.initializeFlock(20, size);

    // ゲームに群れを追加
    add(boidFlock);
  }
}
