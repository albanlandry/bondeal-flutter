import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool get _isPhoneValid => _phoneController.text.trim().length >= 6;
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _repeatPasswordController.text;
  bool get _canContinue => _isPhoneValid && _passwordsMatch;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _repeatPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_canContinue) return;
    context.push('/verify-number', extra: _phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 42),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: Text(
                            'Rejoignez-nous dès\naujourd’hui !',
                            style: GoogleFonts.teko(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.24,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 55),
                        _UnderlineField(
                          controller: _phoneController,
                          hint: 'Numéro de téléphone',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        _UnderlineField(
                          controller: _passwordController,
                          hint: 'Mot de passe',
                          obscure: true,
                        ),
                        const SizedBox(height: 20),
                        _UnderlineField(
                          controller: _repeatPasswordController,
                          hint: 'Confirmer le mot de passe',
                          obscure: true,
                        ),
                        const SizedBox(height: 15),
                        const _PasswordRequirements(),
                        const SizedBox(height: 22),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: GestureDetector(
                            onTap: () => context.push('/login'),
                            child: Text.rich(
                              TextSpan(
                                text: 'Déjà un compte ? ',
                                style: _AuthTextStyles.body,
                                children: [
                                  TextSpan(
                                    text: 'Connectez-vous !',
                                    style: _AuthTextStyles.link,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: _onContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _AuthColors.button,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: _AuthColors.button,
                              disabledForegroundColor: AppColors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Continuer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthColors {
  static const button = Color(0xFF4078C7);
  static const fieldLine = Color(0xFFEDEDED);
  static const inputText = Color(0xFF747474);
  static const link = Color(0xFF2F75D6);
}

class _AuthTextStyles {
  static const body = TextStyle(
    fontSize: 12,
    color: Colors.black,
    height: 1.2,
    fontWeight: FontWeight.w400,
  );

  static const link = TextStyle(
    fontSize: 12,
    color: _AuthColors.link,
    height: 1.2,
    fontWeight: FontWeight.w400,
  );
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements();

  @override
  Widget build(BuildContext context) {
    const items = [
      'Minimum de 8 caractères',
      'Au moins une lettre majuscule (A-Z)',
      'Au moins une lettre minuscule (a-z)',
      'Au moins un chiffre (0-9)',
      'Au moins un caractère spécial (ex. : ! @ # \$ % ^ & *)',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Text(
              item,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;

  const _UnderlineField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 6, 20, 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _AuthColors.fieldLine, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _AuthColors.button, width: 1),
          ),
          isDense: true,
        ).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(
            color: _AuthColors.inputText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
