import 'package:flutter/material.dart';
import '../models/home_products.dart';
import '../reposatories/auth_repository.dart';
import '../reposatories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final HomeRepository homeRepository;
  
  HomeViewModel(this.authRepository, this.homeRepository);

  bool _isLoading = false;
  bool _isLoadingProducts = false;
  String? _errorMessage;
  String? _userEmail;
  bool _isLoggedIn = false;
  List<Product> _products = [];

  bool get isLoading => _isLoading;
  bool get isLoadingProducts => _isLoadingProducts;
  String? get errorMessage => _errorMessage;
  String? get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;
  List<Product> get products => _products;

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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshSession() async {
    await initializeSession();
  }

  Future<void> getHomeProducts({int? limit, int? skip}) async {
    _isLoadingProducts = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final productResponse = await homeRepository.getHomeProducts(
        limit: limit,
        skip: skip,
      );
      _products = productResponse.products;
    } catch (e) {
      _errorMessage = 'Failed to fetch home products: ${e.toString()}';
      _products = [];
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  void clearProducts() {
    _products = [];
    notifyListeners();
  }
}
