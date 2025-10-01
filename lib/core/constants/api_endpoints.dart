class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://demo.marinecareerlink.com/api/v1/';
  static const String dummyJsonUrl = 'https://dummyjson.com/';

  // Api Endpoints
  static const String signUp = 'account/signup';
  static const String signIn = 'account/signin';

  static const String homeProducts = 'products';
  static String productDetail(int id) => 'products/$id';
}
