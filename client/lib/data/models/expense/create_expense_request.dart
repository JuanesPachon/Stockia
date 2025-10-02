class CreateExpenseRequest {
  final String title;
  final double amount;
  final String description;
  final String? categoryId;
  final String? providerId;

  CreateExpenseRequest({
    required this.title,
    required this.amount,
    required this.description,
    this.categoryId,
    this.providerId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'amount': amount,
      'description': description,
    };
    
    if (categoryId != null && categoryId!.isNotEmpty) {
      data['categoryId'] = categoryId;
    }

    if (providerId != null && providerId!.isNotEmpty) {
      data['providerId'] = providerId;
    }
    
    return data;
  }

}