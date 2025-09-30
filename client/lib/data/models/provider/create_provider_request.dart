class CreateProviderRequest {
  final String name;
  final String? contact;
  final String? description;
  final String? categoryId;
  final bool status;

  CreateProviderRequest({
    required this.name,
    this.contact,
    this.description,
    this.categoryId,
    this.status = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'status': status,
    };
    
    if (contact != null && contact!.isNotEmpty) {
      data['contact'] = contact;
    }
    
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    
    if (categoryId != null && categoryId!.isNotEmpty) {
      data['categoryId'] = categoryId;
    }
    
    return data;
  }

}