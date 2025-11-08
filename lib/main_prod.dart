import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gallery/config/flavorizr/flavor_config.dart';
import 'package:gallery/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlavorConfig.setFlavor(Flavor.production);
  runApp(const App());
}
