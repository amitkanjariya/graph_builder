import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/graph_provider.dart';
import '../models/tree_node.dart';
import 'node_widget.dart';
import 'edge_painter.dart';

class GraphCanvas extends StatefulWidget {
  const GraphCanvas({super.key});

  @override
  State<GraphCanvas> createState() => _GraphCanvasState();
}

class _GraphCanvasState extends State<GraphCanvas>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FAFC),
            Colors.blue.shade50.withOpacity(0.3),
          ],
        ),
      ),
      child: Consumer<GraphProvider>(
        builder: (context, provider, child) {
          return InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 3.0,
            constrained: false,
            child: SizedBox(
              width: 2000,
              height: 2000,
              child: Stack(
                children: [
                  // Background grid (subtle)
                  CustomPaint(
                    painter: GridPainter(),
                    size: const Size(2000, 2000),
                  ),
                  // Edges
                  CustomPaint(
                    painter: EdgePainter(provider.getAllEdges()),
                    size: const Size(2000, 2000),
                  ),
                  // Nodes
                  ...provider.getAllNodes().map(
                    (node) => AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      left: node.position.dx - 30,
                      top: node.position.dy - 30,
                      child: NodeWidget(
                        node: node,
                        onTap: () => provider.setActiveNode(node),
                        onDelete: () => provider.deleteNode(node),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 0.5;

    const gridSize = 50.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
