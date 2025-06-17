import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

late final ThemeMode themeMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ehaxphqcshwxgltovmjc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoYXhwaHFjc2h3eGdsdG92bWpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNjQ1ODYsImV4cCI6MjA2NTc0MDU4Nn0.bAXYap_8r-45sZqHfVua_I4cxQgOGqf7NMcwPlyvOls',
  );

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkTheme') ?? false;
  themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode currentTheme = themeMode;

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = currentTheme == ThemeMode.dark;
    await prefs.setBool('isDarkTheme', !isDark);
    setState(() {
      currentTheme = !isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme,
      home: LoginScreen(onToggleTheme: toggleTheme),
    );
  }
}

///denemeyorumsatiri
