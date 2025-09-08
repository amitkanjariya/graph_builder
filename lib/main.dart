import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/graph_provider.dart';
import 'screens/graph_screen.dart';

void main() {
  runApp(const GraphBuilderApp());
}

class GraphBuilderApp extends StatelessWidget {
  const GraphBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GraphProvider(),
      child: MaterialApp(
        title: 'Graph Builder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF22223B),
            secondary: Color(0xFF4A4E69),
            surface: Color(0xFFF2E9E4),
            background: Colors.white,
            error: Color(0xFFDC2626),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Color(0xFF22223B),
            onBackground: Color(0xFF22223B),
            onError: Colors.white,
            surfaceVariant: Color(0xFFC9ADA7),
            onSurfaceVariant: Color(0xFF4A4E69),
            outline: Color(0xFF9A8C98),
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        darkTheme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC9ADA7),
            secondary: Color(0xFF9A8C98),
            surface: Color(0xFF22223B),
            background: Color(0xFF1A1A2E),
            error: Color(0xFFEF4444),
            onPrimary: Color(0xFF22223B),
            onSecondary: Color(0xFF22223B),
            onSurface: Color(0xFFF2E9E4),
            onBackground: Color(0xFFF2E9E4),
            onError: Colors.white,
            surfaceVariant: Color(0xFF4A4E69),
            onSurfaceVariant: Color(0xFFC9ADA7),
            outline: Color(0xFF9A8C98),
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        themeMode: ThemeMode.system,
        home: const GraphScreen(),
      ),
    );
  }
}
