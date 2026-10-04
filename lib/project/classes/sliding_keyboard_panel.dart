import 'package:flutter/material.dart';

/// Controls the amount keypad shown over the input form.
class PanelController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isPanelOpen => _isOpen;

  void open() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }
}

class SlidingUpPanel extends StatefulWidget {
  const SlidingUpPanel({
    super.key,
    required this.controller,
    required this.panel,
    required this.body,
    required this.maxHeight,
    this.minHeight = 0,
    this.parallaxEnabled = false,
    this.isDraggable = false,
    this.panelSnapping = true,
  });

  final PanelController controller;
  final Widget panel;
  final Widget body;
  final double maxHeight;
  final double minHeight;
  final bool parallaxEnabled;
  final bool isDraggable;
  final bool panelSnapping;

  @override
  State<SlidingUpPanel> createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void didUpdateWidget(SlidingUpPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.body,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          bottom: widget.controller.isPanelOpen
              ? 0
              : -(widget.maxHeight - widget.minHeight),
          height: widget.maxHeight,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            child: widget.panel,
          ),
        ),
      ],
    );
  }
}
