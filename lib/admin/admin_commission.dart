import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminCommissionPage extends StatefulWidget {
  const AdminCommissionPage({super.key});

  @override
  State<AdminCommissionPage> createState() => _AdminCommissionPageState();
}

class _AdminCommissionPageState extends State<AdminCommissionPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  String _statusFilter = 'all';
  String _typeFilter = 'all';
  String _dateFilter = 'all';
  String _chartTimeframe = '7days';

  final List<_CommissionItem> _commissions = [
    _CommissionItem(
      id: 'COM-9001',
      user: 'Angelica Pet Supplies',
      type: 'seller',
      amount: 2150,
      status: 'pending',
      date: DateTime.now().subtract(const Duration(days: 1)),
      orderId: 'ORD-3001',
      description: 'Seller commission from COD settlement batch.',
    ),
    _CommissionItem(
      id: 'COM-9002',
      user: 'Petopia Platform',
      type: 'platform',
      amount: 930,
      status: 'paid',
      date: DateTime.now().subtract(const Duration(days: 2)),
      orderId: 'ORD-3002',
      description: 'Platform fee for fulfilled order set.',
    ),
    _CommissionItem(
      id: 'COM-9003',
      user: 'Happy Tails Shop',
      type: 'seller',
      amount: 1780,
      status: 'overdue',
      date: DateTime.now().subtract(const Duration(days: 15)),
      orderId: 'ORD-2988',
      description: 'Pending release due to payout verification.',
    ),
    _CommissionItem(
      id: 'COM-9004',
      user: 'Petopia Platform',
      type: 'platform',
      amount: 1125,
      status: 'paid',
      date: DateTime.now().subtract(const Duration(days: 3)),
      orderId: 'ORD-3003',
      description: 'Service fee for multi-seller split order.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCommissions();
    final totalCommission = _commissions.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );
    final paidThisMonth = _commissions
        .where(
          (e) =>
              e.status == 'paid' &&
              e.date.month == DateTime.now().month &&
              e.date.year == DateTime.now().year,
        )
        .fold<double>(0, (sum, e) => sum + e.amount);
    final activeSellers = _commissions
        .where((e) => e.type == 'seller')
        .map((e) => e.user)
        .toSet()
        .length;

    final sellerCommission = _commissions
        .where((e) => e.type == 'seller')
        .fold<double>(0, (sum, e) => sum + e.amount);
    final platformFees = _commissions
        .where((e) => e.type == 'platform')
        .fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.commission,
        onSelect: _onSidebarSelect,
        onLogout: _confirmLogout,
      ),
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                _buildStats(
                  totalCommission: totalCommission,
                  paidThisMonth: paidThisMonth,
                  activeSellers: activeSellers,
                  totalTransactions: _commissions.length,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildMainPanels(
                  filtered: filtered,
                  sellerCommission: sellerCommission,
                  platformFees: platformFees,
                  totalCommission: totalCommission,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Commission Tracking',
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
          ),
          const SizedBox(width: 2),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(Icons.savings_outlined, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commission Tracking',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Monitor and manage platform commissions',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.attach_money_rounded, color: _muted),
        ],
      ),
    );
  }

  Widget _buildStats({
    required double totalCommission,
    required double paidThisMonth,
    required int activeSellers,
    required int totalTransactions,
  }) {
    final items = [
      _MetricData(
        'Total Commission',
        _peso(totalCommission),
        Icons.savings_outlined,
      ),
      _MetricData(
        'Paid This Month',
        _peso(paidThisMonth),
        Icons.check_circle_outline,
      ),
      _MetricData(
        'Active Sellers',
        '$activeSellers',
        Icons.storefront_outlined,
      ),
      _MetricData(
        'Total Transactions',
        '$totalTransactions',
        Icons.receipt_long_outlined,
      ),
    ];
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEEF4FF),
                ),
                child: Icon(item.icon, color: const Color(0xFF2E5EA7)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SizedBox(
            width: 190,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: _input('Search sellers, transactions...'),
            ),
          ),
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              initialValue: _statusFilter,
              isExpanded: true,
              decoration: _input('Status'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'paid', child: Text('Paid')),
                DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
              ],
              onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              initialValue: _typeFilter,
              isExpanded: true,
              decoration: _input('Type'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'seller', child: Text('Seller')),
                DropdownMenuItem(value: 'platform', child: Text('Platform')),
              ],
              onChanged: (v) => setState(() => _typeFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              initialValue: _dateFilter,
              isExpanded: true,
              decoration: _input('Date'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'week', child: Text('Week')),
                DropdownMenuItem(value: 'month', child: Text('Month')),
              ],
              onChanged: (v) => setState(() => _dateFilter = v ?? 'all'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _statusFilter = 'all';
                _typeFilter = 'all';
                _dateFilter = 'all';
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPanels({
    required List<_CommissionItem> filtered,
    required double sellerCommission,
    required double platformFees,
    required double totalCommission,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth > 900;
        final rightPanel = _buildRightPanel(
          sellerCommission: sellerCommission,
          platformFees: platformFees,
          totalCommission: totalCommission,
        );
        if (sideBySide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildTransactionsPanel(filtered)),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: rightPanel),
            ],
          );
        }
        return Column(
          children: [
            _buildTransactionsPanel(filtered),
            const SizedBox(height: 12),
            rightPanel,
          ],
        );
      },
    );
  }

  Widget _buildTransactionsPanel(List<_CommissionItem> filtered) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Commission Transactions',
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No commission transactions found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            ...filtered.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x140B0F1A)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.user,
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_capitalize(item.type)} • ${item.id} • ${_fmtDate(item.date)}',
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _peso(item.amount),
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: item.status),
                    const SizedBox(width: 6),
                    OutlinedButton(
                      onPressed: () => _viewDetails(item),
                      child: const Text('View'),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRightPanel({
    required double sellerCommission,
    required double platformFees,
    required double totalCommission,
  }) {
    final graphValues = _chartValues();
    final maxValue = graphValues.fold<double>(1, (m, e) => e > m ? e : m);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Commission Breakdown',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 115,
                    child: DropdownButtonFormField<String>(
                      initialValue: _chartTimeframe,
                      isDense: true,
                      isExpanded: true,
                      decoration: _input(''),
                      items: const [
                        DropdownMenuItem(value: '7days', child: Text('7 Days')),
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text('Monthly'),
                        ),
                        DropdownMenuItem(
                          value: 'yearly',
                          child: Text('Yearly'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _chartTimeframe = v ?? '7days'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(graphValues.length, (i) {
                  final value = graphValues[i];
                  final height = (value / maxValue) * 130;
                  final color = i == 0
                      ? const Color(0xFF8BB6FF)
                      : const Color(0xFF7CF4D1);
                  final label = i == 0 ? 'Seller' : 'Platform';
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          _peso(value),
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height.clamp(8, 130),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: const TextStyle(
                            color: _text,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
              const Text(
                'Commission Summary',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              _summaryRow('Seller Commissions', _peso(sellerCommission)),
              _summaryRow('Platform Fees', _peso(platformFees)),
              const Divider(),
              _summaryRow(
                'Total Commission',
                _peso(totalCommission),
                strong: true,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _info('Commission report exported (prototype).'),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Report'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _info('Commission statement generated (prototype).'),
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Generate Statement'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String amount, {bool strong = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _text,
                fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: strong ? const Color(0xFF2E5EA7) : _muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  List<_CommissionItem> _filteredCommissions() {
    final search = _searchController.text.trim().toLowerCase();
    return _commissions.where((c) {
      final searchMatch =
          search.isEmpty ||
          c.id.toLowerCase().contains(search) ||
          c.user.toLowerCase().contains(search) ||
          c.description.toLowerCase().contains(search) ||
          c.orderId.toLowerCase().contains(search);
      final statusMatch = _statusFilter == 'all' || c.status == _statusFilter;
      final typeMatch = _typeFilter == 'all' || c.type == _typeFilter;

      final diff = DateTime.now().difference(c.date).inDays;
      final dateMatch = switch (_dateFilter) {
        'today' => diff == 0,
        'week' => diff <= 7,
        'month' => diff <= 30,
        _ => true,
      };
      return searchMatch && statusMatch && typeMatch && dateMatch;
    }).toList();
  }

  List<double> _chartValues() {
    final now = DateTime.now();
    final range = switch (_chartTimeframe) {
      '7days' => 7,
      'monthly' => 30,
      'yearly' => 365,
      _ => 7,
    };
    final inRange = _commissions.where(
      (c) => now.difference(c.date).inDays <= range,
    );
    final seller = inRange
        .where((e) => e.type == 'seller')
        .fold<double>(0, (sum, e) => sum + e.amount);
    final platform = inRange
        .where((e) => e.type == 'platform')
        .fold<double>(0, (sum, e) => sum + e.amount);
    return [seller, platform];
  }

  void _viewDetails(_CommissionItem c) {
    final details =
        '''
Commission Details:

ID: ${c.id}
Order ID: ${c.orderId}
User: ${c.user}
Type: ${_capitalize(c.type)}
Amount: ${_peso(c.amount)}
Status: ${_capitalize(c.status)}
Date: ${_fmtDate(c.date)}
Description: ${c.description}
''';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Commission Details'),
        content: SingleChildScrollView(child: Text(details)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint.isEmpty ? null : hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x120B0F1A)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0x120B0F1A)),
      ),
    );
  }

  String _peso(double n) => 'PHP ${n.toStringAsFixed(0)}';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  void _onSidebarSelect(AdminSection section) {
    Navigator.of(context).pop();
    switch (section) {
      case AdminSection.overview:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminDashboard);
        return;
      case AdminSection.usersAll:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminAllUsers);
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
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminProductManagement);
        return;
      case AdminSection.orders:
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminOrderManagement);
        return;
      case AdminSection.commission:
        return;
      case AdminSection.offenses:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminOffenses);
        return;
      case AdminSection.reports:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminReports);
        return;
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout from Admin pages?',
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
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.shell,
        (route) => false,
        arguments: {'tab': 3},
      );
    }
  }

  void _info(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MetricData {
  const _MetricData(this.title, this.value, this.icon);
  final String title;
  final String value;
  final IconData icon;
}

class _CommissionItem {
  const _CommissionItem({
    required this.id,
    required this.user,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    required this.orderId,
    required this.description,
  });

  final String id;
  final String user;
  final String type;
  final double amount;
  final String status;
  final DateTime date;
  final String orderId;
  final String description;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    switch (status) {
      case 'paid':
        bg = const Color(0x1F4ADE80);
        fg = const Color(0xFF117A43);
        break;
      case 'overdue':
        bg = const Color(0xFFFCE1E1);
        fg = const Color(0xFFB3261E);
        break;
      default:
        bg = const Color(0xFFFFF4D6);
        fg = const Color(0xFF8A5A00);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w900),
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
