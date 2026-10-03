import 'package:flutter/material.dart';
import 'data/words_repository.dart';
import 'models/flash_models.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EnglishCardsApp());
}

class EnglishCardsApp extends StatelessWidget {
  const EnglishCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF15151F),
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3B6FE0),
      ),
      home: FutureBuilder<List<WordCategory>>(
        future: loadCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: Color(0xFF15151F),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return HomeScreen(categories: snapshot.data!);
        },
      ),
    );
  }
}
