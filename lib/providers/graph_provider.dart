import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tree_node.dart';

class GraphProvider extends ChangeNotifier {
  TreeNode? _rootNode;
  TreeNode? _activeNode;
  TreeNode? _animatingNode;
  int _nextId = 1;
  final int _maxDepth = 100;
  Map<int, Offset> _targetPositions = {};
  bool _isAnimating = false;

  TreeNode? get rootNode => _rootNode;
  TreeNode? get activeNode => _activeNode;
  int get maxDepth => _maxDepth;

  GraphProvider() {
    _initializeGraph();
  }

  void _initializeGraph([BuildContext? context]) {
    _rootNode = TreeNode(
      id: _nextId++,
      label: "1",
      position: const Offset(200, 100),
      isActive: true,
    );
    _activeNode = _rootNode;
    _calculatePositions(context);
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
      node.children.clear();
      _calculatePositions();
      animateToTargetPositions();
      return;
    }

    _animatingNode = node;
    notifyListeners();

    if (node == _activeNode) {
      setActiveNode(node.parent!);
    } else if (node.getAllDescendants().contains(_activeNode)) {
      setActiveNode(node.parent!);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      node.removeFromParent();
      _animatingNode = null;
      _calculatePositions();
      animateToTargetPositions();
    });
  }

  void _calculatePositions([BuildContext? context]) {
    if (_rootNode == null) return;

    const double verticalSpacing = 150.0;
    const double minHorizontalSpacing = 45.0;
    const double nodeRadius = 30.0;

    double rootX = 1000.0;
    if (context != null) {
      final screenWidth = MediaQuery.of(context).size.width;
      rootX = screenWidth / 2;
    }


    _positionNodeWithSpacing(_rootNode!, rootX, 100.0, verticalSpacing, minHorizontalSpacing, nodeRadius);

    _storeTargetPositions(_rootNode!);
  }

  void _positionNodeWithSpacing(TreeNode node, double x, double y, double vSpacing, double minHSpacing, double nodeRadius) {
    node.position = Offset(x, y);

    if (node.children.isEmpty) return;


    List<double> subtreeWidths = [];
    for (TreeNode child in node.children) {
      subtreeWidths.add(_calculateSubtreeWidth(child, minHSpacing, nodeRadius));
    }


    double totalWidth = subtreeWidths.fold(0.0, (sum, width) => sum + width);
    if (node.children.length > 1) {
      totalWidth += (node.children.length - 1) * minHSpacing;
    }


    double startX = x - totalWidth / 2;
    double currentX = startX;

    for (int i = 0; i < node.children.length; i++) {
      TreeNode child = node.children[i];
      double childX = currentX + subtreeWidths[i] / 2;
      double childY = y + vSpacing;

      _positionNodeWithSpacing(child, childX, childY, vSpacing, minHSpacing, nodeRadius);
      currentX += subtreeWidths[i] + minHSpacing;
    }
  }

  double _calculateSubtreeWidth(TreeNode node, double minHSpacing, double nodeRadius) {
    if (node.children.isEmpty) {
      return nodeRadius * 2;
    }

    double totalChildWidth = 0;
    for (TreeNode child in node.children) {
      totalChildWidth += _calculateSubtreeWidth(child, minHSpacing, nodeRadius);
    }

    if (node.children.length > 1) {
      totalChildWidth += (node.children.length - 1) * minHSpacing;
    }

    return totalChildWidth.clamp(nodeRadius * 2, double.infinity);
  }

  void _storeTargetPositions(TreeNode node) {
    _targetPositions[node.id] = node.position;
    for (TreeNode child in node.children) {
      _storeTargetPositions(child);
    }
  }

  void animateToTargetPositions() {
    if (_isAnimating) return;
    _isAnimating = true;
    
    Map<int, Offset> startPositions = {};
    for (TreeNode node in getAllNodes()) {
      startPositions[node.id] = node.position;
    }

    const duration = Duration(milliseconds: 500);
    const steps = 30;
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);
    
    int currentStep = 0;
    
    void animateStep() {
      if (currentStep >= steps) {
        _isAnimating = false;
        return;
      }
      
      double progress = currentStep / (steps - 1);
      progress = Curves.easeOut.transform(progress);
      
      for (TreeNode node in getAllNodes()) {
        Offset start = startPositions[node.id] ?? node.position;
        Offset target = _targetPositions[node.id] ?? node.position;
        node.position = Offset.lerp(start, target, progress) ?? node.position;
      }
      
      notifyListeners();
      currentStep++;
      
      Future.delayed(stepDuration, animateStep);
    }
    
    animateStep();
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

  void resetGraph([BuildContext? context]) {
    _nextId = 1;
    _initializeGraph(context);
  }


}
