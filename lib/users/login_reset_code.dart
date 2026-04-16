import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';

class LoginResetCodePage extends StatefulWidget {
  const LoginResetCodePage({super.key, required this.destinationLabel});

  final String destinationLabel;

  @override
  State<LoginResetCodePage> createState() => _LoginResetCodePageState();
}

class _LoginResetCodePageState extends State<LoginResetCodePage> {
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _otpLength = 6;

  final _hiddenCodeController = TextEditingController();
  final _hiddenCodeFocus = FocusNode();
  bool _isVerifying = false;

  @override
  void dispose() {
    _hiddenCodeController.dispose();
    _hiddenCodeFocus.dispose();
    super.dispose();
  }

  String get _code => _hiddenCodeController.text.trim();

  void _onCodeChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned != value) {
      _hiddenCodeController.value = TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }
    setState(() {});
  }

  Future<void> _verifyCode() async {
    if (_isVerifying) return;

    if (_code.length < _otpLength) {
      await _showAlert(
        title: 'Incomplete Code',
        message: 'Please enter the full 6-digit code.',
      );
      return;
    }

    setState(() => _isVerifying = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _isVerifying = false);

    // Prototype behavior:
    // Replace this with POST /verify_reset_code { code: "123456" }.
    final isValid = _code == '123456';
    if (!isValid) {
      _hiddenCodeController.clear();
      _hiddenCodeFocus.requestFocus();
      setState(() {});
      await _showAlert(
        title: 'Invalid Code',
        message: 'Invalid code. Please try again.',
      );
      return;
    }

    await _showAlert(
      title: 'Code Verified',
      message: 'Your reset code has been verified successfully.',
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.resetPassword);
  }

  Future<void> _showAlert({
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chars = _code.padRight(_otpLength).split('');

    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0x99FFFFFF),
                          side: const BorderSide(color: Color(0xAFFFFFFF)),
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Back'),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xA6FFFFFF),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xEBFFFFFF)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26101828),
                              blurRadius: 30,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Enter Reset Code',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: _text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Please enter the 6-digit code sent to ${widget.destinationLabel}.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _muted,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: 0,
                                  child: TextField(
                                    autofocus: true,
                                    focusNode: _hiddenCodeFocus,
                                    controller: _hiddenCodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                        _otpLength,
                                      ),
                                    ],
                                    onChanged: _onCodeChanged,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _hiddenCodeFocus.requestFocus(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(_otpLength, (
                                      index,
                                    ) {
                                      final isFilled = index < _code.length;
                                      final char = chars[index] == ' '
                                          ? ''
                                          : chars[index];
                                      return Container(
                                        width: 50,
                                        height: 54,
                                        margin: EdgeInsets.only(
                                          right: index == _otpLength - 1
                                              ? 0
                                              : 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0x0AFFFFFF),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: isFilled
                                                ? const Color(0xB37CF4D1)
                                                : _accent,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          char,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: _text,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [_accent, _accent2],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _isVerifying ? null : _verifyCode,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFF051014),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    _isVerifying
                                        ? 'Verifying...'
                                        : 'Verify Code',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                'Prototype reset code: 123456',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuroraBackground extends StatelessWidget {
  const _AuroraBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
          left: -120,
          top: -80,
          child: _BlurBlob(color: Color(0x997CF4D1), size: 280),
        ),
        Positioned(
          right: -120,
          top: -60,
          child: _BlurBlob(color: Color(0x998BB6FF), size: 280),
        ),
        Positioned(
          left: 40,
          bottom: -140,
          child: _BlurBlob(color: Color(0x99F39CFF), size: 320),
        ),
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 110, spreadRadius: 30)],
      ),
    );
  }
}
