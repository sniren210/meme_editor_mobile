import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';

class AnimatedMemeGridItem extends StatefulWidget {
  final Meme meme;
  final VoidCallback onTap;
  final int index;

  const AnimatedMemeGridItem({
    super.key,
    required this.meme,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnimatedMemeGridItem> createState() => _AnimatedMemeGridItemState();
}

class _AnimatedMemeGridItemState extends State<AnimatedMemeGridItem>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for hover effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Slide animation for entrance
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Fade animation for entrance
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start entrance animation with delay based on index
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() async {
    await Future.delayed(Duration(milliseconds: widget.index * 100));
    if (mounted) {
      _slideController.forward();
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => _onHoverChanged(true),
                onExit: (_) => _onHoverChanged(false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Card(
                    elevation: _isHovered ? 8 : 2,
                    shadowColor: colorScheme.shadow.withOpacity(0.2),
                    surfaceTintColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.surface,
                            colorScheme.surfaceVariant.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Meme image
                          Positioned.fill(
                            child: Hero(
                              tag: 'meme_${widget.meme.id}',
                              child: CachedNetworkImage(
                                imageUrl: widget.meme.url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: colorScheme.surfaceVariant,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 40,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: colorScheme.errorContainer,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 40,
                                        color: colorScheme.onErrorContainer,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onErrorContainer,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  stops: const [0.6, 1.0],
                                ),
                              ),
                            ),
                          ),
                          
                          // Meme name
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                widget.meme.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          
                          // Hover indicator
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            top: _isHovered ? 8 : -50,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          
                          // Ripple effect overlay
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onTap,
                                borderRadius: BorderRadius.circular(16),
                                splashColor: colorScheme.primary.withOpacity(0.2),
                                highlightColor: colorScheme.primary.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
