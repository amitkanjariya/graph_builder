import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/graph_provider.dart';
import '../widgets/graph_canvas.dart';
import '../widgets/control_panel.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Graph Builder',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        actions: [
          Consumer<GraphProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Graph'),
                      content: const Text(
                        'Are you sure you want to reset the graph? This will remove all nodes except the root.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            provider.resetGraph();
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset Graph',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: GraphCanvas()),
          ControlPanel(),
        ],
      ),
    );
  }
}
