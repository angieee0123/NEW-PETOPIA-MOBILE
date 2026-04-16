import 'package:flutter/material.dart';

/// Reusable admin sidebar drawer.
///
/// Extracted from `admin_dashboard.dart` so it can be reused on other admin pages.
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.activeSection,
    required this.onSelect,
    required this.onLogout,
  });

  final AdminSection activeSection;
  final ValueChanged<AdminSection> onSelect;
  final VoidCallback onLogout;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _drawerItem(
                    icon: Icons.query_stats_rounded,
                    title: 'Overview / Stats',
                    isActive: activeSection == AdminSection.overview,
                    onTap: () => onSelect(AdminSection.overview),
                  ),
                  ExpansionTile(
                    leading: Icon(
                      Icons.people_alt_outlined,
                      color: activeSection.isUserSection ? _accent2 : _text,
                    ),
                    title: Text(
                      'User Management',
                      style: TextStyle(
                        color: activeSection.isUserSection ? _accent2 : _text,
                        fontWeight: activeSection.isUserSection
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 14),
                    children: [
                      _drawerSubItem(
                        title: 'View All Users',
                        isActive: activeSection == AdminSection.usersAll,
                        onTap: () => onSelect(AdminSection.usersAll),
                      ),
                      _drawerSubItem(
                        title: 'Seller Requests',
                        isActive:
                            activeSection == AdminSection.usersSellerRequests,
                        onTap: () => onSelect(AdminSection.usersSellerRequests),
                      ),
                      _drawerSubItem(
                        title: 'Rider Requests',
                        isActive:
                            activeSection == AdminSection.usersRiderRequests,
                        onTap: () => onSelect(AdminSection.usersRiderRequests),
                      ),
                    ],
                  ),
                  _drawerItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'Product Management',
                    isActive: activeSection == AdminSection.products,
                    onTap: () => onSelect(AdminSection.products),
                  ),
                  _drawerItem(
                    icon: Icons.shopping_cart_checkout_outlined,
                    title: 'Order Management',
                    isActive: activeSection == AdminSection.orders,
                    onTap: () => onSelect(AdminSection.orders),
                  ),
                  _drawerItem(
                    icon: Icons.savings_outlined,
                    title: 'Commission Tracking',
                    isActive: activeSection == AdminSection.commission,
                    onTap: () => onSelect(AdminSection.commission),
                  ),
                  _drawerItem(
                    icon: Icons.gpp_bad_outlined,
                    title: 'Offenses & Violations',
                    isActive: activeSection == AdminSection.offenses,
                    onTap: () => onSelect(AdminSection.offenses),
                  ),
                  _drawerItem(
                    icon: Icons.assessment_outlined,
                    title: 'Reports & Analytics',
                    isActive: activeSection == AdminSection.reports,
                    onTap: () => onSelect(AdminSection.reports),
                  ),
                  const Divider(height: 18),
                  _drawerItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Signed in as Admin',
                  style: TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isActive ? _accent2 : _text),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? _accent2 : _text,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _drawerSubItem({
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: isActive ? _accent2 : _text,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          color: isActive ? _accent2 : _text,
        ),
      ),
      onTap: onTap,
    );
  }
}

enum AdminSection {
  overview,
  usersAll,
  usersSellerRequests,
  usersRiderRequests,
  products,
  orders,
  commission,
  offenses,
  reports,
}

extension on AdminSection {
  bool get isUserSection =>
      this == AdminSection.usersAll ||
      this == AdminSection.usersSellerRequests ||
      this == AdminSection.usersRiderRequests;
}

class _Header extends StatelessWidget {
  const _Header();

  static const _text = Color(0xFF0B0F1A);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x120B0F1A))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: Color(0xFF051014),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Petopia Admin',
            style: TextStyle(fontWeight: FontWeight.w800, color: _text),
          ),
        ],
      ),
    );
  }
}
