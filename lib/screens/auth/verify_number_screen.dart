import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class VerifyNumberScreen extends StatefulWidget {
  final String? phoneNumber;

  const VerifyNumberScreen({super.key, this.phoneNumber});

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpCode.length == 6;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Auto-focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
          _resendCountdown = 0;
        });
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  void _onResend() {
    if (!_canResend) return;
    // TODO: resend OTP
    _startCountdown();
  }

  void _onVerify() {
    if (!_isOtpComplete) return;
    // TODO: verify OTP
    context.push('/setup-profile');
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.phoneNumber ?? '+241 XX XXX XXX';

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
                'Vérification',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Entrez le code envoyé au $phone',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // OTP input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) => _onKeyDown(index, event),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Resend code
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: _onResend,
                        child: const Text(
                          'Renvoyer le code',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Renvoyer le code dans ${_resendCountdown}s',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Vérifier button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isOtpComplete ? _onVerify : null,
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
                    'Vérifier',
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
