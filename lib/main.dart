import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as dependencyInjection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.light(),
      ),
      home: NumberTriviaPage(),
    );
  }
}
