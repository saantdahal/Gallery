import 'package:dio/dio.dart';
import 'package:gallery/features/data/models/image_model.dart';
import 'package:retrofit/retrofit.dart';

part 'gallery_api_service.g.dart';

@RestApi()
abstract class GalleryApiService {
  factory GalleryApiService(Dio dio, {String baseUrl}) = _GalleryApiService;

  @GET('/v2/list')
  Future<List<ImageModel>> getImages(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
