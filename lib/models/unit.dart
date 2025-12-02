import 'package:flutter/material.dart';

/// 單位數據
class Unit {
  final String id;
  final String name;
  final Offset position;
  final Color color;
  final IconData icon;
  final int hp;
  final int maxHp;
  final int power;
  final bool isPlayerUnit;
  final String? imagePath; // 圖片路徑
  final double imageRotation; // 圖片旋轉角度

  Unit({
    required this.id,
    required this.name,
    required this.position,
    required this.color,
    required this.icon,
    required this.hp,
    required this.maxHp,
    required this.power,
    required this.isPlayerUnit,
    this.imagePath,
    this.imageRotation = 0,
  });

  Unit copyWith({
    String? id,
    String? name,
    Offset? position,
    Color? color,
    IconData? icon,
    int? hp,
    int? maxHp,
    int? power,
    bool? isPlayerUnit,
    String? imagePath,
    double? imageRotation,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      power: power ?? this.power,
      isPlayerUnit: isPlayerUnit ?? this.isPlayerUnit,
      imagePath: imagePath ?? this.imagePath,
      imageRotation: imageRotation ?? this.imageRotation,
    );
  }
}
