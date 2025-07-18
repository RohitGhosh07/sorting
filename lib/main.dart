import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sorting_provider.dart';
import 'screens/sorting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SortingProvider(),
      child: MaterialApp(
        title: 'Sorting Visualizer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade300,
            secondary: Colors.blueGrey.shade400,
            surface: Colors.grey.shade900,
            background: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const SortingScreen(),
      ),
    );
  }
}


