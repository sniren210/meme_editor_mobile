import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meme_editor_mobile/core/theme/app_theme_extensions.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';
import 'package:meme_editor_mobile/features/presentation/bloc/meme_edit_bloc.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/draggable_sticker.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/draggable_text.dart';

import 'package:meme_editor_mobile/injection_container.dart' as di;

class MemeExportPage extends StatelessWidget {
  final Meme meme;
  final MemeEdit memeEdit;

  const MemeExportPage({
    super.key,
    required this.meme,
    required this.memeEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MemeEditBloc>()..add(LoadMemeEditEvent(meme.id)),
      child: MemeExportView(
        meme: meme,
        memeEdit: memeEdit,
      ),
    );
  }
}

class MemeExportView extends StatefulWidget {
  final Meme meme;
  final MemeEdit memeEdit;

  const MemeExportView({
    super.key,
    required this.meme,
    required this.memeEdit,
  });

  @override
  State<MemeExportView> createState() => _MemeExportViewState();
}

class _MemeExportViewState extends State<MemeExportView> with SingleTickerProviderStateMixin {
  final GlobalKey _memeKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExporting = false;
  String? _lastExportedPath;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: _buildAppBar(context),
      body: BlocConsumer<MemeEditBloc, MemeEditState>(
        listener: (context, state) {
          // Handle BLoC state changes
          if (state is ImageSavedToGallery) {
            setState(() {
              _isExporting = false;
            });
            _showSnackBar(
              context,
              'Meme saved to gallery successfully!',
            );
          } else if (state is ImageShared) {
            setState(() {
              _isExporting = false;
            });
            _showSnackBar(
              context,
              'Meme shared successfully!',
            );
          } else if (state is MemeEditError) {
            setState(() {
              _isExporting = false;
            });
            _showSnackBar(
              context,
              'Export failed: ${state.message}',
              isError: true,
            );
          }
        },
        builder: (context, state) {
          // Show loading if local state is exporting OR BLoC is processing
          final isProcessing = _isExporting || state is MemeEditLoading;

          return Column(
            children: [
              _buildMemePreview(context),
              _buildExportActions(context, isProcessing: isProcessing),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Export Meme',
        style: context.textStyles.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colors.onSurface,
        ),
      ),
      backgroundColor: context.colors.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: context.colors.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (_lastExportedPath != null)
          IconButton(
            icon: Icon(Icons.visibility_rounded, color: context.colors.primary),
            onPressed: () => _showImagePreview(context),
            tooltip: 'Preview Last Export',
          ),
      ],
    );
  }

  Widget _buildMemePreview(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        margin: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.circularLg,
          boxShadow: AppShadows.card(context.colors, isElevated: true),
          color: context.colors.surfaceContainer,
        ),
        child: ClipRRect(
          borderRadius: AppBorderRadius.circularLg,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: RepaintBoundary(
                  key: _memeKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.circularLg,
                      color: context.colors.surface,
                    ),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: widget.meme.url,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: context.colors.surfaceContainerHighest,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: context.colors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: context.colors.errorContainer,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: context.colors.onErrorContainer,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Text Elements
                        ...widget.memeEdit.textElements.map((textElement) {
                          return DraggableText(
                            textElement: textElement,
                            onUpdate: (_) {}, // Read-only in export view
                            onDelete: () {}, // Read-only in export view
                          );
                        }),
                        // Sticker Elements
                        ...widget.memeEdit.stickerElements.map((stickerElement) {
                          return DraggableSticker(
                            stickerElement: stickerElement,
                            onUpdate: (_) {}, // Read-only in export view
                            onDelete: () {}, // Read-only in export view
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExportActions(BuildContext context, {bool isProcessing = false}) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: AppShadows.card(context.colors),
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
                color: context.colors.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Export Info
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer.withOpacity(0.3),
                borderRadius: AppBorderRadius.circularMd,
                border: Border.all(
                  color: context.colors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: context.colors.primary,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Your meme will be saved in high quality (PNG format)',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Action Buttons
            if (isProcessing) _buildLoadingState(context) else _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          SizedBox(height: AppSpacing.md),
          Text(
            'Exporting your meme...',
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Save to Gallery Button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _saveToGallery(context),
            icon: const Icon(Icons.save_alt_rounded),
            label: const Text('Save to Gallery'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // Share Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _shareImage(context),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share Meme'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              side: BorderSide(color: context.colors.primary),
              foregroundColor: context.colors.primary,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),

        // Quick Actions Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAction(
              context,
              icon: Icons.copy_rounded,
              label: 'Copy',
              onTap: () => _copyToClipboard(context),
            ),
            _buildQuickAction(
              context,
              icon: Icons.open_in_new_rounded,
              label: 'Open',
              onTap: () => _openImage(context),
            ),
            _buildQuickAction(
              context,
              icon: Icons.delete_outline_rounded,
              label: 'Clear',
              onTap: () => _clearCache(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.circularSm,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: context.colors.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Export Functions
  Future<void> _saveToGallery(BuildContext context) async {
    await _performExport(context, ExportType.gallery);
  }

  Future<void> _shareImage(BuildContext context) async {
    await _performExport(context, ExportType.share);
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await _performExport(context, ExportType.clipboard);
  }

  Future<void> _openImage(BuildContext context) async {
    if (_lastExportedPath != null) {
      // Use platform-specific method to open image
      await Share.shareXFiles([XFile(_lastExportedPath!)]);
    } else {
      _showSnackBar(
        context,
        'No exported image found. Please export first.',
        isError: true,
      );
    }
  }

  Future<void> _clearCache(BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync().where((file) => file.path.contains('meme_') && file.path.endsWith('.png'));

      for (final file in files) {
        await file.delete();
      }

      setState(() {
        _lastExportedPath = null;
      });

      _showSnackBar(context, 'Cache cleared successfully');
    } catch (e) {
      _showSnackBar(context, 'Failed to clear cache: $e', isError: true);
    }
  }

  Future<void> _performExport(BuildContext context, ExportType type) async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Capture image using BLoC
      final imagePath = await _captureImage();
      setState(() {
        _lastExportedPath = imagePath;
      });

      // Use BLoC for all export operations
      switch (type) {
        case ExportType.gallery:
          if (mounted) {
            context.read<MemeEditBloc>().add(SaveToGalleryEvent(imagePath));
          }
          break;
        case ExportType.share:
          if (mounted) {
            context.read<MemeEditBloc>().add(ShareImageEvent(imagePath));
          }
          break;
        case ExportType.clipboard:
          // For clipboard, handle locally and reset state immediately
          await _copyImageToClipboard(context, imagePath);
          if (mounted) {
            setState(() {
              _isExporting = false;
            });
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
        _handleExportError(context, e, type);
      }
    }
  }

  Future<String> _captureImage() async {
    try {
      // Find the RepaintBoundary render object
      final RenderRepaintBoundary boundary = _memeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Capture with high quality
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Convert to byte data
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to byte data');
      }

      // Save to temporary file
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = 'meme_${DateTime.now().millisecondsSinceEpoch}.png';
      final File tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      return tempFile.path;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }

  Future<void> _copyImageToClipboard(BuildContext context, String imagePath) async {
    try {
      // For now, just copy a text message with the file path
      // In a real app, you might want to use a plugin that supports image clipboard
      await Clipboard.setData(ClipboardData(
        text: 'Meme exported: $imagePath',
      ));

      _showSnackBar(context, 'Meme path copied to clipboard!');
    } catch (e) {
      throw Exception('Failed to copy to clipboard: $e');
    }
  }

  void _showPermissionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: context.colors.error),
            SizedBox(width: AppSpacing.sm),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _handleExportError(BuildContext context, dynamic error, ExportType type) {
    String message = 'Export failed';
    String? fallbackAction;

    if (error.toString().contains('permission')) {
      message = 'Permission denied. Please check app permissions.';
      fallbackAction = 'Open Settings';
    } else if (error.toString().contains('storage')) {
      message = 'Storage error. Please check available space.';
    } else if (error.toString().contains('network')) {
      message = 'Network error. Please check your connection.';
    } else if (error.toString().contains('capture')) {
      message = 'Failed to capture image. Please try again.';
    } else {
      message = 'Export failed: ${error.toString()}';
    }

    _showSnackBar(context, message, isError: true, action: fallbackAction);
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    String? action,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? context.colors.error : context.colors.secondary,
        action: action != null
            ? SnackBarAction(
                label: action,
                textColor: Colors.white,
                onPressed: () {
                  if (action == 'Open Settings') {
                    openAppSettings();
                  }
                },
              )
            : null,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.circularSm,
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    if (_lastExportedPath == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius.circularLg,
            color: context.colors.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Image Preview'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Flexible(
                child: Image.file(
                  File(_lastExportedPath!),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

enum ExportType {
  gallery,
  share,
  clipboard,
}
