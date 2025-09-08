# Graph Builder - Flutter Project Documentation

## Project Overview
Graph Builder is a Flutter application that allows users to create and navigate tree-like graphs with interactive nodes. Users can add child nodes, select active nodes, and delete nodes with their children.

## Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── tree_node.dart       # Node data model
├── providers/
│   └── graph_provider.dart  # State management
├── screens/
│   └── graph_screen.dart    # Main screen
└── widgets/
    ├── control_panel.dart   # Bottom control panel
    ├── edge_painter.dart    # Edge drawing logic
    ├── graph_canvas.dart    # Interactive canvas
    └── node_widget.dart     # Individual node widget
```

### Key Components

#### 1. TreeNode Model (`models/tree_node.dart`)
- Represents individual nodes in the graph
- Properties: id, label, position, children, parent, depth, isActive
- Methods: addChild(), removeChild(), getAllDescendants()

#### 2. GraphProvider (`providers/graph_provider.dart`)
- Manages application state using Provider pattern
- Handles node creation, deletion, and selection
- Calculates node positions using tree layout algorithm
- Features:
  - Automatic position calculation
  - Active node tracking
  - Maximum depth enforcement

#### 3. GraphCanvas (`widgets/graph_canvas.dart`)
- Interactive canvas with pan/zoom functionality
- Renders nodes and edges
- Handles user interactions (tap, pan, zoom)

#### 4. NodeWidget (`widgets/node_widget.dart`)
- Individual node visualization
- Features:
  - Color coding by depth
  - Pulsing animation for active nodes
  - Depth indicators
  - Child count badges
  - Delete buttons for non-root nodes

#### 5. EdgePainter (`widgets/edge_painter.dart`)
- Custom painter for drawing curved connections
- Creates smooth Bézier curves between parent-child nodes
- Color-coded edges matching node depth

#### 6. ControlPanel (`widgets/control_panel.dart`)
- Bottom panel with controls
- Shows active node information
- Add/Delete node buttons
- Maximum depth warnings

## User Interface

### Visual Design
- **Color Scheme**: Modern dark/light theme support
- **Node Colors**: Different colors for each depth level
- **Active Node**: Gold color with pulsing animation
- **Connections**: Curved lines with subtle shadows
- **Typography**: Clean, readable fonts

### Interactions
1. **Tap Node**: Select/activate a node
2. **Add Child**: Button in control panel (only when node selected)
3. **Delete Node**: Red X button on non-root nodes
4. **Pan/Zoom**: Touch gestures on canvas
5. **Reset**: Reset button in app bar

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### Running the App
```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd graph_builder

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Usage Instructions

### Basic Operations
1. **Start**: App opens with root node "1" active
2. **Add Child**: Tap "Add Child" button to add node "2" as child of "1"
3. **Select Node**: Tap any node to make it active (turns gold)
4. **Add More**: With node selected, tap "Add Child" to add children to that node
5. **Delete**: Tap red X on any non-root node to delete it and all children
6. **Navigate**: Pan and zoom the canvas to explore large graphs
7. **Reset**: Use reset button to clear all nodes except root

### Advanced Features
- **Depth Limit**: App prevents adding nodes beyond depth 100
- **Visual Feedback**: Active nodes pulse and show in gold color
- **Node Info**: Control panel shows active node details
- **Batch Delete**: Deleting a parent removes entire subtree

## Performance Considerations

### Optimizations Implemented
- Efficient tree traversal algorithms
- Minimal widget rebuilds using Provider
- Optimized painting for edges
- Lazy loading of visual elements
- Memory-efficient node storage

### Scalability
- Supports up to 100 depth levels
- Handles hundreds of nodes smoothly
- Responsive layout for different screen sizes
- Efficient position calculation algorithm

## Testing

### Manual Testing Checklist
- ✅ Root node creation
- ✅ Child node addition
- ✅ Node selection/activation
- ✅ Node deletion with children
- ✅ Visual hierarchy display
- ✅ Pan/zoom functionality
- ✅ Maximum depth handling
- ✅ Reset functionality
- ✅ UI responsiveness

## Technical Decisions

### Architecture Choices
- **Provider Pattern**: Chosen for simple, efficient state management
- **Custom Painting**: Used for smooth, curved edge rendering
- **Widget Composition**: Modular design for maintainability
- **Responsive Design**: Adapts to different screen sizes

### Performance Trade-offs
- Real-time position calculation vs. cached positions
- Smooth animations vs. battery efficiency
- Visual quality vs. rendering performance

## Conclusion

The Graph Builder successfully implements all required features with additional visual enhancements. The app provides an intuitive interface for creating and managing tree structures while maintaining good performance and user experience.

The modular architecture allows for easy extension and maintenance, making it suitable for future enhancements and scaling.
