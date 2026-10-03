import 'package:flutter/material.dart';

class WordCard {
  final String word;
  final String transcription;
  final String translation;
  final String exampleEn;
  final String exampleRu;

  const WordCard({
    required this.word,
    required this.transcription,
    required this.translation,
    required this.exampleEn,
    required this.exampleRu,
  });

  factory WordCard.fromJson(Map<String, dynamic> json) {
    return WordCard(
      word: json['word'] as String,
      transcription: json['transcription'] as String,
      translation: json['translation'] as String,
      exampleEn: json['exampleEn'] as String,
      exampleRu: json['exampleRu'] as String,
    );
  }
}

class WordCategory {
  final String title;
  final List<Color> gradientColors;
  final List<WordCard> cards;

  const WordCategory({
    required this.title,
    required this.gradientColors,
    required this.cards,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      title: json['title'] as String,
      gradientColors: (json['gradientColors'] as List)
          .map((hex) => Color(int.parse((hex as String).replaceFirst('#', '0xFF'))))
          .toList(),
      cards: (json['cards'] as List)
          .map((c) => WordCard.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
