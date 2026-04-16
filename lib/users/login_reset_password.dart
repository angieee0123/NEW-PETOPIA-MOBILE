import 'package:flutter/material.dart';

import '../app_routes.dart';

class LoginResetPasswordPage extends StatefulWidget {
  const LoginResetPasswordPage({super.key});

  @override
  State<LoginResetPasswordPage> createState() => _LoginResetPasswordPageState();
}

class _LoginResetPasswordPageState extends State<LoginResetPasswordPage> {
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _error = Color(0xFFFF6B6B);
  static const _success = Color(0xFF4CD964);

  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _isUpdating = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? get _newPassFeedback {
    final value = _newPasswordController.text;
    if (value.isEmpty) return null;
    if (value.length < 8) return 'Password too short';
    return 'Good password';
  }

  String? get _confirmPassFeedback {
    final value = _confirmPasswordController.text;
    if (value.isEmpty) return null;
    if (_newPasswordController.text != value) return 'Passwords do not match';
    return 'Passwords match';
  }

  Color _feedbackColor(String? feedback) {
    if (feedback == null) return Colors.transparent;
    if (feedback == 'Good password' || feedback == 'Passwords match') {
      return _success;
    }
    return _error;
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _isUpdating) return;

    setState(() => _isUpdating = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isUpdating = false);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Updated'),
        content: const Text('Your password has been updated successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.account,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final newFeedback = _newPassFeedback;
    final confirmFeedback = _confirmPassFeedback;

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
                        onPressed: () => Navigator.of(context).pop(),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: _text,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Create a new password for your account (minimum 8 characters).',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _muted,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: _hideNew,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'New password',
                                  filled: true,
                                  fillColor: const Color(0x0AFFFFFF),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: _accent,
                                      width: 2,
                                    ),
                                  ),
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
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _hideNew = !_hideNew),
                                    icon: Icon(
                                      _hideNew
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: _muted,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final pass = value ?? '';
                                  if (pass.isEmpty) {
                                    return 'New password is required.';
                                  }
                                  if (pass.length < 8) {
                                    return 'Password must be at least 8 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 15,
                                child: Text(
                                  newFeedback ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _feedbackColor(newFeedback),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _hideConfirm,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Confirm password',
                                  filled: true,
                                  fillColor: const Color(0x0AFFFFFF),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: _accent,
                                      width: 2,
                                    ),
                                  ),
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
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () => _hideConfirm = !_hideConfirm,
                                    ),
                                    icon: Icon(
                                      _hideConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: _muted,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final confirm = value ?? '';
                                  if (confirm.isEmpty) {
                                    return 'Please confirm your password.';
                                  }
                                  if (confirm != _newPasswordController.text) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 15,
                                child: Text(
                                  confirmFeedback ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _feedbackColor(confirmFeedback),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
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
                                    onPressed: _isUpdating ? null : _submit,
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
                                      _isUpdating
                                          ? 'Updating...'
                                          : 'Update Password',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
