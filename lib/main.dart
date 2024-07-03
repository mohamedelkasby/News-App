import 'package:flutter/material.dart';
import 'package:news_app_ui_setup/screens/home_screen.dart';

void main() {
  runApp(const NewsApp());
  // NewsServices().getNewsLanguage("ar");
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
