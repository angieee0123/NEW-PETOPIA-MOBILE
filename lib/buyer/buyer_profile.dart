import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'buyer_bottom_nav.dart';

class BuyerProfilePage extends StatelessWidget {
  const BuyerProfilePage({super.key});

  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _buildTopBar(context),
                const SizedBox(height: 14),
                _buildIdentityCard(),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: 'Personal Information',
                  subtitle: 'Captured during buyer sign up',
                  children: [
                    _InfoRow(label: 'Full Name', value: 'Angelica D. Cuevas'),
                    _InfoRow(label: 'Email', value: 'buyer@gmail.com'),
                    _InfoRow(label: 'Phone', value: '09171234567'),
                    _InfoRow(label: 'Date of Birth', value: '1999-08-14'),
                    _InfoRow(label: 'Gender', value: 'Female'),
                    _InfoRow(
                      label: 'Complete Address',
                      value:
                          'Blk 12 Lot 8, St. Mary St, Brgy. San Isidro, Quezon City, NCR, 1100',
                      multiline: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: 'Account & Preferences',
                  subtitle:
                      'Profile photo, terms, and shopping account details',
                  children: [
                    _InfoRow(
                      label: 'Profile Photo',
                      value: 'Optional / Not uploaded',
                    ),
                    _InfoRow(label: 'Terms & Conditions', value: 'Accepted'),
                    _InfoRow(label: 'Account Status', value: 'Active'),
                    _InfoRow(label: 'Member Since', value: '2026-04-16'),
                    _InfoRow(label: 'Default Role', value: 'Buyer'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xECFFFFFF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0x120B0F1A)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Edit buyer profile flow can be connected next.',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit Profile'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accent,
                                foregroundColor: const Color(0xFF051014),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.buyerDashboard,
                                );
                              },
                              icon: const Icon(Icons.home_outlined),
                              label: const Text(
                                'Go Home',
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmAndLogout(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _danger,
                            side: const BorderSide(color: _danger),
                          ),
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia. All rights reserved.',
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
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: 3,
        onTap: (value) {
          if (value == 3) {
            return;
          }
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerOrders);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerCart);
            return;
          }
          Navigator.of(context).pushReplacementNamed(AppRoutes.buyerDashboard);
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buyer Profile',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Account and profile details',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(
              Icons.pets_rounded,
              size: 34,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Angelica D. Cuevas',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Buyer ID: BYR-2026-0416',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Status: Active',
                  style: TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.shell,
      (route) => false,
      arguments: {'tab': 3},
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool multiline;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              maxLines: multiline ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
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
    return const Stack(
      children: [
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
          left: 20,
          bottom: -150,
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
