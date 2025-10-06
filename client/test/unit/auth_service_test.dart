import 'package:flutter_test/flutter_test.dart';
import 'package:client/data/models/auth/login_request.dart';
import 'package:client/data/models/auth/register_request.dart';

void main() {
  group('Tests Esenciales de Auth', () {

    group('Modelos de Autenticación', () {
      test('debería crear LoginRequest correctamente', () {
        // Act
        final loginRequest = LoginRequest(
          email: 'test@test.com',
          password: 'password123',
        );

        // Assert
        expect(loginRequest.email, 'test@test.com');
        expect(loginRequest.password, 'password123');
        expect(loginRequest.toJson()['email'], 'test@test.com');
      });

      test('debería crear RegisterRequest correctamente', () {
        // Act
        final registerRequest = RegisterRequest(
          name: 'Test User',
          email: 'test@test.com',
          password: 'password123',
        );

        // Assert
        expect(registerRequest.name, 'Test User');
        expect(registerRequest.email, 'test@test.com');
        expect(registerRequest.password, 'password123');
      });

      test('debería validar campos básicos', () {
        // Act
        final loginRequest = LoginRequest(
          email: 'test@test.com',
          password: 'password123',
        );

        // Assert
        expect(loginRequest.email.contains('@'), true);
        expect(loginRequest.password.isNotEmpty, true);
      });
    });
  });
}
