import 'package:gallery/core/network/gallery_api_service.dart';
import 'package:gallery/core/services/connectivity_service.dart';
import 'package:gallery/core/services/local_storage_service.dart';
import 'package:gallery/features/data/models/image_model.dart';

class GalleryRepository {
  final GalleryApiService _apiService;
  final LocalStorageService _localStorageService;
  final ConnectivityService _connectivityService;

  GalleryRepository(
    this._apiService,
    this._localStorageService,
    this._connectivityService,
  );

  Future<List<ImageModel>> getImages({
    required int page,
    required int limit,
    bool forceRefresh = false,
  }) async {
    final hasConnection = await _connectivityService.hasInternetConnection();

    if (!hasConnection) {
      final cachedImages = _localStorageService.getCachedImages();
      return _addFavoriteStatus(cachedImages);
    }

    try {
      final images = await _apiService.getImages(page, limit);

      // Cache the images
      await _localStorageService.cacheImages(images);
      await _localStorageService.saveLastPage(page);

      // Return images with favorite status
      return _addFavoriteStatus(images);
    } catch (e) {
      if (!forceRefresh && page == 1) {
        final cachedImages = _localStorageService.getCachedImages();
        return _addFavoriteStatus(cachedImages);
      }
      rethrow;
    }
  }

  List<ImageModel> _addFavoriteStatus(List<ImageModel> images) {
    return images.map((image) {
      final isFavorite = _localStorageService.isFavorite(image.id);
      return image.copyWith(isFavorite: isFavorite);
    }).toList();
  }

  Future<void> toggleFavorite(String imageId) async {
    await _localStorageService.toggleFavorite(imageId);
  }

  bool isFavorite(String imageId) {
    return _localStorageService.isFavorite(imageId);
  }

  List<ImageModel> getCachedImages() {
    return _addFavoriteStatus(_localStorageService.getCachedImages());
  }

  List<ImageModel> getFavoriteImages() {
    return _addFavoriteStatus(_localStorageService.getFavoriteImages());
  }
}
