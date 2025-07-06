import 'package:flutter/material.dart';

class StickerPickerDialog extends StatelessWidget {
  final Function(String) onStickerSelected;

  const StickerPickerDialog({
    super.key,
    required this.onStickerSelected,
  });

  static const Map<String, String> _stickers = {
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
    'party': '🎉',
    'rocket': '🚀',
    'star': '⭐',
    'lightning': '⚡',
    'rainbow': '🌈',
    'sun': '☀️',
    'moon': '🌙',
    'cat': '😸',
    'dog': '🐶',
    'pizza': '🍕',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a Sticker'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          children: _stickers.entries.map((entry) {
            return GestureDetector(
              onTap: () {
                onStickerSelected(entry.key);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
