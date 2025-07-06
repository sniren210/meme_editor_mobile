# 🎭 Meme Editor Mobile

A feature-rich Flutter mobile application for creating, editing, and sharing memes with a modern, intuitive interface.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## 📱 Features

### Core Functionality

- **🖼️ Meme Gallery** - Browse and select from popular meme templates
- **✏️ Text Editor** - Add custom text with various fonts and styles
- **🎨 Visual Editor** - Drag, resize, and position text elements
- **📱 Responsive Design** - Optimized for all screen sizes
- **🌙 Dark/Light Mode** - Complete theme customization

### Advanced Features

- **💾 Save to Gallery** - Export memes directly to device gallery
- **📤 Share Functionality** - Share memes across social platforms
- **🔍 Search & Filter** - Find memes by name or category
- **📴 Offline Mode** - Browse cached memes without internet
- **🎭 Sticker Support** - Add fun stickers and overlays
- **🔄 Pull to Refresh** - Keep content updated

### Technical Features

- **🏗️ Clean Architecture** - Domain-driven design with separation of concerns
- **🔄 State Management** - BLoC pattern for predictable state handling
- **🗄️ Local Storage** - Hive database for offline functionality
- **🌐 Network Handling** - Robust API integration with error handling
- **🔐 Permission Management** - Smart permission handling for file operations
- **🧪 Comprehensive Testing** - Unit, widget, and integration tests

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (≥3.4.3)
- Dart SDK (≥3.4.3)
- Android Studio / VS Code
- Android device or emulator (API level 21+)
- iOS device or simulator (iOS 12+)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/sniren210/meme_editor_mobile.git
   cd meme_editor_mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate required files**

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Quick Setup Commands

```bash
# Install dependencies and generate files
flutter pub get && flutter packages pub run build_runner build

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Build APK
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --release
```

## 🏗️ Project Architecture

This project follows **Clean Architecture** principles with a clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── data/               # Data layer
│   │   ├── datasources/    # API & local data sources
│   │   ├── models/         # Data models
│   │   └── repositories/   # Repository implementations
│   ├── domain/             # Business logic layer
│   │   ├── entities/       # Domain entities
│   │   ├── repositories/   # Repository interfaces
│   │   └── usecases/       # Business use cases
│   └── presentation/       # UI layer
│       ├── bloc/           # State management
│       ├── pages/          # App screens
│       └── widgets/        # Reusable widgets
├── injection_container.dart # Dependency injection
└── main.dart               # App entry point
```

### Architecture Layers

1. **Presentation Layer** - UI components and state management
2. **Domain Layer** - Business logic and use cases
3. **Data Layer** - API calls, local storage, and data sources

## 🔧 Configuration

### Android Setup

1. **Permissions** (automatically configured in `android/app/src/main/AndroidManifest.xml`):

   - Internet access
   - Storage permissions
   - Photo library access

2. **Minimum SDK**: API level 21 (Android 5.0)

### iOS Setup

1. **Permissions** (configure in `ios/Runner/Info.plist`):

   - Photo library access
   - Camera access (if needed)

2. **Minimum iOS**: 12.0

## 📦 Dependencies

### Core Dependencies

- **flutter_bloc** ^8.1.3 - State management
- **get_it** ^7.6.4 - Dependency injection
- **dartz** ^0.10.1 - Functional programming utilities
- **equatable** ^2.0.5 - Value equality comparisons

### UI & UX

- **flutter_staggered_grid_view** ^0.7.0 - Advanced grid layouts
- **cached_network_image** ^3.3.0 - Optimized image loading
- **pull_to_refresh_flutter3** ^2.0.2 - Pull-to-refresh functionality

### Storage & Networking

- **hive** ^2.2.3 & **hive_flutter** ^1.1.0 - Local database
- **shared_preferences** ^2.2.2 - Simple key-value storage
- **http** ^1.1.0 - HTTP client
- **connectivity_plus** ^5.0.1 - Network connectivity

### File Operations

- **path_provider** ^2.1.1 - File system paths
- **permission_handler** ^11.0.1 - Runtime permissions
- **image_gallery_saver** ^2.0.3 - Save images to gallery
- **share_plus** ^7.2.1 - Share functionality

### Development

- **json_annotation** ^4.8.1 & **json_serializable** ^6.7.1 - JSON serialization
- **build_runner** ^2.4.7 - Code generation
- **flutter_launcher_icons** ^0.14.4 - App icon generation

## 🧪 Testing

This project includes comprehensive testing coverage:

### Test Types

- **Unit Tests** - Business logic and data layer testing
- **Widget Tests** - UI component testing
- **Integration Tests** - End-to-end functionality testing
- **Golden Tests** - Visual regression testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test categories
flutter test test/features/domain/      # Unit tests
flutter test test/features/presentation/ # Widget tests
flutter test integration_test/          # Integration tests

# Run using test scripts
.\run_tests.bat                         # Windows
./run_tests.sh                          # Linux/Mac
```

### Test Coverage

- **Unit Tests**: 90%+ coverage for business logic
- **Widget Tests**: All major UI components
- **Integration Tests**: Critical user journeys

## 🎨 Theming

The app supports both light and dark themes with:

- Material Design 3 color schemes
- Consistent typography
- Adaptive components
- Custom theme extensions

## 🔄 State Management

Uses **BLoC (Business Logic Component)** pattern:

- Predictable state changes
- Easy testing
- Clear separation of business logic
- Reactive programming approach

## 📱 Supported Platforms

- **Android** 5.0+ (API level 21+)
- **iOS** 12.0+

## 🚦 Development Workflow

1. **Feature Development**

   ```bash
   git checkout -b feature/your-feature-name
   # Develop your feature
   flutter test                    # Run tests
   git commit -m "Add: your feature"
   git push origin feature/your-feature-name
   ```

2. **Code Quality**

   ```bash
   flutter analyze                 # Static analysis
   dart format .                   # Code formatting
   flutter test --coverage        # Test coverage
   ```

3. **Build & Deploy**
   ```bash
   flutter build apk --release     # Android
   flutter build ios --release     # iOS
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass (`flutter test`)
6. Commit your changes (`git commit -m 'Add: amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Ensure test coverage for new features

## 🐛 Known Issues

- Gallery permission handling on some Android 13+ devices
- Occasional network timeout on slow connections
- Memory usage optimization needed for large image sets

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/sniren210/meme_editor_mobile/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sniren210/meme_editor_mobile/discussions)
- **Email**: rendidwi.softwaredev@gmail.com

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [BLoC Library](https://bloclibrary.dev) for state management
- [Imgflip API](https://imgflip.com/api) for meme templates

---

**Made with ❤️ using Flutter**

_Happy meme creating! 🎭✨_
