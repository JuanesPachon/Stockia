class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  
  static const String categories = '$baseUrl/categories';
  static String categoryById(String id) => '$categories/$id';
  
  static const String products = '$baseUrl/products';
  static String productById(String id) => '$products/$id';
  
  static const String providers = '$baseUrl/providers';
  static String providerById(String id) => '$providers/$id';
  
  static const String notes = '$baseUrl/notes';
  static String noteById(String id) => '$notes/$id';
  
  static const String expenses = '$baseUrl/expenses';
  static String expenseById(String id) => '$expenses/$id';
  
  static const String sales = '$baseUrl/sales';
  static String saleById(String id) => '$sales/$id';
  
  static const String user = '$baseUrl/user';
}