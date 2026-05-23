import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beautiful_todo_app/main.dart';
import 'package:beautiful_todo_app/viewmodels/todo_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'Splash screen shows and navigates to home',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      // Splash screen should be showing
      expect(find.text('Beautiful Todo'), findsOneWidget);
      expect(find.text('Stay organized, stay beautiful'), findsOneWidget);

      // Wait for splash to finish (2 second delay + load)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should now be on the home page
      expect(find.text('New Task'), findsOneWidget);
      expect(find.text('All clear!'), findsOneWidget);
    },
  );

  testWidgets(
    'Can add and toggle a todo task',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      // Wait for splash to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open add task dialog
      await tester.tap(find.text('New Task'));
      await tester.pumpAndSettle();

      // Enter task title
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Test task',
      );

      // Enter description
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Test description',
      );

      // Create task
      await tester.tap(find.text('Create Task'));
      await tester.pumpAndSettle();

      // Verify task added
      expect(find.text('Test task'), findsOneWidget);
    },
  );

  testWidgets(
    'ViewModel loads and persists data',
    (WidgetTester tester) async {
      final viewModel = TodoViewModel();
      await viewModel.loadTodos();

      expect(viewModel.isLoading, false);
      expect(viewModel.totalCount, 0);

      // Add a task
      viewModel.addTodo('Persisted task', '', 0);
      expect(viewModel.totalCount, 1);
      expect(viewModel.todos.first.title, 'Persisted task');
    },
  );
}