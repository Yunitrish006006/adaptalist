import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/card_data.dart';

/// 可拖拉的卡牌元件
class GameCard extends StatefulWidget {
  final CardData card;
  final bool isDraggable;
  final bool canAfford;

  const GameCard({
    super.key,
    required this.card,
    required this.isDraggable,
    this.canAfford = true,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final card = Opacity(
      opacity: widget.canAfford ? 1.0 : 0.5,
      child: Container(
        width: 170,
        height: 240,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.card.color, widget.card.color.withAlpha(179)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: _isDragging
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.card.imagePath != null)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Transform.rotate(
                      angle: widget.card.imageRotation * math.pi / 180,
                      child: Image.asset(
                        widget.card.imagePath!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                else if (widget.card.icon != null)
                  Icon(widget.card.icon, size: 70, color: Colors.white),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(77),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '威力: ${widget.card.power}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // 資源費用標籤
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.card.cost.stamina > 0)
                    _buildCostBadge(
                      Icons.fitness_center,
                      widget.card.cost.stamina,
                      Colors.orange,
                    ),
                  if (widget.card.cost.spirit > 0)
                    _buildCostBadge(
                      Icons.psychology,
                      widget.card.cost.spirit,
                      Colors.purple,
                    ),
                  if (widget.card.cost.money > 0)
                    _buildCostBadge(
                      Icons.attach_money,
                      widget.card.cost.money,
                      Colors.amber.shade700,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.isDraggable || !widget.canAfford) {
      return card;
    }

    return Draggable<CardData>(
      data: widget.card,
      feedback: Opacity(
        opacity: 0.8,
        child: Transform.scale(scale: 1.1, child: card),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: card,
      ),
      onDragStarted: () {
        setState(() {
          _isDragging = true;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      child: card,
    );
  }

  Widget _buildCostBadge(IconData icon, int value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
