import 'package:flutter/material.dart';

/// 城堡數據
class Castle {
  final String id;
  final bool isPlayerCastle;
  int hp;
  final int maxHp;
  final Offset position;

  Castle({
    required this.id,
    required this.isPlayerCastle,
    required this.hp,
    required this.maxHp,
    required this.position,
  });

  bool get isDestroyed => hp <= 0;

  void takeDamage(int damage) {
    hp = (hp - damage).clamp(0, maxHp);
  }
}
