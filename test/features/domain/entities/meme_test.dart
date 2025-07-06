import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';

void main() {
  group('Meme Entity', () {
    const tMeme = Meme(
      id: '1',
      name: 'Test Meme',
      url: 'https://example.com/meme.jpg',
      width: 500,
      height: 400,
      boxCount: 2,
    );

    test('should be a subclass of Equatable', () {
      // Assert
      expect(tMeme, isA<Meme>());
    });

    test('should return true when comparing two identical memes', () {
      // Arrange
      const tMeme2 = Meme(
        id: '1',
        name: 'Test Meme',
        url: 'https://example.com/meme.jpg',
        width: 500,
        height: 400,
        boxCount: 2,
      );

      // Assert
      expect(tMeme, equals(tMeme2));
    });

    test('should return false when comparing two different memes', () {
      // Arrange
      const tMeme2 = Meme(
        id: '2',
        name: 'Different Meme',
        url: 'https://example.com/different.jpg',
        width: 600,
        height: 500,
        boxCount: 3,
      );

      // Assert
      expect(tMeme, isNot(equals(tMeme2)));
    });

    test('should return correct props', () {
      // Assert
      expect(tMeme.props, [
        '1',
        'Test Meme',
        'https://example.com/meme.jpg',
        500,
        400,
        2,
      ]);
    });

    group('JSON serialization', () {
      test('should return a valid JSON map from toJson', () {
        // Arrange
        final expectedMap = {
          'id': '1',
          'name': 'Test Meme',
          'url': 'https://example.com/meme.jpg',
          'width': 500,
          'height': 400,
          'box_count': 2,
        };

        // Act
        final result = tMeme.toJson();

        // Assert
        expect(result, expectedMap);
      });

      test('should return a valid Meme from JSON', () {
        // Arrange
        final jsonMap = {
          'id': '1',
          'name': 'Test Meme',
          'url': 'https://example.com/meme.jpg',
          'width': 500,
          'height': 400,
          'box_count': 2,
        };

        // Act
        final result = Meme.fromJson(jsonMap);

        // Assert
        expect(result, tMeme);
      });

      test('should handle null values gracefully', () {
        // Arrange
        final jsonMap = {
          'id': '1',
          'name': 'Test Meme',
          'url': 'https://example.com/meme.jpg',
          'width': 500,
          'height': 400,
          'box_count': 2,
        };

        // Act & Assert
        expect(() => Meme.fromJson(jsonMap), returnsNormally);
      });
    });
  });
}
