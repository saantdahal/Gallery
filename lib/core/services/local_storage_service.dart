import 'package:hive_flutter/hive_flutter.dart';
import 'package:gallery/features/data/models/image_model.dart';

class LocalStorageService {
  static const String _imagesBoxName = 'images';
  static const String _favoritesBoxName = 'favorites';
  static const String _cacheBoxName = 'cache';

  late Box<ImageModel> _imagesBox;
  late Box<String> _favoritesBox;
  late Box<dynamic> _cacheBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ImageModelAdapter());
    }

    // Open boxes
    _imagesBox = await Hive.openBox<ImageModel>(_imagesBoxName);
    _favoritesBox = await Hive.openBox<String>(_favoritesBoxName);
    _cacheBox = await Hive.openBox(_cacheBoxName);
  }

  // Cache images
  Future<void> cacheImages(List<ImageModel> images) async {
    for (var image in images) {
      await _imagesBox.put(image.id, image);
    }
  }

  // Get cached images
  List<ImageModel> getCachedImages() {
    return _imagesBox.values.toList();
  }

  // Get image by id
  ImageModel? getImage(String id) {
    return _imagesBox.get(id);
  }

  // Favorites
  Future<void> toggleFavorite(String imageId) async {
    if (isFavorite(imageId)) {
      await _favoritesBox.delete(imageId);
    } else {
      await _favoritesBox.put(imageId, imageId);
    }
  }

  bool isFavorite(String imageId) {
    return _favoritesBox.containsKey(imageId);
  }

  List<String> getFavoriteIds() {
    return _favoritesBox.values.toList();
  }

  List<ImageModel> getFavoriteImages() {
    final favoriteIds = getFavoriteIds();
    return favoriteIds
        .map((id) => _imagesBox.get(id))
        .where((image) => image != null)
        .cast<ImageModel>()
        .toList();
  }

  // Cache metadata (like last page loaded)
  Future<void> saveLastPage(int page) async {
    await _cacheBox.put('lastPage', page);
  }

  int getLastPage() {
    return _cacheBox.get('lastPage', defaultValue: 1);
  }

  Future<void> clearCache() async {
    await _imagesBox.clear();
    await _favoritesBox.clear();
    await _cacheBox.clear();
  }

  // Update image with favorite status
  Future<void> updateImage(ImageModel image) async {
    await _imagesBox.put(image.id, image);
  }
}
