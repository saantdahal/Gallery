import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gallery/config/flavorizr/flavor_config.dart';
import 'package:gallery/core/di/dependency_injection.dart';
import 'package:gallery/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final envString = await rootBundle.loadString('.env');
  for (var line in envString.split('\n')) {
    if (line.trim().isNotEmpty && line.contains('=')) {
      var parts = line.split('=');
      if (parts.length == 2) {
        dotenv.env[parts[0].trim()] = parts[1].trim();
      }
    }
  }
  FlavorConfig.setFlavor(Flavor.development);

  // Initialize dependencies
  await setupDependencies();

  runApp(const App());
}
