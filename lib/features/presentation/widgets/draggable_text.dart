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
              if (_isSelected)
                Positioned(
                  top: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete();
                    },
                    child: Container(
                      width: 24,
                      height: 24,
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
