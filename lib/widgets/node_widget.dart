import 'package:flutter/material.dart';
import '../models/tree_node.dart';

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

  Color get _nodeColor {
    if (widget.node.isActive) {
      return const Color(0xFF8B5CF6); // Purple
    } else if (widget.node.isRoot) {
      return const Color(0xFF10B981); // Emerald
    } else {
      return const Color(0xFF3B82F6); // Blue
    }
  }

  Color get _nodeSecondaryColor {
    if (widget.node.isActive) {
      return const Color(0xFFA78BFA);
    } else if (widget.node.isRoot) {
      return const Color(0xFF34D399);
    } else {
      return const Color(0xFF60A5FA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return AnimatedScale(
          scale: widget.node.isActive
              ? _pulseAnimation.value
              : (_isHovered ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: widget.node.isActive ? 0.7 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: widget.onTap,
                onLongPress: widget.node.isRoot ? null : widget.onDelete,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_nodeColor, _nodeSecondaryColor],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _nodeColor.withOpacity(
                          widget.node.isActive ? 0.4 : 0.2,
                        ),
                        blurRadius: widget.node.isActive ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                      if (widget.node.isActive)
                        BoxShadow(
                          color: _nodeColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                    ],
                    border: widget.node.isActive
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.node.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.node.childCount > 0)
                        Text(
                          '(${widget.node.childCount})',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
