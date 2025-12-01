import 'package:flutter/material.dart';

/// 卡牌類型
enum CardType {
  unit, // 單位卡（例如：哥布林）
  spell, // 法術卡
  building, // 建築卡
}

/// 卡牌數據類
class CardData {
  final int id;
  final String name;
  final int power;
  final Color color;
  final CardType type;
  final int cost; // 聖水費用
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
