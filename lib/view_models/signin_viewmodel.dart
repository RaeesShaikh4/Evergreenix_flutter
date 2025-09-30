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
