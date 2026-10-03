import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/flash_models.dart';

Future<List<WordCategory>> loadCategories() async {
  final String raw = await rootBundle.loadString('assets/data/words.json');
  final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
  return data.map((item) => WordCategory.fromJson(item as Map<String, dynamic>)).toList();
}
