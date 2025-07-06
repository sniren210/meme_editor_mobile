import 'package:flutter/material.dart';

/// Extension to access custom app colors easily
extension AppColorsExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  
  /// Custom semantic colors for the app
  Color get successColor => isDarkMode 
      ? const Color(0xFF00C896) 
      : const Color(0xFF00A86B);
      
  Color get warningColor => isDarkMode 
      ? const Color(0xFFFFB020) 
      : const Color(0xFFFF8F00);
      
  Color get infoColor => isDarkMode 
      ? const Color(0xFF2196F3) 
      : const Color(0xFF1976D2);
      
  Color get surfaceGradientStart => colors.surface;
  Color get surfaceGradientEnd => colors.surfaceContainerHighest.withOpacity(0.3);
  
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

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
        colorScheme.surface,
        colorScheme.surfaceContainer,
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
