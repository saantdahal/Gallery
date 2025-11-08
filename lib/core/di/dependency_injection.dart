import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gallery/config/flavorizr/flavor_config.dart';
import 'package:gallery/core/network/gallery_api_service.dart';
import 'package:gallery/core/services/connectivity_service.dart';
import 'package:gallery/core/services/local_storage_service.dart';
import 'package:gallery/features/data/repositories/gallery_repository.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Local Storage
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  getIt.registerSingleton<LocalStorageService>(localStorageService);

  // Connectivity
  getIt.registerSingleton<ConnectivityService>(
    ConnectivityService(Connectivity()),
  );

  // Dio
  final dio = Dio(BaseOptions(
    baseUrl: FlavorConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));

  getIt.registerSingleton<Dio>(dio);

  // API Service
  getIt.registerSingleton<GalleryApiService>(
    GalleryApiService(getIt<Dio>()),
  );

  // Repository
  getIt.registerSingleton<GalleryRepository>(
    GalleryRepository(
      getIt<GalleryApiService>(),
      getIt<LocalStorageService>(),
      getIt<ConnectivityService>(),
    ),
  );

  // BLoC
  getIt.registerFactory<GalleryBloc>(
    () => GalleryBloc(getIt<GalleryRepository>(), getIt<ConnectivityService>()),
  );
}
