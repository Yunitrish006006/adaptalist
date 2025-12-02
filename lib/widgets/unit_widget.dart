import 'package:flutter/material.dart';
import '../models/unit.dart';

/// 單位元件
class UnitWidget extends StatefulWidget {
  final Unit unit;

  const UnitWidget({super.key, required this.unit});

  @override
  State<UnitWidget> createState() => _UnitWidgetState();
}

class _UnitWidgetState extends State<UnitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.unit.position.dx - 30,
      top: widget.unit.position.dy - 30,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 血條
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(77),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.unit.hp / widget.unit.maxHp,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.unit.isPlayerUnit
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // 單位圖標
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: widget.unit.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.unit.isPlayerUnit
                      ? Colors.blue.shade700
                      : Colors.red.shade700,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.unit.icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            // 單位名稱
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.unit.name,
                style: const TextStyle(
                  fontFamily: 'Iansui',
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
