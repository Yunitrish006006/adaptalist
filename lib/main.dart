import 'package:flutter/material.dart';
import 'screens/card_game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '卡牌遊戲',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'elffont',
        fontFamilyFallback: const ['Iansui'],
      ),
      home: const CardGameScreen(),
    );
  }
}
