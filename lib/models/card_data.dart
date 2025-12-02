import 'package:flutter/material.dart';

enum CardType {
  unit, building, physic
}

/// 卡牌數據類
class CardData {
  final int id;
  final String name;
  final int power;
  final Color color;
  final CardType type;
  final int cost;
  final IconData icon;

  CardData({
    required this.id,
    required this.name,
    required this.power,
    required this.color,
    required this.type,
    required this.cost,
    required this.icon,
  });
}
