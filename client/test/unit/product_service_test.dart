import 'package:flutter_test/flutter_test.dart';
import 'package:client/data/models/product/create_product_request.dart';

void main() {
  group('Tests Esenciales de Product', () {

    group('Modelo de Producto', () {
      test('debería crear CreateProductRequest correctamente', () {
        // Act
        final request = CreateProductRequest(
          name: 'Producto Test',
          price: 25000,
          stock: 100,
          categoryId: 'cat1',
          providerId: 'prov1',
        );

        // Assert
        expect(request.name, 'Producto Test');
        expect(request.price, 25000.0);
        expect(request.stock, 100);
        expect(request.categoryId, 'cat1');
        expect(request.providerId, 'prov1');
      });

      test('debería validar datos del producto', () {
        // Act
        final request = CreateProductRequest(
          name: 'Test Product',
          price: 100.0,
          stock: 10,
          categoryId: 'cat1',
          providerId: 'prov1',
        );
        
        // Assert
        expect(request.price > 0, isTrue);
        expect(request.name.isNotEmpty, isTrue);
      });
    });
  });
}
