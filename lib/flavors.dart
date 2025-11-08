enum Flavor {
  development,
  production,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'Gallery (Dev)';
      case Flavor.production:
        return 'Gallery';
    }
  }
}
