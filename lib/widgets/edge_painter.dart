import 'package:flutter/material.dart';
import '../models/tree_node.dart';
import 'dart:math' as math;

class EdgePainter extends CustomPainter {
  final List<({TreeNode parent, TreeNode child})> edges;

  EdgePainter(this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black.withOpacity(0.1);

    for (final edge in edges) {
      final parentPos = edge.parent.position;
      final childPos = edge.child.position;

      // Calculate connection points (edge of circles)
      final direction = (childPos - parentPos);
      final distance = direction.distance;

      if (distance == 0) continue;

      final normalizedDirection = direction / distance;
      const nodeRadius = 30.0;

      final startPoint = parentPos + (normalizedDirection * nodeRadius);
      final endPoint = childPos - (normalizedDirection * nodeRadius);

      // Create a curved path
      final controlPoint1 = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) * 0.3,
        startPoint.dy + (endPoint.dy - startPoint.dy) * 0.1,
      );
      final controlPoint2 = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) * 0.7,
        startPoint.dy + (endPoint.dy - startPoint.dy) * 0.9,
      );

      final path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

      // Draw shadow
      canvas.drawPath(path, shadowPaint);

      // Set gradient colors based on parent node state
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: edge.parent.isActive
            ? [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)]
            : edge.parent.isRoot
            ? [const Color(0xFF10B981), const Color(0xFF34D399)]
            : [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
      );

      paint.shader = gradient.createShader(
        Rect.fromPoints(startPoint, endPoint),
      );

      // Draw main line
      canvas.drawPath(path, paint);

      // Draw arrowhead
      _drawArrowHead(canvas, paint, endPoint, normalizedDirection);
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Paint paint,
    Offset point,
    Offset direction,
  ) {
    const arrowLength = 12.0;
    const arrowAngle = 0.5; // radians

    final arrowPoint1 = point - (direction * arrowLength).rotate(arrowAngle);
    final arrowPoint2 = point - (direction * arrowLength).rotate(-arrowAngle);

    final arrowPath = Path();
    arrowPath.moveTo(point.dx, point.dy);
    arrowPath.lineTo(arrowPoint1.dx, arrowPoint1.dy);
    arrowPath.moveTo(point.dx, point.dy);
    arrowPath.lineTo(arrowPoint2.dx, arrowPoint2.dy);

    paint.style = PaintingStyle.stroke;
    canvas.drawPath(arrowPath, paint);
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
