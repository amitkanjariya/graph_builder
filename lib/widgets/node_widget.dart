import 'package:flutter/material.dart';
import '../models/tree_node.dart';
import 'dart:math' as math;

class NodeWidget extends StatefulWidget {
  final TreeNode node;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NodeWidget({
    super.key,
    required this.node,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.node.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.node.isActive && !oldWidget.node.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.node.isActive && oldWidget.node.isActive) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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

  double _getNodeSize(int depth) {
    final baseSize = math.max(40.0, 65.0 - (depth * 3.0));
    return widget.node.isActive ? baseSize + 8 : baseSize;
  }



  @override
  Widget build(BuildContext context) {
    final size = _getNodeSize(widget.node.depth);
    final baseColor = _getDepthColor(widget.node.depth);
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return AnimatedScale(
          scale: widget.node.isActive
              ? _pulseAnimation.value
              : (_isHovered ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 200),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.node.isActive
                          ? const Color(0xFFD69E2E)
                          : baseColor,
                      border: Border.all(
                        color: widget.node.isActive
                            ? const Color(0xFF8B5A00)
                            : baseColor.withOpacity(0.3),
                        width: widget.node.isActive ? 4 : 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.node.label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: math.max(12.0, size * 0.25),
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.node.childCount > 0)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${widget.node.childCount}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: math.max(8.0, size * 0.15),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        if (widget.node.depth > 0 && !widget.node.isActive)
                          Positioned(
                            top: 3,
                            right: 3,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: baseColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: baseColor,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.node.depth}',
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                    color: baseColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (!widget.node.isRoot)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}