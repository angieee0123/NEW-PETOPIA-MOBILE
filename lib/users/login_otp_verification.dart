import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginOtpVerificationPage extends StatefulWidget {
  const LoginOtpVerificationPage({
    super.key,
    required this.destinationLabel,
    this.nextRouteNameOnSuccess,
  });

  final String destinationLabel;
  final String? nextRouteNameOnSuccess;

  @override
  State<LoginOtpVerificationPage> createState() =>
      _LoginOtpVerificationPageState();
}

class _LoginOtpVerificationPageState extends State<LoginOtpVerificationPage> {
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  static const _otpLength = 6;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  Timer? _timer;
  int _resendSeconds = 30;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
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

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_resendSeconds <= 1) {
        t.cancel();
        setState(() => _resendSeconds = 0);
        return;
      }
      setState(() => _resendSeconds--);
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isComplete =>
      _controllers.every((c) => c.text.trim().isNotEmpty) && _otp.length == 6;

  void _onDigitChanged(int index, String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.isEmpty) {
      setState(() {});
      return;
    }
    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
    setState(() {});
  }

  KeyEventResult _onKey(int index, FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      final hasValue = _controllers[index].text.isNotEmpty;
      if (!hasValue && index > 0) {
        _controllers[index - 1].text = '';
        _focusNodes[index - 1].requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _verify();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _verify() async {
    if (_isVerifying) return;

    if (!_isComplete) {
      _showAlert(
        title: 'Incomplete OTP',
        message: 'Please enter all 6 digits.',
      );
      return;
    }

    setState(() => _isVerifying = true);

    // Prototype behavior:
    // - Replace this with a real API call that matches your web endpoint:
    //   POST /verify_otp { otp: "123456" }
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final ok = _otp == '123456';

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (!ok) {
      _showAlert(
        title: 'Invalid OTP',
        message: 'That code is incorrect. Please try again.',
      );
      return;
    }

    await _showAlert(
      title: 'Verification Successful',
      message: 'OTP verified. You can continue.',
    );
    if (!mounted) return;
    final next = widget.nextRouteNameOnSuccess;
    if (next != null && next.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(next);
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) return;
    _startResendTimer();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP resent (prototype).')));
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
    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
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
                    label: const Text('Back to Login'),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Verify your identity.\nSecure login with your OTP',
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We’ve sent a 6-digit code to ${widget.destinationLabel}. Enter it below to continue.",
                    style: const TextStyle(
                      color: _muted,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
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
                      children: [
                        const Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _text,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_otpLength, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == _otpLength - 1 ? 0 : 10,
                              ),
                              child: SizedBox(
                                width: 52,
                                height: 54,
                                child: Focus(
                                  focusNode: _focusNodes[index],
                                  onKeyEvent: (node, event) =>
                                      _onKey(index, node, event),
                                  child: TextField(
                                    controller: _controllers[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (value) =>
                                        _onDigitChanged(index, value),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: _text,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0x0AFFFFFF),
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: _accent,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xB37CF4D1),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
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
                              onPressed: _isVerifying ? null : _verify,
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
                                _isVerifying ? 'Verifying…' : 'Verify',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              "Didn't get a code? ",
                              style: TextStyle(
                                color: _muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: _resendSeconds == 0 ? _resendOtp : null,
                              child: Text(
                                _resendSeconds == 0
                                    ? 'Resend OTP'
                                    : 'Resend in ${_resendSeconds}s',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: _resendSeconds == 0 ? _text : _muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Prototype OTP: 123456',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
