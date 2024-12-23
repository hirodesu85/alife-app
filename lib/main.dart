import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: AlifeAppGame()));
}

class AlifeAppGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // ゲームの初期設定
  }
}
