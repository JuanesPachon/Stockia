class CreateNoteRequest {
  final String title;
  final String description;
  final String? categoryId;

  CreateNoteRequest({
    required this.title,
    required this.description,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
    };
    
    if (categoryId != null && categoryId!.isNotEmpty) {
      data['categoryId'] = categoryId;
    }
    
    return data;
  }

  @override
  String toString() {
    return 'CreateNoteRequest{title: $title, description: $description, categoryId: $categoryId}';
  }

}