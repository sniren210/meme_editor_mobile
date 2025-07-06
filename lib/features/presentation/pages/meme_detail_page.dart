import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';
import 'package:meme_editor_mobile/features/presentation/bloc/meme_edit_bloc.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/draggable_sticker.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/draggable_text.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/sticker_picker.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/text_editor_dialog.dart';

import 'package:meme_editor_mobile/injection_container.dart' as di;

class MemeDetailPage extends StatelessWidget {
  final Meme meme;

  const MemeDetailPage({super.key, required this.meme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MemeEditBloc>()..add(LoadMemeEditEvent(meme.id)),
      child: MemeDetailView(meme: meme),
    );
  }
}

class MemeDetailView extends StatefulWidget {
  final Meme meme;

  const MemeDetailView({super.key, required this.meme});

  @override
  State<MemeDetailView> createState() => _MemeDetailViewState();
}

class _MemeDetailViewState extends State<MemeDetailView> {
  final GlobalKey _memeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.meme.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<MemeEditBloc, MemeEditState>(
            builder: (context, state) {
              bool canUndo = false;
              bool canRedo = false;
              
              if (state is MemeEditLoaded) {
                canUndo = state.undoStack.isNotEmpty;
                canRedo = state.redoStack.isNotEmpty;
              }
              
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo_rounded),
                      onPressed: canUndo 
                          ? () => context.read<MemeEditBloc>().add(UndoEvent())
                          : null,
                      style: IconButton.styleFrom(
                        foregroundColor: canUndo 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo_rounded),
                      onPressed: canRedo 
                          ? () => context.read<MemeEditBloc>().add(RedoEvent())
                          : null,
                      style: IconButton.styleFrom(
                        foregroundColor: canRedo 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<MemeEditBloc, MemeEditState>(
        listener: (context, state) {
          if (state is MemeEditSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meme edit saved!')),
            );
          } else if (state is ImageSavedToGallery) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image saved to gallery: ${state.path}')),
            );
          } else if (state is ImageShared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image shared successfully!')),
            );
          } else if (state is MemeEditError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MemeEditLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is MemeEditError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          if (state is MemeEditLoaded || state is MemeEditSaved || 
              state is ImageSavedToGallery || state is ImageShared) {
            MemeEdit memeEdit;
            
            if (state is MemeEditLoaded) {
              memeEdit = state.memeEdit;
            } else if (state is MemeEditSaved) {
              memeEdit = state.memeEdit;
            } else {
              // For other states, we need to get the current meme edit
              return const Center(child: CircularProgressIndicator());
            }
            
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: RepaintBoundary(
                        key: _memeKey,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.meme.url,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  width: widget.meme.width.toDouble(),
                                  height: widget.meme.height.toDouble(),
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: widget.meme.width.toDouble(),
                                  height: widget.meme.height.toDouble(),
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Center(child: Icon(Icons.error)),
                                ),
                              ),
                              ...memeEdit.textElements.map((textElement) {
                                return DraggableText(
                                  textElement: textElement,
                                  onUpdate: (updatedElement) {
                                    context.read<MemeEditBloc>().add(
                                      UpdateTextElementEvent(updatedElement),
                                    );
                                  },
                                  onDelete: () {
                                    context.read<MemeEditBloc>().add(
                                      RemoveTextElementEvent(textElement.id),
                                    );
                                  },
                                );
                              }),
                              ...memeEdit.stickerElements.map((stickerElement) {
                                return DraggableSticker(
                                  stickerElement: stickerElement,
                                  onUpdate: (updatedElement) {
                                    context.read<MemeEditBloc>().add(
                                      UpdateStickerElementEvent(updatedElement),
                                    );
                                  },
                                  onDelete: () {
                                    context.read<MemeEditBloc>().add(
                                      RemoveStickerElementEvent(stickerElement.id),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle indicator
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              context,
                              icon: Icons.text_fields_rounded,
                              label: 'Add Text',
                              onPressed: () => _showTextEditor(context),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            _buildActionButton(
                              context,
                              icon: Icons.emoji_emotions_rounded,
                              label: 'Stickers',
                              onPressed: () => _showStickerPicker(context),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            _buildActionButton(
                              context,
                              icon: Icons.save_alt_rounded,
                              label: 'Save',
                              onPressed: () => _saveToGallery(context),
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            _buildActionButton(
                              context,
                              icon: Icons.share_rounded,
                              label: 'Share',
                              onPressed: () => _shareImage(context),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          
          return const Center(child: Text('No data'));
        },
      ),
    );
  }

  void _showTextEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => TextEditorDialog(
        onSave: (text, color, fontSize, fontWeight) {
          final textElement = TextElement(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: text,
            x: 50 + Random().nextInt(100).toDouble(),
            y: 50 + Random().nextInt(100).toDouble(),
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          );
          
          context.read<MemeEditBloc>().add(AddTextElementEvent(textElement));
        },
      ),
    );
  }

  void _showStickerPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => StickerPickerDialog(
        onStickerSelected: (stickerType) {
          final stickerElement = StickerElement(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            stickerType: stickerType,
            x: 50 + Random().nextInt(100).toDouble(),
            y: 50 + Random().nextInt(100).toDouble(),
            size: 50,
          );
          
          context.read<MemeEditBloc>().add(AddStickerElementEvent(stickerElement));
        },
      ),
    );
  }

  void _saveToGallery(BuildContext context) {
    // This would require implementing image rendering functionality
    // For now, we'll just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Save to gallery functionality would be implemented here')),
    );
  }

  void _shareImage(BuildContext context) {
    // This would require implementing image rendering functionality
    // For now, we'll just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            style: IconButton.styleFrom(
              foregroundColor: color,
              backgroundColor: color.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
