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
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.card.color, widget.card.color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: _isDragging
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                Icon(widget.card.icon, size: 35, color: Colors.white),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    widget.card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '威力: ${widget.card.power}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // 聖水費用標籤
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${widget.card.cost}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
}
