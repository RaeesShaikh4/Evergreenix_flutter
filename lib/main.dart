import 'package:evergreenix_flutter_task/core/constants/api_endpoints.dart';
import 'package:evergreenix_flutter_task/view_models/signup_viewmodel.dart';
import 'package:evergreenix_flutter_task/view_models/signin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/network/api_client.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/providers/app_providers.dart';
import 'reposatories/auth_repository.dart';
import 'views/signup_screen.dart';

void main() {
  final apiClient = ApiClient(baseUrl: ApiEndpoints.baseUrl);
  final authRepository = AuthRepository(apiClient);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.getProviders(authRepository),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Evergreenix Flutter Task',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: AppColors.primary,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: AppColors.background,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                centerTitle: true,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error, width: 2),
                ),
              ),
              cardTheme: CardTheme(
                color: AppColors.surface,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textTheme: TextTheme(
                headlineLarge: AppTextStyles.headline1,
                headlineMedium: AppTextStyles.headline2,
                headlineSmall: AppTextStyles.headline3,
                titleLarge: AppTextStyles.headline4,
                bodyLarge: AppTextStyles.bodyLarge,
                bodyMedium: AppTextStyles.bodyMedium,
                bodySmall: AppTextStyles.bodySmall,
                labelLarge: AppTextStyles.labelLarge,
                labelMedium: AppTextStyles.labelMedium,
                labelSmall: AppTextStyles.labelSmall,
              ),
            ),
            home: const SignUpScreen(),
          );
        },
      ),
    );
  }
}