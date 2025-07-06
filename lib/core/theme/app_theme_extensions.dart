import 'package:flutter/material.dart';

/// Theme extensions following Material 3 design guidelines and Flutter best practices.
/// 
/// This file provides:
/// - Properly configured ColorScheme for light and dark themes
/// - Extension methods for easy theme access
/// - Semantic color utilities
/// - Consistent gradients, shadows, and animations
/// 
/// Best practices implemented:
/// - Complete Material 3 color roles (surface variants, containers, etc.)
/// - Proper contrast ratios for accessibility
/// - Semantic color naming for better maintainability
/// - Surface elevation mapping

/// Extension to access custom app colors easily
extension AppColorsExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Get appropriate surface color based on elevation level
  Color surfaceAtElevation(double elevation) {
    final colorScheme = Theme.of(this).colorScheme;
    if (elevation <= 0) return colorScheme.surface;
    if (elevation <= 1) return colorScheme.surfaceContainerLow;
    if (elevation <= 3) return colorScheme.surfaceContainer;
    if (elevation <= 6) return colorScheme.surfaceContainerHigh;
    return colorScheme.surfaceContainerHighest;
  }
  
  /// Get appropriate text color for a given background color
  Color getOnColor(Color backgroundColor) {
    final colorScheme = Theme.of(this).colorScheme;
    if (backgroundColor == colorScheme.primary) return colorScheme.onPrimary;
    if (backgroundColor == colorScheme.primaryContainer) return colorScheme.onPrimaryContainer;
    if (backgroundColor == colorScheme.secondary) return colorScheme.onSecondary;
    if (backgroundColor == colorScheme.secondaryContainer) return colorScheme.onSecondaryContainer;
    if (backgroundColor == colorScheme.tertiary) return colorScheme.onTertiary;
    if (backgroundColor == colorScheme.tertiaryContainer) return colorScheme.onTertiaryContainer;
    if (backgroundColor == colorScheme.error) return colorScheme.onError;
    if (backgroundColor == colorScheme.errorContainer) return colorScheme.onErrorContainer;
    if (backgroundColor == colorScheme.surface) return colorScheme.onSurface;
    if (backgroundColor == colorScheme.inverseSurface) return colorScheme.onInverseSurface;
    
    // Fallback: calculate based on luminance
    return backgroundColor.computeLuminance() > 0.5 
        ? colorScheme.onSurface 
        : colorScheme.surface;
  }
}

ThemeData get lightTheme => ThemeData.from(
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: Color(0xFF1976D2), // Blue
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFBBDEFB),
        onPrimaryContainer: Color(0xFF0D47A1),
        secondary: Color(0xFF388E3C), // Green
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFC8E6C9),
        onSecondaryContainer: Color(0xFF1B5E20),
        tertiary: Color(0xFF7B1FA2), // Purple
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFE1BEE7),
        onTertiaryContainer: Color(0xFF4A148C),
        error: Color(0xFFD32F2F),
        onError: Colors.white,
        errorContainer: Color(0xFFFFCDD2),
        onErrorContainer: Color(0xFFB71C1C),
        surface: Color(0xFFFFFBFE),
        onSurface: Color(0xFF1C1B1F),
        surfaceContainerLowest: Color(0xFFFFFFFF),
        surfaceContainerLow: Color(0xFFF7F2FA),
        surfaceContainer: Color(0xFFF3EDF7),
        surfaceContainerHigh: Color(0xFFECE6F0),
        surfaceContainerHighest: Color(0xFFE6E0E9),
        onSurfaceVariant: Color(0xFF49454F),
        outline: Color(0xFF79747E),
        outlineVariant: Color(0xFFCAC4D0),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF313033),
        onInverseSurface: Color(0xFFF4EFF4),
        inversePrimary: Color(0xFF64B5F6),
      ),
      useMaterial3: true,
    );

