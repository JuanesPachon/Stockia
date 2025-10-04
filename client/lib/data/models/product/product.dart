class Product {
  final String id;  
  final String userId;
  final String name;
  final String? categoryId;
  final String? categoryName;
  final String? providerId;
  final String? providerName;
  final int stock;
  final double price;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.userId,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.providerId,
    this.providerName,
    required this.stock,
    required this.price,
    this.imageUrl,
    required this.createdAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    String? categoryName;
    if (json['categoryId'] is String) {
      categoryId = json['categoryId'];
      categoryName = null;
    } else if (json['categoryId'] is Map<String, dynamic>) {
      final categoryMap = json['categoryId'] as Map<String, dynamic>;
      categoryId = categoryMap['_id'] ?? categoryMap['id'];
      categoryName = categoryMap['name']; 
    } else {
      categoryId = null;
      categoryName = null;
    }

    String? providerId;
    String? providerName;
    if (json['providerId'] is String) {
      providerId = json['providerId'];
      providerName = null;
    } else if (json['providerId'] is Map<String, dynamic>) {
      final providerMap = json['providerId'] as Map<String, dynamic>;
      providerId = providerMap['_id'] ?? providerMap['id'];
      providerName = providerMap['name']; 
    } else {
      providerId = null;
      providerName = null;
    }
    
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      categoryId: categoryId,
      categoryName: categoryName,
      providerId: providerId,
      providerName: providerName,
      stock: (json['stock'] ?? 0).toInt(),
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'categoryId': categoryId,
      'providerId': providerId,
      'stock': stock,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

}