import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/core/services/connectivity_service.dart';
import 'package:gallery/features/data/repositories/gallery_repository.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_event.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository _repository;
  final ConnectivityService _connectivityService;
  static const int _pageSize = 30;

  GalleryBloc(this._repository, this._connectivityService)
      : super(const GalleryState()) {
    on<LoadImages>(_onLoadImages);
    on<RefreshImages>(_onRefreshImages);
    on<LoadMoreImages>(_onLoadMoreImages);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadCachedImages>(_onLoadCachedImages);
  }

  Future<void> _onLoadImages(
    LoadImages event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: GalleryStatus.loading));

    final hasConnection = await _connectivityService.hasInternetConnection();

    try {
      final images = await _repository.getImages(
        page: 1,
        limit: _pageSize,
      );

      emit(state.copyWith(
        status: GalleryStatus.success,
        images: images,
        currentPage: 1,
        hasReachedMax: images.length < _pageSize,
        isOffline: !hasConnection,
      ));
    } catch (e) {
      // Try to load cached images
      final cachedImages = _repository.getCachedImages();
      if (cachedImages.isNotEmpty) {
        emit(state.copyWith(
          status: GalleryStatus.success,
          images: cachedImages,
          isOffline: true,
        ));
      } else {
        emit(state.copyWith(
          status: GalleryStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshImages(
    RefreshImages event,
    Emitter<GalleryState> emit,
  ) async {
    try {
      final images = await _repository.getImages(
        page: 1,
        limit: _pageSize,
        forceRefresh: true,
      );

      emit(state.copyWith(
        status: GalleryStatus.success,
        images: images,
        currentPage: 1,
        hasReachedMax: images.length < _pageSize,
        isOffline: false,
      ));
    } catch (e) {
      // Keep existing images but show error
      emit(state.copyWith(
        status: GalleryStatus.error,
        errorMessage: 'Failed to refresh: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadMoreImages(
    LoadMoreImages event,
    Emitter<GalleryState> emit,
  ) async {
    if (state.hasReachedMax || state.status == GalleryStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: GalleryStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final newImages = await _repository.getImages(
        page: nextPage,
        limit: _pageSize,
      );

      emit(state.copyWith(
        status: GalleryStatus.success,
        images: List.of(state.images)..addAll(newImages),
        currentPage: nextPage,
        hasReachedMax: newImages.length < _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GalleryStatus.error,
        errorMessage: 'Failed to load more: ${e.toString()}',
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<GalleryState> emit,
  ) async {
    try {
      await _repository.toggleFavorite(event.imageId);

      // Update the image in the list
      final updatedImages = state.images.map((image) {
        if (image.id == event.imageId) {
          return image.copyWith(isFavorite: !image.isFavorite);
        }
        return image;
      }).toList();

      emit(state.copyWith(images: updatedImages));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to toggle favorite: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadCachedImages(
    LoadCachedImages event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: GalleryStatus.loading));

    final cachedImages = _repository.getCachedImages();

    if (cachedImages.isNotEmpty) {
      emit(state.copyWith(
        status: GalleryStatus.success,
        images: cachedImages,
        isOffline: true,
      ));
    } else {
      emit(state.copyWith(
        status: GalleryStatus.error,
        errorMessage: 'No cached images available',
      ));
    }
  }
}
