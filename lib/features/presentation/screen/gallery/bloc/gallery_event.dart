import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadImages extends GalleryEvent {
  const LoadImages();
}

class RefreshImages extends GalleryEvent {
  const RefreshImages();
}

class LoadMoreImages extends GalleryEvent {
  const LoadMoreImages();
}

class ToggleFavorite extends GalleryEvent {
  final String imageId;

  const ToggleFavorite(this.imageId);

  @override
  List<Object?> get props => [imageId];
}

class LoadCachedImages extends GalleryEvent {
  const LoadCachedImages();
}
