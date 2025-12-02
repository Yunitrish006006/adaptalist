import 'package:flutter/material.dart';

enum CardType {
  unit, building, physic
}

/// 資源費用
class ResourceCost {
  final int stamina; // 體力
  final int spirit; // 精神力
  final int money; // 金錢

  const ResourceCost({this.stamina = 0, this.spirit = 0, this.money = 0});
}

/// 卡牌數據類
class CardData {
  final int id;
  final String name;
  final int power;
  final Color color;
  final CardType type;
  final ResourceCost cost; // 資源費用
  final IconData? icon;
  final String? imagePath; // 圖片路徑
  final double imageRotation; // 圖片旋轉角度（度數）
  final double speed; // 行進速度

  CardData({
    required this.id,
    required this.name,
    required this.power,
    required this.color,
    required this.type,
    this.cost = const ResourceCost(),
    this.icon,
    this.imagePath,
    this.imageRotation = 0, // 預設不旋轉
    this.speed = 2.0, // 預設速度
  });
}
