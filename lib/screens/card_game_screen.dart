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
      id: 5,
      name: 'ㄌㄧㄤˋㄧㄐㄧㄚˋ', //晾衣架
      power: 5,
      color: Colors.grey,
      type: CardType.physic,
      cost: ResourceCost(stamina: 2, spirit: 1),
      imagePath: 'assets/items/hanger.png',
      imageRotation: 45,
    ),
    CardData(
      id: 6,
      name: 'ㄞˋㄉㄜ˙ㄒㄧㄠˇㄕㄡˇ', //愛的小手
      power: 0,
      color: Colors.cyan,
      type: CardType.physic,
      cost: ResourceCost(stamina: 1, money: 50),
      imagePath: 'assets/items/love_paddle.png',
    ),
    CardData(
      id: 7,
      name: 'ㄊㄥˊㄊㄧㄠˊ', //藤條
      power: 7,
      color: Colors.brown,
      type: CardType.physic,
      cost: ResourceCost(stamina: 3, spirit: 2),
      imagePath: 'assets/items/rattan.png',
    ),
  ];

  // 手牌（最多4張）
  late List<CardData> _handCards;

  // 場上的單位
  final List<Unit> _units = [];

  // 資源系統
  int _stamina = 5; // 體力
  final int _maxStamina = 10;
  int _spirit = 5; // 精神力
  final int _maxSpirit = 10;
  int _money = 100; // 金錢
  Timer? _resourceTimer;
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
    _startResourceTimer();
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
    _resourceTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startResourceTimer() {
    _resourceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // 體力和精神力每秒恢復1
        if (_stamina < _maxStamina) _stamina++;
        if (_spirit < _maxSpirit) _spirit++;
      });
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
      final direction = unit.isPlayerUnit ? -1.0 : 1.0;

      // 使用單位自己的速度
      final newY = unit.position.dy + (unit.speed * direction);

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

      _units[i] = unit.copyWith(position: Offset(unit.position.dx, clampedY));
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
        title: Text(message),
        content: const Text(
          '要重新開始遊戲嗎？',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('重新開始'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _units.clear();
      _stamina = 5;
      _spirit = 5;
      _money = 100;
      _handCards = _drawRandomCards(4);
      _initCastles();
    });
    _startGameTimer();
  }

  // 檢查資源是否足夠
  bool _canAfford(ResourceCost cost) {
    return _stamina >= cost.stamina &&
        _spirit >= cost.spirit &&
        _money >= cost.money;
  }

  // 資源費用文字
  String _getCostText(ResourceCost cost) {
    final parts = <String>[];
    if (cost.stamina > 0) parts.add('體力${cost.stamina}');
    if (cost.spirit > 0) parts.add('精神${cost.spirit}');
    if (cost.money > 0) parts.add('金錢${cost.money}');
    return parts.join(' ');
  }

  void _summonUnit(Offset position, CardData card) {
    // 檢查資源是否足夠
    if (!_canAfford(card.cost)) {
      _showMessage('資源不足！需要 ${_getCostText(card.cost)}');
      return;
    }

    // 只能在己方區域召喚（下半場）
    if (_fieldSize != Size.zero && position.dy < _fieldSize.height * 0.5) {
      _showMessage('只能在己方區域召喚單位！');
      return;
    }

    // 扣除資源
    setState(() {
      _stamina -= card.cost.stamina;
      _spirit -= card.cost.spirit;
      _money -= card.cost.money;

      // 召喚單位
      final unit = Unit(
        id: 'unit_${_unitIdCounter++}',
        name: card.name,
        position: position,
        color: card.color,
        icon: card.icon ?? Icons.help,
        hp: card.power * 10,
        maxHp: card.power * 10,
        power: card.power,
        isPlayerUnit: true,
        imagePath: card.imagePath,
        imageRotation: card.imageRotation,
        speed: card.speed,
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
          '鬼島亂鬥',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: ResourceBar(
                stamina: _stamina,
                maxStamina: _maxStamina,
                spirit: _spirit,
                maxSpirit: _maxSpirit,
                money: _money,
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
                          position: Offset(constraints.maxWidth / 2, 60),
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
            height: 310,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '單位: ${_units.length}',
                      style: const TextStyle(
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
                      final canAfford = _canAfford(card.cost);
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
