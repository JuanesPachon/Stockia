class Note {
  final String id;
  final String userId;
  final String title;
  final String? categoryId;
  final String description;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    this.categoryId,
    required this.description,
    required this.createdAt,
    this.deletedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    if (json['categoryId'] is String) {
      categoryId = json['categoryId'];
    } else if (json['categoryId'] is Map<String, dynamic>) {
      final categoryMap = json['categoryId'] as Map<String, dynamic>;
      categoryId = categoryMap['_id'] ?? categoryMap['id'];
    } else {
      categoryId = null;
    }
    
    return Note(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      categoryId: categoryId,
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
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

}