import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasUppercase =>
      _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase =>
      _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  bool get _allRequirementsMet =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSpecialChar &&
      _passwordsMatch;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_allRequirementsMet) return;
    // TODO: save password
    context.go('/home');
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: met ? AppColors.success : AppColors.gray,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: met ? AppColors.success : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Créer votre\nmot de passe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Password input
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: const TextStyle(color: AppColors.gray),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.gray,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Confirm password input
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: 'Confirmer le mot de passe',
                    hintStyle: const TextStyle(color: AppColors.gray),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.gray,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Requirements checklist
              _buildRequirement('Au moins 8 caractères', _hasMinLength),
              _buildRequirement('Une lettre majuscule', _hasUppercase),
              _buildRequirement('Une lettre minuscule', _hasLowercase),
              _buildRequirement('Un chiffre', _hasNumber),
              _buildRequirement('Un caractère spécial', _hasSpecialChar),
              _buildRequirement(
                  'Les mots de passe correspondent', _passwordsMatch),
              const SizedBox(height: AppSpacing.xl),

              // Continuer button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _allRequirementsMet ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.4),
                    disabledForegroundColor:
                        AppColors.white.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
