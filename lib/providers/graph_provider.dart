import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tree_node.dart';

class GraphProvider extends ChangeNotifier {
  TreeNode? _rootNode;
  TreeNode? _activeNode;
  TreeNode? _animatingNode;
  int _nextId = 1;
  final int _maxDepth = 100;

  TreeNode? get rootNode => _rootNode;
  TreeNode? get activeNode => _activeNode;
  int get maxDepth => _maxDepth;

  GraphProvider() {
    _initializeGraph();
  }

  void _initializeGraph() {
    _rootNode = TreeNode(
      id: _nextId++,
      label: "1",
      position: const Offset(200, 100),
      isActive: true,
    );
    _activeNode = _rootNode;
    _calculatePositions();
    notifyListeners();
  }

  void setActiveNode(TreeNode node) {
    if (_activeNode != null) {
      _activeNode!.isActive = false;
    }
    _activeNode = node;
    _activeNode!.isActive = true;
    notifyListeners();
  }

  void addChildToActive() {
    if (_activeNode == null) return;

    // Check max depth constraint
    if (_activeNode!.depth >= _maxDepth - 1) {
      debugPrint('Maximum depth reached. Cannot add more nodes.');
      return;
    }

    TreeNode newNode = TreeNode(id: _nextId++, label: _nextId.toString());

    _activeNode!.addChild(newNode);
    _calculatePositions();
    notifyListeners();
  }

  void deleteNode(TreeNode node) {
    if (node.isRoot) {
      // Cannot delete root node, but we can clear its children
      node.children.clear();
      _calculatePositions();
      notifyListeners();
      return;
    }

    // Set the node as animating before deletion
    _animatingNode = node;
    notifyListeners();

    // If deleting the active node, set parent as active
    if (node == _activeNode) {
      setActiveNode(node.parent!);
    } else if (node.getAllDescendants().contains(_activeNode)) {
      // If active node is a descendant of the node being deleted
      setActiveNode(node.parent!);
    }

    // Delay the actual deletion to show animation
    Future.delayed(const Duration(milliseconds: 300), () {
      node.removeFromParent();
      _animatingNode = null;
      _calculatePositions();
      notifyListeners();
    });
  }

  void _calculatePositions() {
    if (_rootNode == null) return;

    const double verticalSpacing = 120.0;
    const double horizontalSpacing = 80.0;

    _positionNode(_rootNode!, 200.0, 100.0, horizontalSpacing, verticalSpacing);
  }

  void _positionNode(
    TreeNode node,
    double x,
    double y,
    double hSpacing,
    double vSpacing,
  ) {
    node.position = Offset(x, y);

    if (node.children.isEmpty) return;

    double totalWidth = (node.children.length - 1) * hSpacing;
    double startX = x - totalWidth / 2;

    for (int i = 0; i < node.children.length; i++) {
      double childX = startX + (i * hSpacing);
      double childY = y + vSpacing;

      _positionNode(node.children[i], childX, childY, hSpacing * 0.8, vSpacing);
    }
  }

  List<TreeNode> getAllNodes() {
    if (_rootNode == null) return [];
    return [_rootNode!, ..._rootNode!.getAllDescendants()];
  }

  List<({TreeNode parent, TreeNode child})> getAllEdges() {
    List<({TreeNode parent, TreeNode child})> edges = [];

    void collectEdges(TreeNode node) {
      for (TreeNode child in node.children) {
        edges.add((parent: node, child: child));
        collectEdges(child);
      }
    }

    if (_rootNode != null) {
      collectEdges(_rootNode!);
    }

    return edges;
  }

  void resetGraph() {
    _nextId = 1;
    _initializeGraph();
  }
}
