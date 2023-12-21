import 'package:flutter/material.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as ic;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color.fromARGB(255, 14, 65, 16),
            primarySwatch: Colors.green),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
