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

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load all images to get favorites
    context.read<GalleryBloc>().add(const LoadImages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state.status == GalleryStatus.loading && state.images.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
            );
          }

          // Filter favorite images
          final favoriteImages =
              state.images.where((image) => image.isFavorite).toList();

          if (favoriteImages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favourite images yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add images to favourites from the gallery',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: favoriteImages.length,
            itemBuilder: (context, index) {
              final image = favoriteImages[index];
              return _FavouriteImageGridItem(image: image);
            },
          );
        },
      ),
    );
  }
}

class _FavouriteImageGridItem extends StatelessWidget {
  final ImageModel image;

  const _FavouriteImageGridItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final allImages = context.read<GalleryBloc>().state.images;
        final index = allImages.indexWhere((img) => img.id == image.id);
        context.push('/gallery/preview',
            extra: {'images': allImages, 'initialIndex': index});
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
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
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
