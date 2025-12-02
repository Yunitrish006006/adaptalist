import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../models/unit.dart';
import '../models/castle.dart';
import '../widgets/game_card.dart';
import '../widgets/battle_field.dart';
import '../widgets/elixir_bar.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({super.key});

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen> {
  final _random = Random();

  // 卡牌庫
  final List<CardData> _deck = [
    CardData(
      id: 1,
      name: '哥布林',
      power: 3,
      color: Colors.green,
      type: CardType.unit,
      cost: 2,
      icon: Icons.person,
    ),
    CardData(
      id: 2,
      name: '騎士',
      power: 6,
      color: Colors.blue,
      type: CardType.unit,
      cost: 3,
      icon: Icons.shield,
    ),
    CardData(
      id: 3,
      name: '弓箭手',
      power: 4,
      color: Colors.orange,
      type: CardType.unit,
      cost: 3,
      icon: Icons.sports_martial_arts,
    ),
    CardData(
      id: 4,
      name: 'ㄐㄩˋㄖㄣˊ ',
      power: 9,
      color: Colors.brown,
      type: CardType.unit,
      cost: 5,
      icon: Icons.fitness_center,
    ),
  ];

  // 手牌（最多4張）
  late List<CardData> _handCards;

  // 場上的單位
  final List<Unit> _units = [];

  // 聖水系統
  int _currentElixir = 5;
  final int _maxElixir = 10;
  Timer? _elixirTimer;
  Timer? _gameTimer;

  int _unitIdCounter = 0;

  // 城堡
  late Castle _playerCastle;
  late Castle _enemyCastle;

  // 場地尺寸
  Size _fieldSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // 隨機初始化手牌
    _handCards = _drawRandomCards(4);
    // 初始化城堡
    _initCastles();
    // 啟動計時器
    _startElixirTimer();
    _startGameTimer();
  }

  void _initCastles() {
    _playerCastle = Castle(
      id: 'player_castle',
      isPlayerCastle: true,
      hp: 1000,
      maxHp: 1000,
      position: const Offset(0, 0), // 將在 build 時更新
    );
    _enemyCastle = Castle(
      id: 'enemy_castle',
      isPlayerCastle: false,
      hp: 1000,
      maxHp: 1000,
      position: const Offset(0, 0), // 將在 build 時更新
    );
  }

  List<CardData> _drawRandomCards(int count) {
    final shuffled = List<CardData>.from(_deck)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  @override
  void dispose() {
    _elixirTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startElixirTimer() {
    _elixirTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentElixir < _maxElixir) {
        setState(() {
          _currentElixir++;
        });
      }
    });
  }

  void _startGameTimer() {
    // 遊戲主循環：移動單位
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;

      setState(() {
        _moveUnits();
        _checkGameOver();
      });
    });
  }

  void _moveUnits() {
    if (_fieldSize == Size.zero) return;

    // 使用倒序遍歷，避免移除元素時索引錯亂
    for (int i = _units.length - 1; i >= 0; i--) {
      final unit = _units[i];
      
      // 計算移動方向（我方單位向上移動，敵方向下）
      final moveSpeed = 2.0;
      final direction = unit.isPlayerUnit ? -1.0 : 1.0;
      
      // 更新位置
      final newY = unit.position.dy + (moveSpeed * direction);
      
      // 檢查是否到達城堡
      if (unit.isPlayerUnit && newY < 100) {
        // 我方單位攻擊敵方城堡
        _enemyCastle.takeDamage(unit.power);
        _units.removeAt(i);
        continue;
      } else if (!unit.isPlayerUnit && newY > _fieldSize.height - 100) {
        // 敵方單位攻擊我方城堡
        _playerCastle.takeDamage(unit.power);
        _units.removeAt(i);
        continue;
      }
      
      // 確保單位不會超出邊界
      final clampedY = newY.clamp(30.0, _fieldSize.height - 30.0);
      
      _units[i] = unit.copyWith(
        position: Offset(unit.position.dx, clampedY),
      );
    }
  }

  void _checkGameOver() {
    if (_playerCastle.isDestroyed) {
      _gameTimer?.cancel();
      _showGameOverDialog('敵方勝利！');
    } else if (_enemyCastle.isDestroyed) {
      _gameTimer?.cancel();
      _showGameOverDialog('你贏了！');
    }
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message, style: const TextStyle(fontFamily: 'Iansui')),
        content: const Text(
          '要重新開始遊戲嗎？',
          style: TextStyle(fontFamily: 'Iansui'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('重新開始', style: TextStyle(fontFamily: 'Iansui')),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _units.clear();
      _currentElixir = 5;
      _handCards = _drawRandomCards(4);
      _initCastles();
    });
    _startGameTimer();
  }

  void _summonUnit(Offset position, CardData card) {
    // 檢查聖水是否足夠
    if (_currentElixir < card.cost) {
      _showMessage('聖水不足！需要 ${card.cost} 聖水');
      return;
    }

    // 只能在己方區域召喚（下半場）
    if (_fieldSize != Size.zero && position.dy < _fieldSize.height * 0.5) {
      _showMessage('只能在己方區域召喚單位！');
      return;
    }

    // 扣除聖水
    setState(() {
      _currentElixir -= card.cost;

      // 召喚單位
      final unit = Unit(
        id: 'unit_${_unitIdCounter++}',
        name: card.name,
        position: position,
        color: card.color,
        icon: card.icon,
        hp: card.power * 10,
        maxHp: card.power * 10,
        power: card.power,
        isPlayerUnit: true,
      );

      _units.add(unit);

      // 從手牌移除並補充新卡
      _handCards.remove(card);
      if (_handCards.length < 4 && _deck.isNotEmpty) {
        _handCards.add(_deck[_random.nextInt(_deck.length)]);
      }
    });

    _showMessage('召喚了 ${card.name}！');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          '皇室戰爭',
          style: TextStyle(fontFamily: 'Iansui', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: ElixirBar(
                currentElixir: _currentElixir,
                maxElixir: _maxElixir,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 戰鬥場地
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 更新場地尺寸
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_fieldSize != constraints.biggest) {
                      setState(() {
                        _fieldSize = constraints.biggest;
                        // 更新城堡位置
                        _playerCastle = Castle(
                          id: _playerCastle.id,
                          isPlayerCastle: true,
                          hp: _playerCastle.hp,
                          maxHp: _playerCastle.maxHp,
                          position: Offset(
                            constraints.maxWidth / 2,
                            constraints.maxHeight - 60,
                          ),
                        );
                        _enemyCastle = Castle(
                          id: _enemyCastle.id,
                          isPlayerCastle: false,
                          hp: _enemyCastle.hp,
                          maxHp: _enemyCastle.maxHp,
                          position: Offset(
                            constraints.maxWidth / 2,
                            60,
                          ),
                        );
                      });
                    }
                  });

                  return BattleField(
                    units: _units,
                    playerCastle: _playerCastle,
                    enemyCastle: _enemyCastle,
                    onCardDropped: _summonUnit,
                  );
                },
              ),
            ),
          ),

          // 手牌區域
          Container(
            height: 180,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border(
                top: BorderSide(color: Colors.amber.shade700, width: 3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '手牌',
                      style: TextStyle(
                        fontFamily: 'Iansui',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '單位: ${_units.length}',
                      style: const TextStyle(
                        fontFamily: 'Iansui',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _handCards.map((card) {
                      final canAfford = _currentElixir >= card.cost;
                      return GameCard(
                        card: card,
                        isDraggable: true,
                        canAfford: canAfford,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGame,
        backgroundColor: Colors.red,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
