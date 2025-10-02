class CreateProductRequest {
  final String name;
  final String? categoryId;
  final String? providerId;
  final int stock;
  final double price;
  final String? imageUrl;

  CreateProductRequest({
    required this.name,
    this.categoryId,
    this.providerId,
    required this.stock,
    required this.price,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'stock': stock,
      'price': price,
    };
    
    if (categoryId != null && categoryId!.isNotEmpty) {
      data['categoryId'] = categoryId;
    }

    if (providerId != null && providerId!.isNotEmpty) {
      data['providerId'] = providerId;
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      data['imageUrl'] = imageUrl;
    }
    
    return data;
  }

}