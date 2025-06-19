import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App - Examen MDSIA/ISI 2025',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(
          toggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Thème clair
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue.shade600,
  scaffoldBackgroundColor: Colors.grey.shade50,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade600,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

// Thème sombre
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue.shade400,
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade800,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: CardTheme(
    elevation: 4,
    color: Colors.grey.shade800,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);