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
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade600,
            secondary: Colors.blueGrey.shade300,
            surface: Colors.grey.shade50,
            background: Colors.white,
            onBackground: Colors.grey.shade900,
            onSurface: Colors.grey.shade900,
          ),
          scaffoldBackgroundColor: Colors.white,
          cardTheme: CardTheme.of(context).copyWith(
            color: Colors.white,
            elevation: 4,
            shadowColor: Colors.blue.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: Colors.blue.shade600,
            inactiveTrackColor: Colors.blue.shade100,
            thumbColor: Colors.blue.shade600,
            overlayColor: Colors.blue.shade100.withOpacity(0.3),
          ),
        ),
        home: const SortingScreen(),
      ),
    );
  }
}
