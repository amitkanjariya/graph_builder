import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/tree_node.dart';
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        home: const GraphScreen(),
      ),
    );
  }
}
