import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    context.go('/home');
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
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'Connectez-vous à votre\ncompte',
                            style: GoogleFonts.teko(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.24,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 104),
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
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: GestureDetector(
                            onTap: () => context.push('/signup'),
                            child: Text.rich(
                              TextSpan(
                                text: 'Pas de compte? ',
                                style: _AuthTextStyles.body,
                                children: [
                                  TextSpan(
                                    text: 'Inscrivez vous !',
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
                            onPressed: _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _AuthColors.button,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Valider',
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
