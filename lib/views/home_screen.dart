import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_dimensions.dart';
import '../core/widgets/app_spacing.dart';
import '../core/widgets/app_loading.dart';
import '../view_models/home_viewmodel.dart';
import 'product_detail_screen.dart';
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
    // Initialize session data and load products when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<HomeViewModel>();
      viewModel.initializeSession();
      viewModel.getHomeProducts(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            AppSpacing.horizontalM(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Shop',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    return Text(
                      viewModel.userEmail ?? 'Guest',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout,
                color: AppColors.error,
                size: 20.sp,
              ),
            ),
            onPressed: () {
              _showLogoutDialog(context, context.read<HomeViewModel>());
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: AppLoading(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductsSection(viewModel),
                      AppSpacing.verticalL(),
                      _buildErrorMessage(viewModel),
                      SizedBox(height: 80.h), // Space for floating button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductsSection(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primaryLight.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Products',
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalXS(),
                  Text(
                    '${viewModel.products.length} items available',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (viewModel.isLoadingProducts)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
            ],
          ),
        ),
        AppSpacing.verticalL(),
        if (viewModel.products.isEmpty && !viewModel.isLoadingProducts)
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                'No products available',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.products.length,
            separatorBuilder: (context, index) => AppSpacing.verticalM(),
            itemBuilder: (context, index) {
              final product = viewModel.products[index];
              return _buildProductCard(product);
            },
          ),
      ],
    );
  }

  Widget _buildProductCard(product) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(productId: product.id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surface,
                      AppColors.primaryLight.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'product-${product.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          child: Image.network(
                            product.thumbnail,
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.border,
                                      AppColors.primaryLight.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.horizontalM(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.verticalS(),
                          Text(
                            product.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.verticalM(),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.primary, AppColors.primaryDark],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              AppSpacing.horizontalS(),
                              if (product.discountPercentage > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.error,
                                        AppColors.error.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_offer,
                                        color: Colors.white,
                                        size: 12.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${product.discountPercentage.toStringAsFixed(0)}%',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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