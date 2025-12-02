import 'package:flutter/material.dart';

/// 資源條元件
class ResourceBar extends StatelessWidget {
  final int stamina; // 體力
  final int maxStamina;
  final int spirit; // 精神力
  final int maxSpirit;
  final int money; // 金錢

  const ResourceBar({
    super.key,
    required this.stamina,
    required this.maxStamina,
    required this.spirit,
    required this.maxSpirit,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 體力
        _buildResourceItem(
          icon: Icons.fitness_center,
          value: stamina,
          maxValue: maxStamina,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        // 精神力
        _buildResourceItem(
          icon: Icons.psychology,
          value: spirit,
          maxValue: maxSpirit,
          color: Colors.purple,
        ),
        const SizedBox(width: 8),
        // 金錢
        _buildMoneyItem(),
      ],
    );
  }

  Widget _buildResourceItem({
    required IconData icon,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_money, color: Colors.white, size: 16),
          const SizedBox(width: 2),
          Text(
            '$money',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 保留舊名稱以確保向後相容
typedef ElixirBar = ResourceBar;
