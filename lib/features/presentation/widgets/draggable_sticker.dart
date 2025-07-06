import 'package:flutter/material.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';

class DraggableSticker extends StatefulWidget {
  final StickerElement stickerElement;
  final Function(StickerElement) onUpdate;
  final VoidCallback onDelete;

  const DraggableSticker({
    super.key,
    required this.stickerElement,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DraggableSticker> createState() => _DraggineStickerState();
}

class _DraggineStickerState extends State<DraggableSticker> {
  late StickerElement _currentElement;
  bool _isSelected = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentElement = widget.stickerElement;
  }

  @override
  void didUpdateWidget(DraggableSticker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stickerElement != widget.stickerElement) {
      _currentElement = widget.stickerElement;
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
        onScaleStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            if (details.scale != 1.0) {
              _currentElement = _currentElement.copyWith(
                size: (_currentElement.size * details.scale).clamp(20.0, 200.0),
              );
            } else {
              _currentElement = _currentElement.copyWith(
                x: (_currentElement.x + details.focalPointDelta.dx).clamp(0.0, double.infinity),
                y: (_currentElement.y + details.focalPointDelta.dy).clamp(0.0, double.infinity),
              );
            }
          });
        },
        onScaleEnd: (details) {
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
              Text(
                _getStickerEmoji(_currentElement.stickerType),
                style: TextStyle(
                  fontSize: _currentElement.size,
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

  String _getStickerEmoji(String stickerType) {
    const stickerMap = {
      'laughing': '😂',
      'crying': '😭',
      'heart': '❤️',
      'fire': '🔥',
      'thumbs_up': '👍',
      'thumbs_down': '👎',
      'clap': '👏',
      'muscle': '💪',
      'mind_blown': '🤯',
      'skull': '💀',
    };
    
    return stickerMap[stickerType] ?? '😀';
  }
}
