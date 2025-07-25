import 'package:flutter/material.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';

class DraggableText extends StatefulWidget {
  final TextElement textElement;
  final Function(TextElement) onUpdate;
  final VoidCallback onDelete;

  const DraggableText({
    super.key,
    required this.textElement,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  late TextElement _currentElement;
  bool _isSelected = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentElement = widget.textElement;
  }

  @override
  void didUpdateWidget(DraggableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textElement != widget.textElement) {
      _currentElement = widget.textElement;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentElement.x,
      top: _currentElement.y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });
        },
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _currentElement = _currentElement.copyWith(
              x: (_currentElement.x + details.delta.dx).clamp(0.0, double.infinity),
              y: (_currentElement.y + details.delta.dy).clamp(0.0, double.infinity),
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
          widget.onUpdate(_currentElement);
        },
        child: Container(
          decoration: BoxDecoration(
            border: _isSelected || _isDragging
                ? Border.all(color: Colors.blue, width: 2)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              // Text with outline
              Text(
                _currentElement.text,
                style: TextStyle(
                  fontSize: _currentElement.fontSize,
                  color: Color(int.parse(_currentElement.color)),
                  fontWeight: _getFontWeight(_currentElement.fontWeight),
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              if (_isSelected) ...[
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete();
                    },
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final newFontSize = _currentElement.fontSize + details.delta.dy;
                        _currentElement = _currentElement.copyWith(
                          fontSize: newFontSize.clamp(10.0, 100.0),
                        );
                      });
                      widget.onUpdate(_currentElement);
                    },
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.open_with,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  FontWeight _getFontWeight(String fontWeight) {
    switch (fontWeight) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      default:
        return FontWeight.normal;
    }
  }
}
