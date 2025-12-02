import 'package:flutter/material.dart';
import '../models/unit.dart';
import '../models/card_data.dart';
import '../models/castle.dart';
import 'unit_widget.dart';
import 'castle_widget.dart';

/// 戰鬥場地元件
class BattleField extends StatelessWidget {
  final List<Unit> units;
  final Castle playerCastle;
  final Castle enemyCastle;
  final Function(Offset position, CardData card) onCardDropped;

  const BattleField({
    super.key,
    required this.units,
    required this.playerCastle,
    required this.enemyCastle,
    required this.onCardDropped,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardData>(
      onAcceptWithDetails: (details) {
        // 獲取放置位置
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.offset);
        onCardDropped(localPosition, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade200,
                Colors.green.shade300,
                Colors.green.shade400,
                Colors.brown.shade300,
              ],
              stops: const [0.0, 0.45, 0.55, 1.0],
            ),
            border: Border.all(color: Colors.brown.shade700, width: 4),
          ),
          child: Stack(
            children: [
              // 中線
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: CustomPaint(
                  painter: FieldLinePainter(),
                ),
              ),
              // 城堡
              CastleWidget(castle: enemyCastle),
              CastleWidget(castle: playerCastle),
              // 單位
              ...units.map((unit) => UnitWidget(unit: unit)),
              // 提示文字
              if (units.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '拖曳卡牌到場地上召喚單位',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// 繪製場地線條
class FieldLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(77)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 繪製中線
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // 繪製虛線
    final dashPaint = Paint()
      ..color = Colors.white.withAlpha(51)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, size.height / 2),
        Offset(i + 10, size.height / 2),
        dashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
