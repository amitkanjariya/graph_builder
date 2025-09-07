import 'package:flutter/material.dart';

class TreeNode {
  final int id;
  final String label;
  TreeNode? parent;
  List<TreeNode> children;
  Offset position;
  bool isActive;

  TreeNode({
    required this.id,
    required this.label,
    this.parent,
    List<TreeNode>? children,
    this.position = Offset.zero,
    this.isActive = false,
  }) : children = children ?? [];

  void addChild(TreeNode child) {
    child.parent = this;
    children.add(child);
  }

  void removeChild(TreeNode child) {
    children.remove(child);
    child.parent = null;
  }

  void removeFromParent() {
    parent?.removeChild(this);
  }

  int get depth {
    int d = 0;
    TreeNode? current = parent;
    while (current != null) {
      d++;
      current = current.parent;
    }
    return d;
  }

  int get childCount => children.length;

  bool get isRoot => parent == null;

  bool get isLeaf => children.isEmpty;

  List<TreeNode> getAllDescendants() {
    List<TreeNode> descendants = [];
    for (TreeNode child in children) {
      descendants.add(child);
      descendants.addAll(child.getAllDescendants());
    }
    return descendants;
  }

  TreeNode? findNodeById(int id) {
    if (this.id == id) return this;

    for (TreeNode child in children) {
      TreeNode? found = child.findNodeById(id);
      if (found != null) return found;
    }

    return null;
  }

  @override
  String toString() {
    return 'TreeNode(id: $id, label: $label, children: ${children.length})';
  }
}
