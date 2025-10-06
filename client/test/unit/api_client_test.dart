import 'package:flutter_test/flutter_test.dart';
import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_response.dart';

void main() {
  group('Tests Esenciales de ApiClient', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
    });

    group('Manejo de Respuestas', () {
      test('debería crear ApiResponse exitosa', () {
        // Act
        final response = ApiResponse.success(data: 'test data', message: 'Success');

        // Assert
        expect(response.success, true);
        expect(response.data, 'test data');
        expect(response.message, 'Success');
      });

      test('debería crear ApiResponse de error', () {
        // Act
        final response = ApiResponse.error('Test error');

        // Assert
        expect(response.success, false);
        expect(response.error, 'Test error');
      });
    });

    group('Funcionalidad Básica', () {
      test('debería ser una instancia singleton', () {
        // Act
        final instance1 = ApiClient();
        final instance2 = ApiClient();

        // Assert
        expect(identical(instance1, instance2), true);
      });

      test('debería tener métodos HTTP principales', () {
        // Assert
        expect(apiClient.get, isA<Function>());
        expect(apiClient.post, isA<Function>());
      });
    });
  });
}