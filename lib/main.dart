import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/bible_provider.dart';
import 'screens/main_container.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BibleProvider()),
      ],
      child: const BibleTemeApp(),
    ),
  );
}

class BibleTemeApp extends StatelessWidget {
  const BibleTemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bíblia TEME',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Immersive Dark Navy layout
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0D1D),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF101426),
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme.apply(
            bodyColor: Colors.blueGrey[100],
            displayColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101426),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainContainer(),
    );
  }
}
