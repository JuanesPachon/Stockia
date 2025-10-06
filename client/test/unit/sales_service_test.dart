import 'package:flutter_test/flutter_test.dart';
import 'package:client/data/models/sale/create_sale_request.dart';

void main() {
  group('Tests Esenciales de Sale', () {

    group('Modelo de Venta', () {
      test('debería crear CreateSaleRequest correctamente', () {
        // Arrange
        final productRequest = CreateSaleProductRequest(
          productId: 'prod1',
          quantity: 2,
        );

        // Act
        final saleRequest = CreateSaleRequest(
          products: [productRequest],
          total: 50000.0,
        );

        // Assert
        expect(saleRequest.products.length, 1);
        expect(saleRequest.total, 50000.0);
        expect(saleRequest.products.first.productId, 'prod1');
        expect(saleRequest.products.first.quantity, 2);
      });

      test('debería validar datos de la venta', () {
        // Act
        final productRequest = CreateSaleProductRequest(
          productId: 'prod1',
          quantity: 5,
        );
        
        final saleRequest = CreateSaleRequest(
          products: [productRequest],
          total: 100000.0,
        );
        
        // Assert
        expect(saleRequest.total > 0, isTrue);
        expect(saleRequest.products.isNotEmpty, isTrue);
      });
    });
  });
}
