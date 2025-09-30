import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/validators.dart';
import '../view_models/signin_viewmodel.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/app_spacing.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_dimensions.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final viewModel = context.read<SigninViewModel>();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    final success = await viewModel.signIn(email: email, password: password);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in successful')),
      );
      // Navigate to home screen or main app
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      if (!mounted) return;
      final error = viewModel.error ?? 'Sign in failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SigninViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                AppSpacing.verticalXL(),
                _buildSignInForm(vm),
                AppSpacing.verticalL(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.login_rounded,
            size: AppDimensions.iconXL,
            color: AppColors.textOnPrimary,
          ),
        ),
        AppSpacing.verticalL(),
        Text(
          'Welcome Back',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalS(),
        Text(
          'Sign in to continue your journey',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignInForm(SigninViewModel vm) {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(),
            AppSpacing.verticalM(),
            _buildPasswordField(),
            AppSpacing.verticalM(),
            _buildRememberMeRow(),
            AppSpacing.verticalL(),
            _buildSubmitButton(vm),
            if (vm.error != null) ...[
              AppSpacing.verticalM(),
              _buildErrorMessage(vm.error!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return AppTextField(
      label: 'Email Address',
      hint: 'Enter your email address',
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
      prefixIcon: Icon(
        Icons.email_outlined,
        color: AppColors.primary,
        size: AppDimensions.iconM,
      ),
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      label: 'Password',
      hint: 'Enter your password',
      controller: _passwordCtrl,
      obscureText: true,
      validator: Validators.validatePassword,
      prefixIcon: Icon(
        Icons.lock_outline,
        color: AppColors.primary,
        size: AppDimensions.iconM,
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
          ),
        ),
        AppSpacing.horizontalS(),
        Expanded(
          child: Text(
            'Remember me',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to forgot password screen
            _showForgotPasswordDialog();
          },
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(SigninViewModel vm) {
    return AppButton(
      text: 'Sign In',
      onPressed: _onSubmit,
      type: AppButtonType.primary,
      isLoading: vm.isLoading,
      icon: Icons.arrow_forward_rounded,
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconS,
          ),
          AppSpacing.horizontalM(),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: AppDimensions.dividerThickness,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              child: Text(
                'OR',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: AppDimensions.dividerThickness,
              ),
            ),
          ],
        ),
        AppSpacing.verticalM(), 
        _buildSignUpPrompt(),
      ],
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        _buildSocialButton(
          text: 'Continue with Google',
          icon: Icons.g_mobiledata,
          onPressed: () {
            // Implement Google sign in
            _showComingSoonDialog('Google Sign In');
          },
        ),
        AppSpacing.verticalM(),
        _buildSocialButton(
          text: 'Continue with Apple',
          icon: Icons.apple,
          onPressed: () {
            // Implement Apple sign in
            _showComingSoonDialog('Apple Sign In');
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeightM,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          backgroundColor: AppColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.textPrimary,
              size: AppDimensions.iconM,
            ),
            AppSpacing.horizontalM(),
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Column(
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.verticalS(),
        AppButton(
          text: 'Create Account',
          textColor: AppColors.textPrimary,
          onPressed: () {
            // Navigate to sign up screen
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          type: AppButtonType.outline,
          isFullWidth: false,
          width: 140.w,
        ),
      ],
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Forgot Password?',
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          AppButton(
            text: 'Send Link',
            onPressed: () {
              Navigator.of(context).pop();
              _showComingSoonDialog('Password Reset');
            },
            type: AppButtonType.primary,
            isFullWidth: false,
            width: 100.w,
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Coming Soon',
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '$feature feature will be available soon!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          AppButton(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
            type: AppButtonType.primary,
            isFullWidth: false,
            width: 80.w,
          ),
        ],
      ),
    );
  }
}
