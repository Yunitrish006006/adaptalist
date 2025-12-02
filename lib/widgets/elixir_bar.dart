import 'package:flutter/material.dart';

/// 聖水條元件
class ElixirBar extends StatelessWidget {
  final int currentElixir;
  final int maxElixir;

  const ElixirBar({
    super.key,
    required this.currentElixir,
    required this.maxElixir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.pink.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.water_drop, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            '$currentElixir/$maxElixir',
            style: const TextStyle(
              fontFamily: 'Iansui',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
