import 'package:beautiful_todo_app/models/category_info.dart';

class TodoItem {
  TodoItem({
    required this.title,
    required this.description,
    required this.categoryIndex,
    this.isDone = false,
    this.createdAt = '',
  });

  final String title;
  final String description;
  final int categoryIndex;
  bool isDone;
  final String createdAt;

  CategoryInfo get categoryInfo => categories[categoryIndex % categories.length];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'categoryIndex': categoryIndex,
        'isDone': isDone,
        'createdAt': createdAt,
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        categoryIndex: json['categoryIndex'] as int? ?? 0,
        isDone: json['isDone'] as bool? ?? false,
        createdAt: json['createdAt'] as String? ?? '',
      );
}
