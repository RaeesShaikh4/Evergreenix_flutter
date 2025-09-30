import 'package:flutter/material.dart';

import '../core/network/api_exceptions.dart';
import '../reposatories/auth_repository.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  SignupViewModel(this._repository);

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

    Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final response = await _repository.signUp(
          name: name, email: email, password: password, phoneNumber: phoneNumber);

      // Inspect response and determine success. This depends on API's response format.
      // Example assumes API returns a JSON object with "success" or similar.
      // If your API returns different structure, change handling accordingly.

      _setLoading(false);

      // If response contains an error field, mark as failed
      if (response is Map && (response['error'] != null || response['success'] == false)) {
        final message = response['message'] ?? response['error'] ?? 'Signup failed';
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
}
