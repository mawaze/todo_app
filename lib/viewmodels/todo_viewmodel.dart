import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beautiful_todo_app/models/todo_item.dart';
import 'package:beautiful_todo_app/models/todo_filter.dart';

class TodoViewModel extends ChangeNotifier {
  List<TodoItem> _todos = [];
  TodoFilter _selectedFilter = TodoFilter.all;
  bool _isLoading = true;

  static const String _storageKey = 'todos';

  List<TodoItem> get todos => _todos;
  TodoFilter get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.isDone).length;
  int get activeCount => _todos.length - completedCount;
  double get completionRate => _todos.isEmpty ? 0.0 : completedCount / _todos.length;

  List<TodoItem> get filteredTodos {
    switch (_selectedFilter) {
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isDone).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  Future<void> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _todos = jsonList.map((item) => TodoItem.fromJson(item)).toList();
      } else {
        // No saved data — start with empty list (only user-added data)
        _todos = [];
      }
      _isLoading = false;
      notifyListeners();
    } catch (_) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_todos.map((t) => t.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {
      // Silently fail — no need to crash the app
    }
  }

  void addTodo(String title, String description, int categoryIndex) {
    _todos.insert(
      0,
      TodoItem(
        title: title,
        description: description,
        categoryIndex: categoryIndex,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    notifyListeners();
    _saveTodos();
  }

  void toggleTodo(TodoItem todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();
    _saveTodos();
  }

  void deleteTodo(TodoItem todo) {
    _todos.remove(todo);
    notifyListeners();
    _saveTodos();
  }

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.isDone);
    notifyListeners();
    _saveTodos();
  }

  void setFilter(TodoFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