ThemeData get darkTheme => ThemeData.from(
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: Color(0xFF64B5F6), // Light Blue
        onPrimary: Color(0xFF0D47A1),
        primaryContainer: Color(0xFF1565C0),
        onPrimaryContainer: Color(0xFFBBDEFB),
        secondary: Color(0xFF81C784), // Light Green
        onSecondary: Color(0xFF1B5E20),
        secondaryContainer: Color(0xFF2E7D32),
        onSecondaryContainer: Color(0xFFC8E6C9),
        tertiary: Color(0xFFBA68C8), // Light Purple
        onTertiary: Color(0xFF4A148C),
        tertiaryContainer: Color(0xFF7B1FA2),
        onTertiaryContainer: Color(0xFFE1BEE7),
        error: Color(0xFFEF5350),
        onError: Color(0xFFB71C1C),
        errorContainer: Color(0xFFD32F2F),
        onErrorContainer: Color(0xFFFFCDD2),
        surface: Color(0xFF10131C),
        onSurface: Color(0xFFE6E0E9),
        surfaceContainerLowest: Color(0xFF0B0E17),
        surfaceContainerLow: Color(0xFF191C24),
        surfaceContainer: Color(0xFF1D2027),
        surfaceContainerHigh: Color(0xFF272A32),
        surfaceContainerHighest: Color(0xFF32353D),
        onSurfaceVariant: Color(0xFFCAC4D0),
        outline: Color(0xFF938F99),
        outlineVariant: Color(0xFF49454F),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE6E0E9),
        onInverseSurface: Color(0xFF313033),
        inversePrimary: Color(0xFF1976D2),
      ),
      useMaterial3: true,
    );

/// Custom gradients for the app
class AppGradients {
  static LinearGradient primaryGradient(ColorScheme colorScheme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.primary,
        colorScheme.secondary,
        colorScheme.tertiary,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  static LinearGradient surfaceGradient(ColorScheme colorScheme) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colorScheme.surface,
        colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ],
    );
  }

  static LinearGradient cardGradient(ColorScheme colorScheme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.surfaceContainer,
        colorScheme.surfaceContainerHigh,
      ],
    );
  }
  
  static LinearGradient containerGradient(ColorScheme colorScheme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.primaryContainer,
        colorScheme.secondaryContainer,
      ],
    );
  }

  static LinearGradient overlayGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withOpacity(0.7),
      ],
      stops: const [0.6, 1.0],
    );
  }
}

/// Custom shadows for consistent elevation
class AppShadows {
  static List<BoxShadow> card(ColorScheme colorScheme, {bool isElevated = false}) {
    return [
      BoxShadow(
        color: colorScheme.shadow.withOpacity(isElevated ? 0.15 : 0.08),
        blurRadius: isElevated ? 12 : 6,
        offset: Offset(0, isElevated ? 6 : 3),
      ),
    ];
  }

  static List<BoxShadow> button(ColorScheme colorScheme) {
    return [
      BoxShadow(
        color: colorScheme.primary.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> floatingActionButton(ColorScheme colorScheme) {
    return [
      BoxShadow(
        color: colorScheme.shadow.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

/// Animation constants for consistent timing
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 2500);

  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve elastic = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
}

/// Spacing constants for consistent layout
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}

/// Border radius constants
class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 100.0;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
  static BorderRadius circularSm = circular(sm);
  static BorderRadius circularMd = circular(md);
  static BorderRadius circularLg = circular(lg);
  static BorderRadius circularXl = circular(xl);
}

/// Semantic color utility for consistent color usage
class AppSemanticColors {
  static Color success(ColorScheme colorScheme) => colorScheme.secondary;
  static Color onSuccess(ColorScheme colorScheme) => colorScheme.onSecondary;
  static Color successContainer(ColorScheme colorScheme) => colorScheme.secondaryContainer;
  static Color onSuccessContainer(ColorScheme colorScheme) => colorScheme.onSecondaryContainer;
  
  static Color warning(ColorScheme colorScheme) => colorScheme.tertiary;
  static Color onWarning(ColorScheme colorScheme) => colorScheme.onTertiary;
  static Color warningContainer(ColorScheme colorScheme) => colorScheme.tertiaryContainer;
  static Color onWarningContainer(ColorScheme colorScheme) => colorScheme.onTertiaryContainer;
  
  static Color info(ColorScheme colorScheme) => colorScheme.primary;
  static Color onInfo(ColorScheme colorScheme) => colorScheme.onPrimary;
  static Color infoContainer(ColorScheme colorScheme) => colorScheme.primaryContainer;
  static Color onInfoContainer(ColorScheme colorScheme) => colorScheme.onPrimaryContainer;
  
  // Aliases for Material 3 surface variants
  static Color surfaceLowest(ColorScheme colorScheme) => colorScheme.surfaceContainerLowest;
  static Color surfaceLow(ColorScheme colorScheme) => colorScheme.surfaceContainerLow;
  static Color surfaceHigh(ColorScheme colorScheme) => colorScheme.surfaceContainerHigh;
  static Color surfaceHighest(ColorScheme colorScheme) => colorScheme.surfaceContainerHighest;
}
