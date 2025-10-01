import 'package:provider/provider.dart';
import '../../reposatories/auth_repository.dart';
import '../../reposatories/home_repository.dart';
import '../../reposatories/product_repository.dart';
import '../../view_models/signup_viewmodel.dart';
import '../../view_models/signin_viewmodel.dart';
import '../../view_models/home_viewmodel.dart';
import '../../view_models/product_detail_viewmodel.dart';

class AppProviders {
  static List<ChangeNotifierProvider> getProviders(
    AuthRepository authRepository,
    HomeRepository homeRepository,
    ProductRepository productRepository,
  ) {
    return [
      ChangeNotifierProvider<SignupViewModel>(
        create: (_) => SignupViewModel(authRepository),
      ),
      ChangeNotifierProvider<SigninViewModel>(
        create: (_) => SigninViewModel(authRepository),
      ),
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(authRepository, homeRepository),
      ),
      ChangeNotifierProvider<ProductDetailViewModel>(
        create: (_) => ProductDetailViewModel(productRepository),
      ),
    ];
  }
}
