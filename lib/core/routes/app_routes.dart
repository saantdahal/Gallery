enum AppRoute {
  Splash,
  Gallery,
  Favourites,
  ImagePreview,
}

extension AppRouteExtension on AppRoute {
  String asPath() {
    switch (this) {
      case AppRoute.Splash:
        return '/';
      case AppRoute.Gallery:
        return '/gallery';
      case AppRoute.Favourites:
        return '/favourites';
      case AppRoute.ImagePreview:
        return '/gallery/preview';
    }
  }

  String get name => toString().split('.').last;
}
