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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set initial transformation to show root node at top center
    final screenWidth = MediaQuery.of(context).size.width;
    _transformationController.value = Matrix4.identity()
      ..translate(screenWidth / 2 - 1000.0, 50.0);
  }

  void _centerOnRoot() {
    final screenWidth = MediaQuery.of(context).size.width;
    _transformationController.value = Matrix4.identity()
      ..translate(screenWidth / 2 - 1000.0, 50.0);
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
      color: Theme.of(context).colorScheme.background,
      child: Consumer<GraphProvider>(
        builder: (context, provider, child) {
          return InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 3.0,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: 2000,
              height: 2000,
              child: Stack(
                children: [

                  CustomPaint(
                    painter: GridPainter(),
                    size: const Size(2000, 2000),
                  ),

                  CustomPaint(
                    painter: EdgePainter(provider.getAllEdges()),
                    size: const Size(2000, 2000),
                  ),

                  ...provider.getAllNodes().map(
                    (node) => Positioned(
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
