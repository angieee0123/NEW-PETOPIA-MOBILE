import 'package:flutter/material.dart';

import '../app_routes.dart';

class SignupBuyerPage extends StatefulWidget {
  const SignupBuyerPage({super.key});

  @override
  State<SignupBuyerPage> createState() => _SignupBuyerPageState();
}

class _SignupBuyerPageState extends State<SignupBuyerPage> {
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  bool _agreeToTerms = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
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
                  const SizedBox(height: 14),
                  const Text(
                    'Sign Up as Buyer',
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.06,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find everything your pet needs and enjoy exclusive deals by joining as a buyer.',
                    style: TextStyle(
                      color: _muted,
                      fontWeight: FontWeight.w600,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create Your Petopia Account',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _fullNameController,
                            decoration: _decoration(
                              'Full Name',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Full name is required.'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _decoration(
                              'Email',
                              icon: Icons.mail_outline_rounded,
                            ),
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              final regex = RegExp(
                                r'^[^\s@]+@(gmail|yahoo)\.com$',
                                caseSensitive: false,
                              );
                              if (value.isEmpty) {
                                return 'Email is required.';
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Use a valid gmail.com or yahoo.com email.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            decoration: _decoration(
                              'Password',
                              hint:
                                  'At least 8 chars with upper/lower/number/symbol',
                              icon: _hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              onIconPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                            ),
                            validator: (v) {
                              final value = v ?? '';
                              final regex = RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,}$',
                              );
                              if (value.isEmpty) {
                                return 'Password is required.';
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Password is too weak.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmController,
                            obscureText: _hideConfirmPassword,
                            decoration: _decoration(
                              'Confirm Password',
                              icon: _hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              onIconPressed: () => setState(
                                () => _hideConfirmPassword =
                                    !_hideConfirmPassword,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Confirm your password.';
                              }
                              if (v != _passwordController.text) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _decoration(
                              'Phone Number',
                              hint: '09XXXXXXXXX',
                              icon: Icons.phone_outlined,
                            ),
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                                return 'Use format 09XXXXXXXXX.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              _dob == null
                                  ? 'Date of Birth'
                                  : 'Date of Birth: ${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: _text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.calendar_today_rounded,
                              color: _muted,
                              size: 18,
                            ),
                            onTap: _pickDateOfBirth,
                          ),
                          DropdownButtonFormField<String>(
                            initialValue: _gender,
                            decoration: _decoration('Gender'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _gender = value),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _addressController,
                            readOnly: true,
                            onTap: _pickAddress,
                            decoration: _decoration(
                              'Complete Address',
                              hint: 'Street, Barangay, City, Province, ZIP',
                              icon: Icons.location_on_outlined,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Address is required.'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            readOnly: true,
                            decoration: _decoration(
                              'Profile Photo (optional)',
                              hint: 'Tap to simulate file selection',
                              icon: Icons.image_outlined,
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Image picker can be connected next.',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                activeColor: _accent2,
                                onChanged: (value) => setState(
                                  () => _agreeToTerms = value ?? false,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 11),
                                  child: Wrap(
                                    children: [
                                      const Text(
                                        'I agree to ',
                                        style: TextStyle(
                                          color: _muted,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _showTermsAndConditions,
                                        child: const Text(
                                          "Petopia's Terms and Conditions",
                                          style: TextStyle(
                                            color: _accent2,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
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
                                onPressed: _submit,
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
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'After submitting, please check your email for a verification code to confirm your account.',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                        ],
                      ),
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

  InputDecoration _decoration(
    String label, {
    String? hint,
    IconData? icon,
    VoidCallback? onIconPressed,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0x0AFFFFFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xEBFFFFFF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xEBFFFFFF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xB37CF4D1), width: 2),
      ),
      suffixIcon: icon == null
          ? null
          : IconButton(
              onPressed: onIconPressed,
              icon: Icon(icon, color: _muted),
            ),
    );
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (selected != null) {
      setState(() => _dob = selected);
    }
  }

  Future<void> _pickAddress() async {
    final houseController = TextEditingController();
    final streetController = TextEditingController();
    final barangayController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final zipController = TextEditingController();
    final landmarkController = TextEditingController();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF6F8FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Address',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: houseController,
                    decoration: const InputDecoration(labelText: 'House No.'),
                  ),
                  TextField(
                    controller: streetController,
                    decoration: const InputDecoration(labelText: 'Street'),
                  ),
                  TextField(
                    controller: barangayController,
                    decoration: const InputDecoration(labelText: 'Barangay'),
                  ),
                  TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'City / Municipality',
                    ),
                  ),
                  TextField(
                    controller: provinceController,
                    decoration: const InputDecoration(
                      labelText: 'Province / Region',
                    ),
                  ),
                  TextField(
                    controller: zipController,
                    decoration: const InputDecoration(labelText: 'ZIP Code'),
                  ),
                  TextField(
                    controller: landmarkController,
                    decoration: const InputDecoration(
                      labelText: 'Landmark (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final parts = [
                          houseController.text.trim(),
                          streetController.text.trim(),
                          barangayController.text.trim(),
                          cityController.text.trim(),
                          provinceController.text.trim(),
                          zipController.text.trim(),
                        ]..removeWhere((e) => e.isEmpty);
                        final landmark = landmarkController.text.trim();
                        String composed = parts.join(', ');
                        if (landmark.isNotEmpty) {
                          composed += ' (Landmark: $landmark)';
                        }
                        Navigator.of(context).pop(composed);
                      },
                      child: const Text('Use this address'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      _addressController.text = result;
    }

    houseController.dispose();
    streetController.dispose();
    barangayController.dispose();
    cityController.dispose();
    provinceController.dispose();
    zipController.dispose();
    landmarkController.dispose();
  }

  void _showTermsAndConditions() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Petopia Terms and Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              'By creating a Petopia buyer account, you agree to provide accurate information, use the platform responsibly, and follow Petopia policies on orders, payments, returns, and account security.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birthdate.')),
      );
      return;
    }

    final now = DateTime.now();
    int age = now.year - _dob!.year;
    if (now.month < _dob!.month ||
        (now.month == _dob!.month && now.day < _dob!.day)) {
      age--;
    }
    if (age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be at least 18 years old to sign up.'),
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Conditions.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buyer sign up submitted. Verification step is next.'),
      ),
    );

    Navigator.of(context).pushNamed(
      AppRoutes.otp,
      arguments: {
        'destinationLabel': _emailController.text.trim(),
        'next': AppRoutes.buyerDashboard,
      },
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
