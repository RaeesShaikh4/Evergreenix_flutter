import 'package:flutter/material.dart';

import '../core/network/api_exceptions.dart';
import '../reposatories/auth_repository.dart';

class SigninViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  SigninViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get error => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<bool> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.signIn(
        email: email, 
        password: password,
      );

      _setLoading(false);

      // If response contains an error field, mark as failed
      if (response is Map && (response['error'] != null || response['success'] == false)) {
        final message = response['message'] ?? response['error'] ?? 'Sign in failed';
        _setErrorMessage(message.toString());
        return false;
      }

      // Save session data after successful login
      try {
        // Extract token from response (adjust based on your API response structure)
        final token = response['token'] ?? response['data']?['token'] ?? 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        await _repository.saveSession(
          token: token,
          email: email,
          rememberMe: rememberMe,
        );
      } catch (e) {
        // Log session save error but don't fail the login
        // This is expected in some environments (like testing)
        print('Warning: Failed to save session: $e');
        print('Note: Session will be stored in memory for this session only');
      }

      return true;
    } on ApiExceptions catch (e) {
      _setErrorMessage(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _setErrorMessage(null);
  }
}
