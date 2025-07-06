import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';

void main() {
  group('Failures', () {
    group('NetworkFailure', () {
      test('should have correct message', () {
        // Arrange
        const message = 'Network connection failed';
        const failure = NetworkFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.props, [message]);
      });

      test('should be equal when messages are the same', () {
        // Arrange
        const message = 'Network error';
        const failure1 = NetworkFailure(message);
        const failure2 = NetworkFailure(message);

        // Assert
        expect(failure1, equals(failure2));
      });

      test('should not be equal when messages are different', () {
        // Arrange
        const failure1 = NetworkFailure('Error 1');
        const failure2 = NetworkFailure('Error 2');

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });
    });

    group('ServerFailure', () {
      test('should have correct message', () {
        // Arrange
        const message = 'Server error occurred';
        const failure = ServerFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.props, [message]);
      });
    });

    group('CacheFailure', () {
      test('should have correct message', () {
        // Arrange
        const message = 'Cache operation failed';
        const failure = CacheFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.props, [message]);
      });
    });

    group('PermissionFailure', () {
      test('should have correct message', () {
        // Arrange
        const message = 'Permission denied';
        const failure = PermissionFailure(message);

        // Assert
        expect(failure.message, message);
        expect(failure.props, [message]);
      });
    });
  });
}
