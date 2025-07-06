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
            border: _isSelected || _isDragging ? Border.all(color: Colors.blue, width: 2) : null,
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
                        final newFontSize = _currentElement.size + details.delta.dy;
                        _currentElement = _currentElement.copyWith(
                          size: newFontSize.clamp(10.0, 100.0),
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
              ]
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
