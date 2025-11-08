# Gallery App

A Flutter-based gallery application with multi-flavor support for development and production environments.

## 📱 About

A cross-platform gallery application built with Flutter, featuring clean architecture, state management with BLoC, and local caching capabilities.

## 🛠️ Technologies Used

### Core Framework

- **Flutter SDK**: ^3.5.2
- **Dart**: ^3.5.2

### State Management & Dependency Injection

- **flutter_bloc**: ^9.1.1 - BLoC pattern for state management
- **get_it**: ^7.7.0 - Service locator for dependency injection
- **equatable**: ^2.0.5 - Value equality for Dart classes

### Networking & API

- **dio**: ^5.7.0 - HTTP client for API calls
- **retrofit**: ^4.4.1 - Type-safe REST client
- **pretty_dio_logger**: ^1.4.0 - Network request logging
- **connectivity_plus**: ^7.0.0 - Network connectivity monitoring

### Local Storage

- **hive**: ^2.2.3 - Lightweight NoSQL database
- **hive_flutter**: ^1.1.0 - Flutter integration for Hive
- **shared_preferences**: ^2.3.2 - Key-value storage

### UI/UX

- **cached_network_image**: ^3.2.0 - Image caching
- **loading_animation_widget**: ^1.2.0 - Loading animations
- **flutter_staggered_grid_view**: ^0.7.0 - Staggered grid layouts
- **pull_to_refresh**: ^2.0.0 - Pull-to-refresh functionality
- **cupertino_icons**: ^1.0.8 - iOS-style icons

### Navigation

- **go_router**: ^14.2.8 - Declarative routing

### Configuration

- **flutter_dotenv**: ^6.0.0 - Environment variable management

### Dev Dependencies

- **build_runner**: ^2.4.13 - Code generation
- **json_serializable**: ^6.8.0 - JSON serialization
- **retrofit_generator**: ^8.2.1 - Retrofit code generation
- **hive_generator**: ^2.0.1 - Hive type adapters generation
- **flutter_lints**: ^4.0.0 - Linting rules

## 📁 Project Structure

```
gallery/
├── android/                      # Android native code
│   ├── app/
│   │   ├── src/                  # Android source files
│   │   ├── build.gradle.kts      # App-level Gradle config
│   │   └── flavorizr.gradle.kts  # Flavor configurations
│   ├── build.gradle.kts          # Project-level Gradle config
│   └── settings.gradle.kts       # Gradle settings
│
├── ios/                          # iOS native code
│   ├── Runner/                   # iOS app files
│   └── Runner.xcodeproj/         # Xcode project
│
├── lib/
│   ├── main.dart                 # Main entry point
│   ├── main_dev.dart             # Development entry point
│   ├── main_prod.dart            # Production entry point
│   ├── app.dart                  # App widget
│   ├── flavors.dart              # Flavor configurations
│   │
│   ├── config/                   # Configuration files
│   │   ├── app/                  # App configurations
│   │   └── flavorizr/            # Flavorizr configurations
│   │
│   ├── core/                     # Core application logic
│   │   ├── constants/            # App constants
│   │   ├── di/                   # Dependency injection setup
│   │   ├── network/              # Network configurations
│   │   ├── routes/               # Routing configuration
│   │   ├── services/             # Core services
│   │   └── theme/                # App theme
│   │
│   └── features/                 # Feature modules
│       ├── data/                 # Data layer (repositories, models, data sources)
│       └── presentation/         # Presentation layer (UI, BLoC)
│
├── assets/
│   ├── icons/                    # App icons
│   └── images/                   # Image assets
│
├── test/                         # Unit and widget tests
│   └── widget_test.dart
│
├── .env                          # Environment variables
├── pubspec.yaml                  # Flutter dependencies
├── analysis_options.yaml         # Dart analyzer configuration
└── README.md                     # Project documentation
```

## 🏗️ Architecture

The project follows **Clean Architecture** principles with separation of concerns:

- **Presentation Layer**: UI components and BLoC state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Repositories, data sources, and models

## 🚀 Build Process

### Prerequisites

- Flutter SDK (^3.5.2 or higher)
- Dart SDK (^3.5.2 or higher)
- Android Studio / Xcode (for platform-specific builds)

### Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd gallery
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code** (for models, repositories, etc.)

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure environment variables**
   - Create a `.env` file in the root directory
   - Add necessary API keys and configurations

### Building the App

The app uses **Flutter Flavorizr** for managing multiple build flavors (Development & Production).

#### Development Build

**Android APK:**

```bash
flutter build apk --release --flavor development -t lib/main_dev.dart
```

**iOS:**

```bash
flutter build ios --release --flavor development -t lib/main_dev.dart
```

**Run on device:**

```bash
flutter run --flavor development -t lib/main_dev.dart
```

#### Production Build

**Android APK:**

```bash
flutter build apk --release --flavor production -t lib/main_prod.dart
```

**Android App Bundle (for Play Store):**

```bash
flutter build appbundle --release --flavor production -t lib/main_prod.dart
```

**iOS:**

```bash
flutter build ios --release --flavor production -t lib/main_prod.dart
```

**Run on device:**

```bash
flutter run --flavor production -t lib/main_prod.dart
```

### Build Outputs

- **Android APK**: `build/app/outputs/flutter-apk/app-{flavor}-release.apk`
- **Android Bundle**: `build/app/outputs/bundle/{flavor}Release/app-{flavor}-release.aab`
- **iOS**: `build/ios/iphoneos/Runner.app`

## 🎨 Flavors

The app supports two flavors:

| Flavor          | Application ID          | App Name      |
| --------------- | ----------------------- | ------------- |
| **Development** | `com.example.myapp.dev` | Gallery (Dev) |
| **Production**  | `com.example.myapp`     | Gallery       |

Each flavor can have different:

- API endpoints
- App icons
- App names
- Bundle identifiers
- Configuration settings

## 🧪 Testing

Run tests:

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

## 🔧 Development

### Code Generation

When you modify models or add new repositories:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Linting

Check code quality:

```bash
flutter analyze
```

Format code:

```bash
flutter format .
```

## 📦 Dependencies Update

Check for outdated packages:

```bash
flutter pub outdated
```

Update dependencies:

```bash
flutter pub upgrade
```

## 🐛 Troubleshooting

### Common Issues

1. **Missing Cupertino Icons**

   - Ensure `cupertino_icons` is in `pubspec.yaml`
   - Run `flutter pub get`

2. **Build fails without flavor**

   - Always specify `--flavor` and `-t` when building
   - Use `development` or `production` flavor

3. **Gradle build issues**
   - Clean the build: `flutter clean`
   - Rebuild: `flutter pub get && flutter build apk --flavor production -t lib/main_prod.dart`

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Note**: Make sure to configure your `.env` file and signing configurations before building release versions.
