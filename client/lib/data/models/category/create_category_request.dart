class CreateCategoryRequest {
  final String name;
  final String? description;

  CreateCategoryRequest({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
    };
    
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    
    return data;
  }
}