import 'package:flutter/material.dart';
import '../reposatories/auth_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  
  HomeViewModel(this.authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  String? _userEmail;
  bool _isLoggedIn = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;

  // Initialize session data
  Future<void> initializeSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final sessionData = await authRepository.getSessionData();
      _isLoggedIn = sessionData['isLoggedIn'] ?? false;
      _userEmail = sessionData['email'];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load session data: ${e.toString()}';
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout functionality
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.logout();
      _isLoggedIn = false;
      _userEmail = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to logout: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh session data
  Future<void> refreshSession() async {
    await initializeSession();
  }
}
