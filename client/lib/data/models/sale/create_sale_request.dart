class CreateSaleProductRequest {
  final String productId;
  final int quantity;

  CreateSaleProductRequest({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class CreateSaleRequest {
  final List<CreateSaleProductRequest> products;
  final double total;

  CreateSaleRequest({
    required this.products,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'total': total,
    };
  }
}