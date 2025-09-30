import 'package:provider/provider.dart';
import '../../reposatories/auth_repository.dart';
import '../../view_models/signup_viewmodel.dart';
import '../../view_models/signin_viewmodel.dart';

class AppProviders {
  static List<ChangeNotifierProvider> getProviders(AuthRepository authRepository) {
    return [
      ChangeNotifierProvider<SignupViewModel>(
        create: (_) => SignupViewModel(authRepository),
      ),
      ChangeNotifierProvider<SigninViewModel>(
        create: (_) => SigninViewModel(authRepository),
      ),
      // Add new ViewModels here as you create them
      // ChangeNotifierProvider<HomeViewModel>(
      //   create: (_) => HomeViewModel(authRepository),
      // ),
      // ChangeNotifierProvider<ProfileViewModel>(
      //   create: (_) => ProfileViewModel(authRepository),
      // ),
    ];
  }
}
