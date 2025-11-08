import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gallery/core/routes/app_routes.dart';
import 'package:gallery/features/presentation/screen/splash/splash_screen.dart';
import 'package:gallery/features/presentation/screen/splash/bloc/splash_bloc.dart';
import 'package:gallery/features/presentation/screen/gallery/gallery_screen.dart';
import 'package:gallery/features/presentation/screen/gallery/bloc/gallery_bloc.dart';
import 'package:gallery/features/presentation/screen/favourites/favourites_screen.dart';
import 'package:gallery/features/presentation/screen/image_preview/image_preview_screen.dart';
import 'package:gallery/features/data/models/image_model.dart';
import 'package:get_it/get_it.dart';

class ScaffoldWithBottomNav extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
  });

  @override
  State<ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<ScaffoldWithBottomNav> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/gallery')) {
      return 0;
    } else if (location.startsWith('/favourites')) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (!isMobile) {
      return widget.child;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoute.Gallery.asPath());
              break;
            case 1:
              context.go(AppRoute.Favourites.asPath());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
      ),
      extendBody: true,
    );
  }
}

class RouterConfiguration {
  factory RouterConfiguration() => _instance;
  RouterConfiguration._internal();
  static final RouterConfiguration _instance = RouterConfiguration._internal();
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: AppRoute.Splash.name,
        path: AppRoute.Splash.asPath(),
        builder: (context, state) => BlocProvider(
          create: (context) => SplashBloc(),
          child: const SplashScreen(),
        ),
      ),

      // Shell route for bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: AppRoute.Gallery.name,
            path: AppRoute.Gallery.asPath(),
            builder: (context, state) => BlocProvider(
              create: (context) => GetIt.instance<GalleryBloc>(),
              child: const GalleryScreen(),
            ),
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: AppRoute.Favourites.name,
            path: AppRoute.Favourites.asPath(),
            builder: (context, state) => BlocProvider.value(
              value: GetIt.instance<GalleryBloc>(),
              child: const FavouritesScreen(),
            ),
          ),
        ],
      ),

      // Image preview route (full screen)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: AppRoute.ImagePreview.name,
        path: AppRoute.ImagePreview.asPath(),
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final images = extra['images'] as List<ImageModel>;
          final initialIndex = extra['initialIndex'] as int;

          return BlocProvider.value(
            value: GetIt.instance<GalleryBloc>(),
            child: ImagePreviewScreen(
              images: images,
              initialIndex: initialIndex,
            ),
          );
        },
      ),
    ],
  );
}
