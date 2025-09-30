import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_dimensions.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_spacing.dart';
import '../core/widgets/app_loading.dart';
import '../view_models/home_viewmodel.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize session data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().initializeSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Home',
          style: AppTextStyles.headline3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(context, viewModel);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: AppLoading(),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(viewModel),
                AppSpacing.verticalL(),
                _buildUserInfoSection(viewModel),
                AppSpacing.verticalL(),
                _buildActionButtons(context, viewModel),
                AppSpacing.verticalL(),
                _buildErrorMessage(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(HomeViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: AppTextStyles.headline1.copyWith(
              color: Colors.white,
            ),
          ),
          AppSpacing.verticalS(),
          Text(
            viewModel.userEmail ?? 'User',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(HomeViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalM(),
          _buildInfoRow('Email', viewModel.userEmail ?? 'Not available'),
          AppSpacing.verticalS(),
          _buildInfoRow('Status', viewModel.isLoggedIn ? 'Logged In' : 'Not Logged In'),
          AppSpacing.verticalS(),
          _buildInfoRow('Session', 'Active'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            '$label:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, HomeViewModel viewModel) {
    return Column(
      children: [
        AppButton(
          text: 'Refresh Session',
          onPressed: () {
            viewModel.refreshSession();
          },
          isLoading: viewModel.isLoading,
        ),
        AppSpacing.verticalM(),
        AppButton(
          text: 'Logout',
          onPressed: () {
            _showLogoutDialog(context, viewModel);
          },
          isLoading: viewModel.isLoading,
          backgroundColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildErrorMessage(HomeViewModel viewModel) {
    if (viewModel.errorMessage == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          AppSpacing.horizontalS(),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.clearError();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await viewModel.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}