import 'package:flutter/material.dart';
import '../app_routes.dart';

class SignupRoleSelectionPage extends StatelessWidget {
  const SignupRoleSelectionPage({super.key});

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

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
                    label: const Text('Back to Login'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x99FFFFFF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xAFFFFFFF)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pets_rounded, size: 18, color: Color(0xFF051014)),
                        SizedBox(width: 8),
                        Text(
                          'Petopia',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _text,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Pet Shop Essentials',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Join Petopia',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account to access the best pet supplies, care tips, and exclusive deals.',
                    style: TextStyle(
                      color: _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xA6FFFFFF),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xEBFFFFFF)),
                      boxShadow: const [
                        BoxShadow(color: Color(0x26101828), blurRadius: 30, offset: Offset(0, 14)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign Up As',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _text,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _RoleButton(
                          icon: Icons.shopping_cart_outlined,
                          label: 'Buyer',
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.signupBuyer);
                          },
                        ),
                        const SizedBox(height: 10),
                        _RoleButton(
                          icon: Icons.storefront_outlined,
                          label: 'Seller',
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.signupSeller);
                          },
                        ),
                        const SizedBox(height: 10),
                        _RoleButton(
                          icon: Icons.two_wheeler_outlined,
                          label: 'Rider',
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.signupRider);
                          },
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

  void _onRoleSelected(BuildContext context, String role) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$role sign up flow coming next.')),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [SignupRoleSelectionPage._accent, SignupRoleSelectionPage._accent2],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x408BB6FF), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF051014),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
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
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 110,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}
