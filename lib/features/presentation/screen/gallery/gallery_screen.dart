import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery/features/data/models/image_model.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_bloc.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_event.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_state.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    context.read<GalleryBloc>().add(const LoadImages());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<GalleryBloc>().add(const RefreshImages());
  }

  void _onLoading() {
    context.read<GalleryBloc>().add(const LoadMoreImages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Gallery'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<GalleryBloc, GalleryState>(
        listener: (context, state) {
          if (state.status == GalleryStatus.success) {
            _refreshController.refreshCompleted();
            _refreshController.loadComplete();
          } else if (state.status == GalleryStatus.error) {
            _refreshController.refreshFailed();
            _refreshController.loadFailed();

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state.status == GalleryStatus.loading && state.images.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
            );
          }

          if (state.status == GalleryStatus.error && state.images.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load images',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GalleryBloc>().add(const LoadImages());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (state.isOffline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.red[100],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'No Internet Connection - Showing cached images',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: !state.hasReachedMax,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    itemCount: state.status == GalleryStatus.loading &&
                            state.images.isEmpty
                        ? 6
                        : state.images.length,
                    itemBuilder: (context, index) {
                      if (state.status == GalleryStatus.loading &&
                          state.images.isEmpty) {
                        return const _SkeletonGridItem();
                      }
                      final image = state.images[index];
                      return _ImageGridItem(image: image);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SkeletonGridItem extends StatefulWidget {
  const _SkeletonGridItem();

  @override
  State<_SkeletonGridItem> createState() => _SkeletonGridItemState();
}

class _SkeletonGridItemState extends State<_SkeletonGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                height: 200 +
                    (DateTime.now().millisecondsSinceEpoch % 100).toDouble(),
                color: Colors.grey[300]?.withValues(alpha: _animation.value),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.white.withValues(alpha: _animation.value),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.white.withValues(alpha: _animation.value),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageGridItem extends StatelessWidget {
  final ImageModel image;

  const _ImageGridItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final images = context.read<GalleryBloc>().state.images;
        final index = images.indexWhere((img) => img.id == image.id);
        context.push('/gallery/preview',
            extra: {'images': images, 'initialIndex': index});
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: image.downloadUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200 +
                    (DateTime.now().millisecondsSinceEpoch % 100).toDouble(),
                color: Colors.grey[300],
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200 +
                    (DateTime.now().millisecondsSinceEpoch % 100).toDouble(),
                color: Colors.grey[300],
                child: const Icon(Icons.error, size: 40),
              ),
              fadeInDuration: const Duration(milliseconds: 300),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        image.author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        image.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: image.isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<GalleryBloc>()
                            .add(ToggleFavorite(image.id));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
