class User {
  final String id;
  final String email;
  final String name;
  final String businessName;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.businessName,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      businessName: json['businessName'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'businessName': businessName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}