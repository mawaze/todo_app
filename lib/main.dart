import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beautiful_todo_app/viewmodels/todo_viewmodel.dart';
import 'package:beautiful_todo_app/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beautiful Todo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F4C5C),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
