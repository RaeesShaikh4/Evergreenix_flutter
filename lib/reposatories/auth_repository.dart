import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/services/session_manager.dart';

class AuthRepository {
  final ApiClient apiClient;
  AuthRepository(this.apiClient);

  Future<dynamic> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final payload = {
      'name': name,
      'emailAddress': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };

    final response = await apiClient.post(ApiEndpoints.signUp, body: payload);
    return response;
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    final payload = {
      'email': email,
      'password': password,
    };

    final response = await apiClient.post(ApiEndpoints.signIn, body: payload);
    return response;
  }

  Future<void> saveSession({
    required String token,
    required String email,
    bool rememberMe = false,
  }) async {
    await SessionManager.instance.saveToken(token);
    await SessionManager.instance.saveUserEmail(email);
    await SessionManager.instance.saveRememberMe(rememberMe);
  }

  Future<void> logout() async {
    await SessionManager.instance.logout();
  }

  Future<bool> isLoggedIn() async {
    return await SessionManager.instance.isLoggedIn();
  }

  Future<Map<String, dynamic>> getSessionData() async {
    return await SessionManager.instance.getSessionData();
  }
}
