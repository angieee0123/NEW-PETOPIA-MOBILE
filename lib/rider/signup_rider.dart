import 'package:flutter/material.dart';

import '../app_routes.dart';

class SignupRiderPage extends StatefulWidget {
  const SignupRiderPage({super.key});

  @override
  State<SignupRiderPage> createState() => _SignupRiderPageState();
}

class _SignupRiderPageState extends State<SignupRiderPage> {
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _formKey = GlobalKey<FormState>();
  int _step = 1;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String? _vehicleType;
  final _vehicleModelController = TextEditingController();
  final _plateController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearModelController = TextEditingController();
  final _engineController = TextEditingController();
  final _chassisController = TextEditingController();
  final _licenseController = TextEditingController();

  String? _payoutMethod;
  final _ewalletController = TextEditingController();
  bool _agree = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _vehicleModelController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    _yearModelController.dispose();
    _engineController.dispose();
    _chassisController.dispose();
    _licenseController.dispose();
    _ewalletController.dispose();
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
                    'Sign Up as Rider',
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.06,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Earn while helping pet lovers get what they need, right at their doorstep.',
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
                            'Rider Registration',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _stepLabel(),
                            style: const TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(
                              3,
                              (index) => Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: index == 2 ? 0 : 8,
                                  ),
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: index < _step
                                        ? _accent2
                                        : const Color(0x330B0F1A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (_step == 1) _buildStep1(),
                          if (_step == 2) _buildStep2(),
                          if (_step == 3) _buildStep3(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              if (_step > 1)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() => _step--),
                                    child: const Text('Back'),
                                  ),
                                ),
                              if (_step > 1) const SizedBox(width: 10),
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      colors: [_accent, _accent2],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _onPrimaryPressed,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xFF051014),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      _step == 3 ? 'Submit Form' : 'Next',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_step == 3) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'After submitting, our team will review your documents and send updates via email.',
                              style: TextStyle(fontSize: 12, color: _muted),
                            ),
                          ],
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

  String _stepLabel() {
    switch (_step) {
      case 1:
        return 'Step 1 of 3 - Personal Information';
      case 2:
        return 'Step 2 of 3 - Vehicle Information';
      default:
        return 'Step 3 of 3 - Payout and Verification';
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: _decoration(
            'Full Name',
            icon: Icons.person_outline_rounded,
          ),
          validator: (v) => _step == 1 && (v == null || v.trim().isEmpty)
              ? 'Full name is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email', icon: Icons.mail_outline_rounded),
          validator: (v) {
            if (_step != 1) return null;
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
            hint: 'At least 8 chars with upper/lower/number/symbol',
            icon: _hidePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onIconPressed: () => setState(() => _hidePassword = !_hidePassword),
          ),
          validator: (v) {
            if (_step != 1) return null;
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
            onIconPressed: () =>
                setState(() => _hideConfirmPassword = !_hideConfirmPassword),
          ),
          validator: (v) {
            if (_step != 1) return null;
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
            if (_step != 1) return null;
            if (!RegExp(r'^09\d{9}$').hasMatch(v?.trim() ?? '')) {
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
            style: const TextStyle(color: _text, fontWeight: FontWeight.w600),
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
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          onChanged: (value) => setState(() => _gender = value),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _addressController,
          readOnly: true,
          onTap: _pickAddress,
          decoration: _decoration(
            'Complete Address',
            hint: 'Street, Barangay, City, Province, ZIP',
          ),
          validator: (v) => _step == 1 && (v == null || v.isEmpty)
              ? 'Address is required.'
              : null,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _vehicleType,
          decoration: _decoration('Vehicle Type'),
          items: const [
            DropdownMenuItem(value: 'Motorcycle', child: Text('Motorcycle')),
            DropdownMenuItem(value: 'Car', child: Text('Car')),
            DropdownMenuItem(value: 'Van', child: Text('Van')),
          ],
          onChanged: (value) => setState(() => _vehicleType = value),
          validator: (v) =>
              _step == 2 && v == null ? 'Vehicle type is required.' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _vehicleModelController,
          decoration: _decoration('Vehicle Model'),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'Vehicle model is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _plateController,
          decoration: _decoration('Plate Number', hint: 'ABC-1234'),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'Plate number is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _colorController,
          decoration: _decoration('Vehicle Color'),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'Vehicle color is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _yearModelController,
          keyboardType: TextInputType.number,
          decoration: _decoration('Year Model'),
          validator: (v) {
            if (_step != 2) return null;
            final year = int.tryParse(v?.trim() ?? '');
            if (year == null || year < 1980 || year > DateTime.now().year + 1) {
              return 'Enter a valid year model.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _engineController,
          decoration: _decoration('Engine Number'),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'Engine number is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _chassisController,
          decoration: _decoration('Chassis Number'),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'Chassis number is required.'
              : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _licenseController,
          decoration: _decoration(
            'Driver License Number',
            hint: 'N1234-5678901',
          ),
          validator: (v) => _step == 2 && (v == null || v.trim().isEmpty)
              ? 'License number is required.'
              : null,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _payoutMethod,
          decoration: _decoration('Preferred Payout Method'),
          items: const [
            DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
          ],
          onChanged: (value) => setState(() => _payoutMethod = value),
          validator: (v) =>
              _step == 3 && v == null ? 'Payout method is required.' : null,
        ),
        const SizedBox(height: 10),
        if (_payoutMethod == 'E-Wallet') ...[
          TextFormField(
            controller: _ewalletController,
            keyboardType: TextInputType.phone,
            decoration: _decoration('E-Wallet Number', hint: '09XXXXXXXXX'),
            validator: (v) {
              if (_step != 3 || _payoutMethod != 'E-Wallet') return null;
              if (!RegExp(r'^09\d{9}$').hasMatch(v?.trim() ?? '')) {
                return 'Use format 09XXXXXXXXX.';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
        const Text(
          'Verification Documents',
          style: TextStyle(fontWeight: FontWeight.w700, color: _text),
        ),
        const SizedBox(height: 10),
        ...[
          'OR/CR (Vehicle Registration)',
          "Driver's License (Front and Back)",
          'Vehicle Photo',
        ].map(
          (label) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              readOnly: true,
              decoration: _decoration(
                label,
                hint: 'Tap to simulate file selection',
                icon: Icons.upload_file_outlined,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label picker can be connected next.'),
                  ),
                );
              },
              validator: (v) => _step == 3 && (v == null || v.isEmpty)
                  ? 'Required for verification.'
                  : null,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _agree,
              activeColor: _accent2,
              onChanged: (value) => setState(() => _agree = value ?? false),
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
                      onTap: _showTerms,
                      child: const Text(
                        "Petopia's Terms and Conditions",
                        style: TextStyle(
                          color: _accent2,
                          decoration: TextDecoration.underline,
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
      ],
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
    if (selected != null) setState(() => _dob = selected);
  }

  Future<void> _pickAddress() async {
    final houseController = TextEditingController();
    final streetController = TextEditingController();
    final barangayController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final zipController = TextEditingController();

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
                    'Select Complete Address',
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
                        Navigator.of(context).pop(parts.join(', '));
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

    if (result != null && result.isNotEmpty) _addressController.text = result;
    houseController.dispose();
    streetController.dispose();
    barangayController.dispose();
    cityController.dispose();
    provinceController.dispose();
    zipController.dispose();
  }

  void _showTerms() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Petopia Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'By creating a rider account, you agree to provide accurate information, follow safety standards, and complete deliveries responsibly according to Petopia policies.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onPrimaryPressed() {
    if (_step == 1 && !_validateStep1Extra()) return;
    if (_step == 3 && !_validateStep3Extra()) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_step < 3) {
      setState(() => _step++);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rider sign-up submitted. Verification review is next.'),
      ),
    );

    Navigator.of(context).pushNamed(
      AppRoutes.otp,
      arguments: {
        'destinationLabel': _emailController.text.trim(),
        'next': AppRoutes.riderDashboard,
      },
    );
  }

  bool _validateStep1Extra() {
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birthdate.')),
      );
      return false;
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
      return false;
    }
    return true;
  }

  bool _validateStep3Extra() {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Conditions.'),
        ),
      );
      return false;
    }
    return true;
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
