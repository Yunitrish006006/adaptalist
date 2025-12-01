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
    );
  }
}
