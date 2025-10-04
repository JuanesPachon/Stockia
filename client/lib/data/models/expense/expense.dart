class Expense {
  final String id;
  final String userId;
  final String title;
  final String? categoryId;
  final String? categoryName;
  final double amount;
  final String? providerId;
  final String? providerName;
  final String description;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    this.categoryId,
    this.categoryName,
    required this.amount,
    this.providerId,
    this.providerName,
    required this.description,
    required this.createdAt,
    this.deletedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
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
    
    return Expense(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      categoryId: categoryId,
      categoryName: categoryName,
      amount: (json['amount'] ?? 0).toDouble(),
      providerId: providerId,
      providerName: providerName,
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'categoryId': categoryId,
      'amount': amount,
      'providerId': providerId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

}