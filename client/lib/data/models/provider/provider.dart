class Provider {
  final String id;
  final String userId;
  final String name;
  final String? categoryId;
  final String? contact;
  final String? description;
  final bool status;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Provider({
    required this.id,
    required this.userId,
    required this.name,
    this.categoryId,
    this.contact,
    this.description,
    required this.status,
    required this.createdAt,
    this.deletedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    if (json['categoryId'] is String) {
      categoryId = json['categoryId'];
    } else if (json['categoryId'] is Map<String, dynamic>) {
      final categoryMap = json['categoryId'] as Map<String, dynamic>;
      categoryId = categoryMap['_id'] ?? categoryMap['id'];
    } else {
      categoryId = null;
    }
    
    return Provider(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      categoryId: categoryId,
      contact: json['contact'],
      description: json['description'],
      status: json['status'] ?? true,
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
      'contact': contact,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

}