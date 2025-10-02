import 'product.dart';

class SaleProductItem {
  final Product product;
  final int quantity;

  SaleProductItem({
    required this.product,
    required this.quantity,
  });

  factory SaleProductItem.fromJson(Map<String, dynamic> json) {
    Product product;
    if (json['productId'] is Map<String, dynamic>) {
      product = Product.fromJson(json['productId']);
    } else {
      product = Product(
        id: json['productId']?.toString() ?? '',
        userId: '',
        name: 'Producto desconocido',
        stock: 0,
        price: 0.0,
        createdAt: DateTime.now(),
      );
    }

    return SaleProductItem(
      product: product,
      quantity: (json['quantity'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }
}

class Sale {
  final String id;
  final String userId;
  final List<SaleProductItem> products;
  final double total;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.createdAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    List<SaleProductItem> products = [];
    if (json['products'] is List) {
      final productsList = json['products'] as List;
      for (var productJson in productsList) {
        try {
          if (productJson is Map<String, dynamic>) {
            products.add(SaleProductItem.fromJson(productJson));
          }
        } catch (e) {
          continue;
        }
      }
    }

    return Sale(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      products: products,
      total: (json['total'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}