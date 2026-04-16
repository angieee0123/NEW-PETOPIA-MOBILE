import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_all_users.dart';
import 'admin_sidebar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_MetricItem> _metrics = const [
    _MetricItem(
      title: 'Total Sales',
      value: 'P 485,200.00',
      icon: Icons.payments_outlined,
    ),
    _MetricItem(
      title: 'Total Users',
      value: '1,294',
      icon: Icons.people_alt_outlined,
    ),
    _MetricItem(
      title: 'Total Products',
      value: '872',
      icon: Icons.inventory_2_outlined,
    ),
    _MetricItem(
      title: 'Total Commission',
      value: 'P 38,221.90',
      icon: Icons.savings_outlined,
    ),
  ];

  final List<_OffenseItem> _offenses = const [
    _OffenseItem(
      user: 'rider.juan',
      type: 'Late Delivery',
      level: 'Warning',
      date: '2026-04-12',
    ),
    _OffenseItem(
      user: 'seller.pawsmart',
      type: 'Policy Violation',
      level: 'Suspended',
      date: '2026-04-11',
    ),
    _OffenseItem(
      user: 'buyer.alex',
      type: 'Fraud Report',
      level: 'Review',
      date: '2026-04-10',
    ),
  ];

  final List<_OrderItem> _orders = const [
    _OrderItem(
      id: '#10294',
      customer: 'Maria C.',
      status: 'Delivered',
      date: 'Today, 11:42 AM',
    ),
    _OrderItem(
      id: '#10293',
      customer: 'Jerome V.',
      status: 'Preparing',
      date: 'Today, 10:17 AM',
    ),
    _OrderItem(
      id: '#10292',
      customer: 'Angel S.',
      status: 'For Pickup',
      date: 'Today, 9:03 AM',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.overview,
        onSelect: _onSidebarSelect,
        onLogout: _confirmLogout,
      ),
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async =>
                  Future<void>.delayed(const Duration(milliseconds: 400)),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 14),
                  _buildSearch(),
                  const SizedBox(height: 14),
                  _buildStatsGrid(),
                  const SizedBox(height: 14),
                  _buildOffensesPanel(),
                  const SizedBox(height: 14),
                  _buildOrdersPanel(),
                  const SizedBox(height: 14),
                  _buildCommissionPanel(),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      '© 2025 Petopia — Admin Dashboard',
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
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Open menu',
          ),
          const SizedBox(width: 2),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin',
                  style: TextStyle(fontWeight: FontWeight.w800, color: _text),
                ),
                SizedBox(height: 2),
                Text(
                  'Control center of the marketplace',
                  style: TextStyle(
                    fontSize: 12,
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _info('Notifications panel is prototype-only.'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () => _info('Messages panel is prototype-only.'),
            icon: const Icon(Icons.mail_outline_rounded),
          ),
        ],
      ),
    );
  }

  void _onSidebarSelect(AdminSection section) {
    Navigator.of(context).pop(); // close drawer
    switch (section) {
      case AdminSection.overview:
        // Already on this page.
        return;
      case AdminSection.usersAll:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AdminAllUsersPage()),
        );
        return;
      case AdminSection.usersSellerRequests:
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminSellerRequests);
        return;
      case AdminSection.usersRiderRequests:
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminRiderRequests);
        return;
      case AdminSection.products:
        _info('Product Management screen is the next integration step.');
        return;
      case AdminSection.orders:
        _info('Order Management screen is the next integration step.');
        return;
      case AdminSection.commission:
        _info('Commission Tracking screen is the next integration step.');
        return;
      case AdminSection.offenses:
        _info('Offenses & Violations screen is the next integration step.');
        return;
      case AdminSection.reports:
        _info('Reports & Analytics screen is the next integration step.');
        return;
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout from Admin Dashboard?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.account, (route) => false);
    }
  }

  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users, products, orders...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [_accent, _accent2]),
          ),
          child: IconButton(
            onPressed: () => _info('Search: ${_searchController.text.trim()}'),
            icon: const Icon(Icons.search_rounded, color: Color(0xFF051014)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      itemCount: _metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final item = _metrics[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x120B0F1A)),
            boxShadow: const [
              BoxShadow(color: Color(0x10101828), blurRadius: 14),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, color: _accent2),
              const Spacer(),
              Text(
                item.title,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOffensesPanel() {
    return _panel(
      title: 'Recent Offenses & Violations',
      child: Column(
        children: _offenses
            .map(
              (offense) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  offense.user,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${offense.type} • ${offense.date}'),
                trailing: _statusPill(offense.level),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOrdersPanel() {
    return _panel(
      title: 'Recent Orders',
      child: Column(
        children: _orders
            .map(
              (order) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${order.id} • ${order.customer}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(order.date),
                trailing: _statusPill(order.status),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCommissionPanel() {
    return _panel(
      title: 'Commission Snapshot',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommissionRow(
            source: 'Orders',
            amount: 'P 22,440.00',
            percentage: '58%',
          ),
          _CommissionRow(
            source: 'Seller Fees',
            amount: 'P 11,200.00',
            percentage: '29%',
          ),
          _CommissionRow(
            source: 'Ad Boost',
            amount: 'P 4,581.90',
            percentage: '13%',
          ),
          SizedBox(height: 10),
          Text(
            'Total Commission: P 38,221.90',
            style: TextStyle(fontWeight: FontWeight.w700, color: _text),
          ),
          SizedBox(height: 2),
          Text(
            'This Month: P 13,402.50',
            style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: _text,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _statusPill(String label) {
    Color color;
    final lower = label.toLowerCase();
    if (lower.contains('delivered')) {
      color = const Color(0xFF4ADE80);
    } else if (lower.contains('warning') || lower.contains('pickup')) {
      color = const Color(0xFFFBBF24);
    } else if (lower.contains('suspend')) {
      color = const Color(0xFFFB7185);
    } else {
      color = _accent2;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _info(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MetricItem {
  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;
}

class _OffenseItem {
  const _OffenseItem({
    required this.user,
    required this.type,
    required this.level,
    required this.date,
  });

  final String user;
  final String type;
  final String level;
  final String date;
}

class _OrderItem {
  const _OrderItem({
    required this.id,
    required this.customer,
    required this.status,
    required this.date,
  });

  final String id;
  final String customer;
  final String status;
  final String date;
}

class _CommissionRow extends StatelessWidget {
  const _CommissionRow({
    required this.source,
    required this.amount,
    required this.percentage,
  });

  final String source;
  final String amount;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              source,
              style: const TextStyle(color: _AdminDashboardPageState._text),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: _AdminDashboardPageState._text,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            percentage,
            style: const TextStyle(color: _AdminDashboardPageState._muted),
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
