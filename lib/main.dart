import 'package:chat_bot_app/features/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat bot by Gemini',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
