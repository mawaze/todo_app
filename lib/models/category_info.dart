import 'package:flutter/material.dart';

class CategoryInfo {
  const CategoryInfo({
    required this.emoji,
    required this.color,
    required this.name,
  });

  final String emoji;
  final Color color;
  final String name;
}

const List<CategoryInfo> categories = [
  CategoryInfo(emoji: '🎯', color: Color(0xFFFF6B6B), name: 'Urgent'),
  CategoryInfo(emoji: '💪', color: Color(0xFF1B998B), name: 'Health'),
  CategoryInfo(emoji: '📚', color: Color(0xFFF4A261), name: 'Learning'),
  CategoryInfo(emoji: '💻', color: Color(0xFF6C5CE7), name: 'Work'),
  CategoryInfo(emoji: '🎨', color: Color(0xFFE479C0), name: 'Creative'),
  CategoryInfo(emoji: '🌿', color: Color(0xFF2A9D8F), name: 'Personal'),
  CategoryInfo(emoji: '☕', color: Color(0xFFE76F51), name: 'Break'),
  CategoryInfo(emoji: '💡', color: Color(0xFFFFD166), name: 'Idea'),
];
