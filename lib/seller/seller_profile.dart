import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({super.key});

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
                _SectionCard(
                  title: 'Personal Information',
                  subtitle: 'Captured during seller sign up step 1',
                  children: const [
                    _InfoRow(label: 'Full Name', value: 'Angelica D. Cuevas'),
                    _InfoRow(label: 'Email', value: 'seller@gmail.com'),
                    _InfoRow(label: 'Phone', value: '09171234567'),
                    _InfoRow(label: 'Date of Birth', value: '1995-06-22'),
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
                _SectionCard(
                  title: 'Business Details',
                  subtitle: 'Captured during seller sign up step 2',
                  children: const [
                    _InfoRow(
                      label: 'Store / Business Name',
                      value: 'Angelica Pet Supplies',
                    ),
                    _InfoRow(label: 'Business Type', value: 'Sole Proprietor'),
                    _InfoRow(label: 'Primary Category', value: 'Food & Treats'),
                    _InfoRow(
                      label: 'Detailed Product Description',
                      value:
                          'Pet food, treats, grooming essentials, and daily pet accessories.',
                      multiline: true,
                    ),
                    _InfoRow(
                      label: 'Business Address',
                      value:
                          'Unit 5, Petopia Arcade, Commonwealth Ave, Quezon City, NCR',
                      multiline: true,
                    ),
                    _InfoRow(label: 'Years in Operation', value: '3'),
                    _InfoRow(
                      label: 'Business Contact Number',
                      value: '09175551234',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Payout & Verification',
                  subtitle: 'Captured during seller sign up step 3',
                  children: const [
                    _InfoRow(
                      label: 'Preferred Payout Method',
                      value: 'E-Wallet',
                    ),
                    _InfoRow(label: 'E-Wallet Number', value: '09175559876'),
                    _InfoRow(
                      label: 'DTI / SEC Registration',
                      value: 'Submitted',
                    ),
                    _InfoRow(
                      label: "Business Permit / Mayor's Permit",
                      value: 'Submitted',
                    ),
                    _InfoRow(label: 'BIR Certificate', value: 'Submitted'),
                    _InfoRow(label: 'Valid ID', value: 'Submitted'),
                    _InfoRow(label: 'Selfie with ID', value: 'Submitted'),
                    _InfoRow(label: 'Proof of Address', value: 'Submitted'),
                    _InfoRow(label: 'Terms Agreement', value: 'Accepted'),
                    _InfoRow(
                      label: 'Verification Status',
                      value: 'Under review',
                    ),
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
                                      'Edit seller profile flow can be connected next.',
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
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.sellerShopPublicView);
                              },
                              icon: const Icon(Icons.storefront_outlined),
                              label: const Text(
                                'View Shop',
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
      bottomNavigationBar: SellerBottomNav(
        currentIndex: 3,
        onTap: (value) {
          if (value == 3) {
            return;
          }
          if (value == 1) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerOrders);
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.sellerDashboard,
            arguments: {'tab': value},
          );
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
                  'Seller Profile',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Account, business, and verification details',
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
              Icons.storefront_rounded,
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
                  'Angelica Pet Supplies',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Seller ID: SLR-2026-0811',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Status: Active • Verification in progress',
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

    // Prototype session clearing: reset stack to login (Account tab).
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
            width: 140,
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
