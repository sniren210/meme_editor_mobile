# Contributing to Meme Editor Mobile

Thank you for your interest in contributing to Meme Editor Mobile! This document provides guidelines and instructions for contributing to the project.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (≥3.4.3)
- Dart SDK (≥3.4.3)
- Git
- Android Studio or VS Code with Flutter extensions
- Android device/emulator or iOS simulator

### Development Setup

1. **Fork and clone the repository**

   ```bash
   git clone https://github.com/yourusername/meme_editor_mobile.git
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

4. **Run tests to ensure everything works**

   ```bash
   flutter test
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Development Guidelines

### Code Style

We follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) with these additions:

#### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `kCamelCase` (with k prefix)
- **Private members**: `_camelCase`

#### Code Organization

```dart
// Good: Clear imports with proper grouping
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';

// Good: Clear class structure
class MemeBloc extends Bloc<MemeEvent, MemeState> {
  // Fields first
  final GetMemesUseCase getMemesUseCase;

  // Constructor
  MemeBloc({required this.getMemesUseCase}) : super(MemeInitial());

  // Methods
  Future<void> _onLoadMemes(LoadMemesEvent event, Emitter<MemeState> emit) async {
    // Implementation
  }
}
```

#### Documentation

- Add documentation for all public APIs
- Use meaningful variable and function names
- Add comments for complex business logic

```dart
/// Retrieves memes from the API and caches them locally.
///
/// Returns [Right] with list of memes on success,
/// or [Left] with [Failure] on error.
Future<Either<Failure, List<Meme>>> getMemes();
```

### Architecture Guidelines

This project follows **Clean Architecture** principles:

#### Layers

1. **Presentation** (`lib/features/presentation/`)

   - UI components and state management
   - BLoC pattern for state management
   - No direct dependencies on data layer

2. **Domain** (`lib/features/domain/`)

   - Business logic and use cases
   - Pure Dart code (no Flutter dependencies)
   - Defines interfaces for data layer

3. **Data** (`lib/features/data/`)
   - API calls and local storage
   - Implements domain interfaces
   - Handles data transformation

#### Dependency Rule

- Inner layers should not depend on outer layers
- Use dependency injection for loose coupling
- All dependencies should flow inward

### Testing Requirements

All contributions must include appropriate tests:

#### Test Types

1. **Unit Tests** - Required for all business logic
2. **Widget Tests** - Required for all custom widgets
3. **Integration Tests** - Required for critical user flows
4. **Golden Tests** - Required for significant UI changes

#### Test Structure

```dart
// Good test structure
group('MemeBloc', () {
  late MemeBloc bloc;
  late MockGetMemesUseCase mockGetMemesUseCase;

  setUp(() {
    mockGetMemesUseCase = MockGetMemesUseCase();
    bloc = MemeBloc(getMemesUseCase: mockGetMemesUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadMemesEvent', () {
    test('should emit [MemeLoading, MemeLoaded] when successful', () async {
      // Arrange
      when(() => mockGetMemesUseCase()).thenAnswer((_) async => Right(tMemes));

      // Act
      bloc.add(LoadMemesEvent());

      // Assert
      expectLater(bloc.stream, emitsInOrder([MemeLoading(), MemeLoaded(tMemes)]));
    });
  });
});
```

## 🔄 Contribution Workflow

### 1. Choose an Issue

- Check [open issues](https://github.com/yourusername/meme_editor_mobile/issues)
- Look for `good first issue` or `help wanted` labels
- Comment on the issue to let others know you're working on it

### 2. Create a Branch

```bash
git checkout -b feature/issue-123-add-amazing-feature
```

Branch naming conventions:

- `feature/issue-123-description` - New features
- `bugfix/issue-123-description` - Bug fixes
- `docs/issue-123-description` - Documentation updates
- `test/issue-123-description` - Test improvements

### 3. Make Changes

#### Code Changes

- Follow the architecture guidelines
- Write clean, readable code
- Add appropriate documentation
- Include error handling

#### Test Changes

- Add unit tests for new business logic
- Add widget tests for new UI components
- Update integration tests if needed
- Ensure all tests pass

#### Documentation Changes

- Update README.md if needed
- Update API documentation
- Add code comments for complex logic

### 4. Commit Changes

Use conventional commit messages:

```bash
git commit -m "feat: add meme search functionality"
git commit -m "fix: resolve storage permission issue on Android 13"
git commit -m "docs: update installation instructions"
git commit -m "test: add unit tests for meme repository"
```

Commit types:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### 5. Run Quality Checks

Before submitting your PR:

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run all tests
flutter test

# Check test coverage
flutter test --coverage

# Build to ensure no build errors
flutter build apk --debug
```

### 6. Submit Pull Request

1. Push your branch to your fork
2. Create a pull request from your branch to `main`
3. Fill out the PR template
4. Wait for review and address feedback

#### PR Template

```markdown
## Description

Brief description of the changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Test improvement
- [ ] Refactoring

## Testing

- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] All tests pass

## Screenshots (if applicable)

Add screenshots for UI changes

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No breaking changes
```

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Environment**

   - Flutter version
   - Dart version
   - Platform (Android/iOS)
   - Device model and OS version

2. **Steps to Reproduce**

   - Clear, numbered steps
   - Expected behavior
   - Actual behavior

3. **Additional Context**
   - Screenshots or videos
   - Log output
   - Related issues

## 💡 Feature Requests

When requesting features:

1. **Clear Description**

   - What problem does it solve?
   - Who would benefit?
   - How should it work?

2. **Use Cases**

   - Specific examples
   - User stories

3. **Implementation Ideas**
   - Technical considerations
   - Potential challenges

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Material Design](https://material.io/)

## 🤝 Community

- **Discussions**: [GitHub Discussions](https://github.com/yourusername/meme_editor_mobile/discussions)
- **Issues**: [GitHub Issues](https://github.com/yourusername/meme_editor_mobile/issues)
- **Code of Conduct**: Be respectful and inclusive

## ❓ Questions

If you have questions about contributing:

1. Check existing [discussions](https://github.com/yourusername/meme_editor_mobile/discussions)
2. Create a new discussion
3. Ask in issue comments
4. Contact maintainers

## 🏆 Recognition

Contributors will be recognized in:

- Project README
- Release notes
- Hall of fame (coming soon)

Thank you for contributing to Meme Editor Mobile! 🎭✨
