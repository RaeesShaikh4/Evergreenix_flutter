import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_dimensions.dart';
import '../core/widgets/app_loading.dart';
import '../core/widgets/app_spacing.dart';
import '../view_models/product_detail_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailViewModel>().fetchProductDetail(widget.productId);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<ProductDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: AppLoading());
            }
        
            if (viewModel.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      AppSpacing.verticalM(),
                      Text(
                        viewModel.errorMessage!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.verticalL(),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.fetchProductDetail(widget.productId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
        
            if (viewModel.product == null) {
              return const Center(child: Text('No product data'));
            }
        
            final product = viewModel.product!;
        
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(product),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageGallery(viewModel, product),
                          AppSpacing.verticalL(),
                          _buildProductInfo(product),
                          AppSpacing.verticalL(),
                          _buildPriceSection(product),
                          AppSpacing.verticalL(),
                          _buildStockAndRating(product),
                          AppSpacing.verticalL(),
                          _buildDescription(product),
                          AppSpacing.verticalL(),
                          _buildDetails(product),
                          AppSpacing.verticalL(),
                          _buildTags(product),
                          AppSpacing.verticalXL(),
                          _buildAddToCartButton(),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(product) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        product.title,
        style: AppTextStyles.headline4.copyWith(
          color: AppColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.textPrimary),
          onPressed: () {
            // Share functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppColors.textPrimary),
          onPressed: () {
            // Favorite functionality
          },
        ),
      ],
    );
  }

  Widget _buildImageGallery(ProductDetailViewModel viewModel, product) {
    final images = product.images.isNotEmpty ? product.images : [product.thumbnail];

    return Column(
      children: [
        // Main Image with shimmer effect
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(viewModel.selectedImageIndex),
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface,
                  AppColors.primaryLight.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Hero(
              tag: 'product-image-${product.id}',
              child: Image.network(
                images[viewModel.selectedImageIndex],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.border,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        // Image Thumbnails
        if (images.length > 1) ...[
          AppSpacing.verticalM(),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = viewModel.selectedImageIndex == index;
                return GestureDetector(
                  onTap: () => viewModel.selectImage(index),
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.border,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductInfo(product) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalS(),
                  Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.bounceOut,
                        builder: (context, bounceValue, child) {
                          return Transform.scale(
                            scale: bounceValue,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primaryLight.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    size: 16.sp,
                                    color: AppColors.primary,
                                  ),
                                  AppSpacing.horizontalXS(),
                                  Text(
                                    product.category.toUpperCase(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      AppSpacing.horizontalM(),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.branding_watermark_outlined,
                              size: 18.sp,
                              color: AppColors.textSecondary,
                            ),
                            AppSpacing.horizontalXS(),
                            Flexible(
                              child: Text(
                                product.brand,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
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
          ),
        );
      },
    );
  }

  Widget _buildPriceSection(product) {
    final discountedPrice = product.price * (1 - product.discountPercentage / 100);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primaryLight.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.headline1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 32.sp,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          AppSpacing.horizontalS(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (product.discountPercentage > 0) ...[
                      AppSpacing.verticalS(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.error, Color(0xFFE91E63)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_offer,
                              color: Colors.white,
                              size: 16,
                            ),
                            AppSpacing.horizontalXS(),
                            Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary.withOpacity(0.5),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStockAndRating(product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Row(
        children: [
          // Rating
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.warning,
                  size: 20.sp,
                ),
                AppSpacing.horizontalXS(),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalM(),
          // Stock
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: product.stock > 0
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              children: [
                Icon(
                  product.stock > 0 ? Icons.check_circle : Icons.cancel,
                  color: product.stock > 0 ? AppColors.success : AppColors.error,
                  size: 20.sp,
                ),
                AppSpacing.horizontalXS(),
                Text(
                  product.stock > 0 ? '${product.stock} In Stock' : 'Out of Stock',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: product.stock > 0 ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalM(),
          Text(
            product.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalM(),
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildDetailRow('SKU', product.sku),
                _buildDivider(),
                _buildDetailRow('Weight', '${product.weight} kg'),
                _buildDivider(),
                _buildDetailRow('Status', product.availabilityStatus),
                _buildDivider(),
                _buildDetailRow('Warranty', product.warrantyInformation),
                _buildDivider(),
                _buildDetailRow('Shipping', product.shippingInformation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.border,
      height: 1.h,
    );
  }

  Widget _buildTags(product) {
    if (product.tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalM(),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: product.tags.map<Widget>((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart functionality with animation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          AppSpacing.horizontalM(),
                          const Text('Added to cart successfully!'),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  minimumSize: Size(double.infinity, 60.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 0.5,
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 28,
                          ),
                        );
                      },
                    ),
                    AppSpacing.horizontalM(),
                    Text(
                      'Add to Cart',
                      style: AppTextStyles.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
}

