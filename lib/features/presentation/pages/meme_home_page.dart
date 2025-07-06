import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:meme_editor_mobile/core/theme/theme_bloc.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/presentation/bloc/meme_bloc.dart';
import 'package:meme_editor_mobile/features/presentation/pages/meme_detail_page.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/shimmer.dart';

import 'package:meme_editor_mobile/injection_container.dart' as di;

class MemeHomePage extends StatelessWidget {
  const MemeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MemeBloc>()..add(LoadMemesEvent()),
      child: const MemeHomeView(),
    );
  }
}

class MemeHomeView extends StatefulWidget {
  const MemeHomeView({super.key});

  @override
  State<MemeHomeView> createState() => _MemeHomeViewState();
}

class _MemeHomeViewState extends State<MemeHomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Add haptic feedback for better UX
          HapticFeedback.lightImpact();
          
          // Trigger refresh and wait for completion
          context.read<MemeBloc>().add(LoadMemesEvent());
          
          // Wait for the state to change to either loaded or error
          await context.read<MemeBloc>().stream.firstWhere(
            (state) => state is MemeLoaded || state is MemeError,
          );
        },
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: CustomScrollView(
          slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              'Meme Editor',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            actions: [
              // Offline Mode Toggle
              BlocBuilder<MemeBloc, MemeState>(
                builder: (context, state) {
                  bool isOffline = false;
                  if (state is MemeLoaded) {
                    isOffline = state.isOfflineMode;
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOffline ? Icons.cloud_off : Icons.cloud,
                          size: 20,
                          color: isOffline ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 4),
                        Switch(
                          value: isOffline,
                          onChanged: (value) {
                            context.read<MemeBloc>().add(ToggleOfflineModeEvent(value));
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: Theme.of(context).colorScheme.primary,
                          activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
                          inactiveThumbColor: Theme.of(context).colorScheme.outline,
                          inactiveTrackColor: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Theme Toggle
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      key: ValueKey(Theme.of(context).brightness),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Hero(
                tag: 'search_bar',
                child: Material(
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search memes...',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<MemeBloc>().add(const SearchMemesEvent(''));
                                },
                              )
                            : null,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    onChanged: (query) {
                      context.read<MemeBloc>().add(SearchMemesEvent(query));
                    },
                  ),
                ),
              ),
            ),
          ),
          // Memes Grid
          BlocBuilder<MemeBloc, MemeState>(
            builder: (context, state) {
              if (state is MemeLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is MemeError) {
                return SliverFillRemaining(
                  child: _buildErrorState(context, state.message),
                );
              }

              if (state is MemeLoaded) {
                if (state.filteredMemes.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(context, state.searchQuery),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: state.filteredMemes.length,
                    itemBuilder: (context, index) {
                      final meme = state.filteredMemes[index];
                      return AnimatedMemeGridItem(
                        meme: meme,
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => MemeDetailPage(meme: meme),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: Text('No data')),
              );
            },
          ),
          // Bottom padding for FAB
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh or tap the button below',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<MemeBloc>().add(LoadMemesEvent());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.image_not_supported_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isNotEmpty ? 'No memes found' : 'No memes available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty ? 'Try searching for something else' : 'Pull down to refresh',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedMemeGridItem extends StatefulWidget {
  final Meme meme;
  final int index;
  final VoidCallback onTap;

  const AnimatedMemeGridItem({
    super.key,
    required this.meme,
    required this.index,
    required this.onTap,
  });

  @override
  State<AnimatedMemeGridItem> createState() => _AnimatedMemeGridItemState();
}

class _AnimatedMemeGridItemState extends State<AnimatedMemeGridItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation with delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Hero(
              tag: 'meme_${widget.meme.id}',
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.meme.url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            highlightColor: Theme.of(context).colorScheme.surface,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meme.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.aspect_ratio_rounded,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.meme.width}×${widget.meme.height}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
