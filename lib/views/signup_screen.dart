import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/validators.dart';
import '../view_models/signup_viewmodel.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/app_spacing.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/app_dimensions.dart';
import 'home_screen.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final viewModel = context.read<SignupViewModel>();

    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final phoneNumber = _phoneNumberCtrl.text;

    final success = await viewModel.signUp(name: name, email: email, password: password, phoneNumber: phoneNumber);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful')),
      );
      // navigate to sign in / home as required
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())); // example: go back to sign in
    } else {
      if (!mounted) return;
      final error = viewModel.error ?? 'Signup failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignupViewModel>();

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
                _buildSignUpForm(vm),
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
            Icons.person_add_rounded,
            size: AppDimensions.iconXL,
            color: AppColors.textOnPrimary,
          ),
        ),
        AppSpacing.verticalL(),
        Text(
          'Create Account',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalS(),
        Text(
          'Join us today and start your journey',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpForm(SignupViewModel vm) {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(),
            AppSpacing.verticalM(),
            _buildEmailField(),
            AppSpacing.verticalM(),
            _buildPasswordField(),
            AppSpacing.verticalM(),
            _buildPhoneField(),
            AppSpacing.verticalXL(),
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

  Widget _buildNameField() {
    return AppTextField(
      label: 'Full Name',
      hint: 'Enter your full name',
      controller: _nameCtrl,
      validator: Validators.validateName,
      prefixIcon: Icon(
        Icons.person_outline,
        color: AppColors.primary,
        size: AppDimensions.iconM,
      ),
      textCapitalization: TextCapitalization.words,
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

  Widget _buildPhoneField() {
    return AppTextField(
      label: 'Phone Number',
      hint: 'Enter your phone number',
      controller: _phoneNumberCtrl,
      keyboardType: TextInputType.phone,
      validator: (v) => Validators.validatePhone(v ?? ''),
      prefixIcon: Icon(
        Icons.phone_outlined,
        color: AppColors.primary,
        size: AppDimensions.iconM,
      ),
      prefixText: '+',
    );
  }

  Widget _buildSubmitButton(SignupViewModel vm) {
    return AppButton(
      text: 'Create Account',
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
        Text(
          'Already have an account?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.verticalS(),
        AppButton(
          text: 'Sign In',
          textColor: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen())),
          type: AppButtonType.outline,
          isFullWidth: false,
          width: 120.w,
        ),
      ],
    );
  }
}
