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
        onPanUpdate: (details) {
          setState(() {
            _currentElement = _currentElement.copyWith(
              x: (_currentElement.x + details.delta.dx).clamp(0.0, double.infinity),
              y: (_currentElement.y + details.delta.dy).clamp(0.0, double.infinity),
            );
          });
        },
        onPanEnd: (details) {
          widget.onUpdate(_currentElement);
        },
        onScaleUpdate: (details) {
          if (details.scale != 1.0) {
            setState(() {
              _currentElement = _currentElement.copyWith(
                size: (_currentElement.size * details.scale).clamp(20.0, 200.0),
              );
            });
          }
        },
        onScaleEnd: (details) {
          widget.onUpdate(_currentElement);
        },
        child: Container(
          decoration: BoxDecoration(
            border: _isSelected 
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
