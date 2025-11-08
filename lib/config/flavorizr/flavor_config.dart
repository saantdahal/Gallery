import 'package:gallery/config/app/app_config.dart';

enum Flavor {
  development,
  production,
}

class FlavorConfig {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return '${AppConfiguration.appName} (Dev)';
      case Flavor.production:
        return AppConfiguration.appName;
      default:
        return AppConfiguration.appName;
    }
  }

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return AppConfiguration.devApiUrl;
      case Flavor.production:
        return AppConfiguration.prodApiUrl;
      default:
        return AppConfiguration.devApiUrl;
    }
  }

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isProduction => appFlavor == Flavor.production;

  static void setFlavor(Flavor flavor) {
    appFlavor = flavor;
  }

  static Flavor getFlavor() {
    return appFlavor ?? Flavor.development;
  }
}
