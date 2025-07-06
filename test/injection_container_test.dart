import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meme_editor_mobile/injection_container.dart' as di;

void main() {
  group('Dependency Injection', () {
    setUp(() {
      // Reset GetIt before each test
      GetIt.instance.reset();
    });

    test('should initialize dependencies without throwing', () async {
      // Act & Assert
      expect(() async => await di.init(), returnsNormally);
    });

    test('should register all required dependencies', () async {
      // Act
      await di.init();

      // Assert - Check that key dependencies are registered
      expect(di.sl.isRegistered<SharedPreferences>(), isTrue);
      expect(di.sl.isRegistered<http.Client>(), isTrue);
      expect(di.sl.isRegistered<Connectivity>(), isTrue);
      
      // Note: Some dependencies might not be testable in unit tests
      // due to platform-specific requirements (like SharedPreferences)
    });

    test('should provide singleton instances', () async {
      // Act
      await di.init();

      // Assert - Get the same instance multiple times
      final client1 = di.sl<http.Client>();
      final client2 = di.sl<http.Client>();
      expect(identical(client1, client2), isTrue);
    });

    tearDown(() {
      // Clean up after each test
      GetIt.instance.reset();
    });
  });
}
