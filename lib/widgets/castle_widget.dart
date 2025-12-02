import 'package:flutter/material.dart';
import '../models/castle.dart';

/// 城堡元件
class CastleWidget extends StatelessWidget {
  final Castle castle;

  const CastleWidget({super.key, required this.castle});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: castle.position.dx - 40,
      top: castle.position.dy - 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 血條
          Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: castle.hp / castle.maxHp,
              child: Container(
                decoration: BoxDecoration(
                  color: castle.isPlayerCastle
                      ? Colors.blue.shade700
                      : Colors.red.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${castle.hp}/${castle.maxHp}',
            style: const TextStyle(
              fontFamily: 'Iansui',
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // 城堡圖標
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: castle.isPlayerCastle
                    ? [Colors.blue.shade400, Colors.blue.shade700]
                    : [Colors.red.shade400, Colors.red.shade700],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: castle.isPlayerCastle ? Colors.blue : Colors.red,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.castle,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                // 城堡標籤
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      castle.isPlayerCastle ? '我方' : '敵方',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Iansui',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
