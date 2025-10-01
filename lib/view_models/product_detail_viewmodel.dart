import 'package:flutter/material.dart';
import '../models/product_detail.dart';
import '../reposatories/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository productRepository;
  
  ProductDetailViewModel(this.productRepository);

  bool _isLoading = false;
  String? _errorMessage;
  ProductDetail? _product;
  int _selectedImageIndex = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProductDetail? get product => _product;
  int get selectedImageIndex => _selectedImageIndex;

  Future<void> fetchProductDetail(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _product = await productRepository.getProductDetail(productId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load product details: ${e.toString()}';
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectImage(int index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _product = null;
    _selectedImageIndex = 0;
    notifyListeners();
  }
}

