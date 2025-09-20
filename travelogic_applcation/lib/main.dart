import 'package:flutter/material.dart';
import 'screens/travel_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '여행 기록 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF030213),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSans',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF030213),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSans',
      ),
      home: const TravelApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}