import 'package:flutter/material.dart';
import '../models/tree_node.dart';
import 'dart:math' as math;

class EdgePainter extends CustomPainter {
  final List<({TreeNode parent, TreeNode child})> edges;

  EdgePainter(this.edges);

  Color _getDepthColor(int depth) {
    final colors = [
      const Color(0xFF2D3748),
      const Color(0xFF4A5568),
      const Color(0xFF718096),
      const Color(0xFF2B6CB0),
      const Color(0xFF2C7A7B),
      const Color(0xFF744210),
      const Color(0xFF742A2A),
    ];
    return colors[depth % colors.length];
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in edges) {
      final parentPos = edge.parent.position;
      final childPos = edge.child.position;
      final parentColor = _getDepthColor(edge.parent.depth);

      if ((childPos - parentPos).distance == 0) continue;

      final nodeRadius = 30.0;

      final startPoint = Offset(parentPos.dx, parentPos.dy + nodeRadius);
      final endPoint = Offset(childPos.dx, childPos.dy - nodeRadius);

      final path = _createCurvedPath(startPoint, endPoint);

      final shadowPaint = Paint()
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = Colors.black.withOpacity(0.1);
      canvas.drawPath(path, shadowPaint);

      final paint = Paint()
        ..color = edge.parent.isActive
            ? const Color(0xFFD69E2E)
            : parentColor.withOpacity(0.8)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, paint);
    }
  }

  Path _createCurvedPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final midY = start.dy + (end.dy - start.dy) * 0.6;
    final controlPoint = Offset(start.dx, midY);
    
    path.quadraticBezierTo(
      controlPoint.dx, controlPoint.dy,
      end.dx, end.dy,
    );
    
    return path;
  }



  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) {
    return edges != oldDelegate.edges;
  }
}

extension on Offset {
  Offset rotate(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Offset(dx * cos - dy * sin, dx * sin + dy * cos);
  }
}
