import 'package:equatable/equatable.dart';
import 'package:gallery/features/data/models/image_model.dart';

enum GalleryStatus { initial, loading, success, error, loadingMore }

class GalleryState extends Equatable {
  final GalleryStatus status;
  final List<ImageModel> images;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final bool isOffline;

  const GalleryState({
    this.status = GalleryStatus.initial,
    this.images = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isOffline = false,
  });

  GalleryState copyWith({
    GalleryStatus? status,
    List<ImageModel>? images,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    bool? isOffline,
  }) {
    return GalleryState(
      status: status ?? this.status,
      images: images ?? this.images,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        errorMessage,
        currentPage,
        hasReachedMax,
        isOffline,
      ];
}
