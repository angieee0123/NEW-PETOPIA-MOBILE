import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  String _reportType = 'all';
  String _timeRange = 'all';
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<_ReportItem> _topProducts = const [
    _ReportItem('Premium Dog Kibble', 238, 12450.0),
    _ReportItem('Cat Litter Sand 10kg', 181, 9020.0),
    _ReportItem('Pet Carrier Backpack', 144, 11480.0),
    _ReportItem('Fish Tank Starter Kit', 122, 14300.0),
    _ReportItem('Chew Toys Bundle', 98, 5880.0),
  ];

  final List<_ActivityLog> _activity = [
    _ActivityLog(
      label: 'Monthly sales report exported',
      when: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.download_rounded,
    ),
    _ActivityLog(
      label: 'Order trend filter switched to Last 30 days',
      when: DateTime.now().subtract(const Duration(hours: 6)),
      icon: Icons.filter_alt_outlined,
    ),
    _ActivityLog(
      label: 'Commission statement generated',
      when: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.request_page_outlined,
    ),
    _ActivityLog(
      label: 'Top products chart refreshed',
      when: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      icon: Icons.bar_chart_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topProducts = _filteredProducts();
    final totalRevenue = topProducts.fold<double>(
      0,
      (sum, p) => sum + p.revenue,
    );
    final totalOrders = topProducts.fold<int>(0, (sum, p) => sum + p.orders);
    final activeUsers = 1240;
    final conversionRate = 18.4;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.reports,
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
                _buildKpis(
                  totalRevenue: totalRevenue,
                  activeUsers: activeUsers,
                  totalOrders: totalOrders,
                  conversionRate: conversionRate,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildActions(),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final sideBySide = constraints.maxWidth > 950;
                    if (sideBySide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildMainPanels(topProducts),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildSidePanels(totalRevenue),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildMainPanels(topProducts),
                        const SizedBox(height: 12),
                        _buildSidePanels(totalRevenue),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Reports & Analytics',
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
            child: const Icon(
              Icons.assessment_rounded,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports & Analytics',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Track revenue, orders, and performance',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.insights_outlined, color: _muted),
        ],
      ),
    );
  }

  Widget _buildKpis({
    required double totalRevenue,
    required int activeUsers,
    required int totalOrders,
    required double conversionRate,
  }) {
    final cards = [
      _Kpi(
        'Total Revenue',
        'PHP ${totalRevenue.toStringAsFixed(2)}',
        '+12.6%',
        Icons.payments_outlined,
      ),
      _Kpi('Active Users', '$activeUsers', '+4.2%', Icons.people_alt_outlined),
      _Kpi(
        'Total Orders',
        '$totalOrders',
        '+8.9%',
        Icons.shopping_bag_outlined,
      ),
      _Kpi(
        'Conversion Rate',
        '${conversionRate.toStringAsFixed(1)}%',
        '+1.1%',
        Icons.trending_up_rounded,
      ),
    ];

    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.47,
      ),
      itemBuilder: (context, i) {
        final k = cards[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      k.label,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(k.icon, color: const Color(0xFF2E5EA7), size: 18),
                ],
              ),
              const Spacer(),
              Text(
                k.value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                k.change,
                style: const TextStyle(
                  color: Color(0xFF117A43),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
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
            width: 180,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _reportType,
              decoration: _input('Report Type'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Reports')),
                DropdownMenuItem(value: 'sales', child: Text('Sales Reports')),
                DropdownMenuItem(
                  value: 'products',
                  child: Text('Product Reports'),
                ),
                DropdownMenuItem(value: 'orders', child: Text('Order Reports')),
              ],
              onChanged: (v) => setState(() => _reportType = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _timeRange,
              decoration: _input('Time Range'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Time')),
                DropdownMenuItem(value: '7d', child: Text('Last 7 Days')),
                DropdownMenuItem(value: '30d', child: Text('Last 30 Days')),
                DropdownMenuItem(value: '90d', child: Text('Last 90 Days')),
                DropdownMenuItem(value: 'custom', child: Text('Custom')),
              ],
              onChanged: (v) => setState(() => _timeRange = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 140,
            child: OutlinedButton(
              onPressed: () => _pickDate(isFrom: true),
              child: Text(
                _fromDate == null ? 'Date From' : _fmtDate(_fromDate!),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: OutlinedButton(
              onPressed: () => _pickDate(isFrom: false),
              child: Text(_toDate == null ? 'Date To' : _fmtDate(_toDate!)),
            ),
          ),
          SizedBox(
            width: 220,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: _input('Search reports, products...'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _reportType = 'all';
                _timeRange = 'all';
                _fromDate = null;
                _toDate = null;
                _searchController.clear();
              });
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF117A43),
              foregroundColor: Colors.white,
            ),
            onPressed: () => _info('Export to Excel started (prototype).'),
            icon: const Icon(Icons.grid_on_rounded, size: 18),
            label: const Text('Export Excel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A5A00),
              foregroundColor: Colors.white,
            ),
            onPressed: () => _info('Print report started (prototype).'),
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text('Print Report'),
          ),
        ),
      ],
    );
  }

  Widget _buildMainPanels(List<_ReportItem> products) {
    return Column(
      children: [
        _panel(title: 'Revenue Trends', child: _buildRevenueBars()),
        const SizedBox(height: 12),
        _panel(title: 'Top Products', child: _buildTopProductsTable(products)),
      ],
    );
  }

  Widget _buildSidePanels(double totalRevenue) {
    final totalOrders = _topProducts.fold<int>(0, (sum, p) => sum + p.orders);
    final pending = (totalOrders * 0.21).round();
    final delivered = (totalOrders * 0.64).round();
    final cancelled = totalOrders - pending - delivered;
    final commission = totalRevenue * 0.12;

    return Column(
      children: [
        _panel(
          title: 'Order Status',
          child: Column(
            children: [
              _progressLine(
                'Pending',
                pending,
                totalOrders,
                const Color(0xFF8A5A00),
              ),
              _progressLine(
                'Delivered',
                delivered,
                totalOrders,
                const Color(0xFF117A43),
              ),
              _progressLine(
                'Cancelled',
                cancelled,
                totalOrders,
                const Color(0xFFB3261E),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _panel(
          title: 'Commission Breakdown',
          child: Column(
            children: [
              _summaryRow(
                'Gross Sales',
                'PHP ${totalRevenue.toStringAsFixed(2)}',
              ),
              _summaryRow(
                'Platform Commission (12%)',
                'PHP ${commission.toStringAsFixed(2)}',
              ),
              _summaryRow(
                'Net Seller Revenue',
                'PHP ${(totalRevenue - commission).toStringAsFixed(2)}',
                emphasize: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _panel(
          title: 'Recent Activity',
          child: Column(
            children: _activity
                .map(
                  (a) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0x1F8BB6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            a.icon,
                            size: 16,
                            color: const Color(0xFF2E5EA7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.label,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _timeAgo(a.when),
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
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
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildRevenueBars() {
    const values = [12.5, 18.2, 14.0, 21.4, 19.8, 24.6, 22.1];
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List<Widget>.generate(values.length, (index) {
        final val = values[index];
        final height = (val / maxVal) * 120;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                Text(
                  '${val.toStringAsFixed(1)}k',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: const Color(0x668BB6FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xAA8BB6FF)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'D${index + 1}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopProductsTable(List<_ReportItem> products) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'No products found.',
            style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    return Column(
      children: products
          .map(
            (p) => Container(
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
                    child: Text(
                      p.name,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '${p.orders}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'PHP ${p.revenue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: _text,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _progressLine(String label, int value, int total, Color color) {
    final ratio = total == 0 ? 0.0 : value / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 7,
              backgroundColor: const Color(0x120B0F1A),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasize ? _text : _muted,
                fontWeight: emphasize ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _text,
              fontWeight: emphasize ? FontWeight.w900 : FontWeight.w800,
            ),
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

  List<_ReportItem> _filteredProducts() {
    final search = _searchController.text.trim().toLowerCase();
    return _topProducts.where((p) {
      final searchMatch =
          search.isEmpty || p.name.toLowerCase().contains(search);
      final typeMatch = switch (_reportType) {
        'sales' => true,
        'products' => true,
        'orders' => true,
        _ => true,
      };
      return searchMatch && typeMatch && _withinDateRange(DateTime.now());
    }).toList();
  }

  bool _withinDateRange(DateTime date) {
    if (_fromDate != null && date.isBefore(_fromDate!)) return false;
    if (_toDate != null && date.isAfter(_toDate!)) return false;
    final diff = DateTime.now().difference(date).inDays;
    return switch (_timeRange) {
      '7d' => diff <= 7,
      '30d' => diff <= 30,
      '90d' => diff <= 90,
      _ => true,
    };
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = selected;
      } else {
        _toDate = selected;
      }
    });
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _timeAgo(DateTime when) {
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

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
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminCommission);
        return;
      case AdminSection.offenses:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminOffenses);
        return;
      case AdminSection.reports:
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

class _Kpi {
  const _Kpi(this.label, this.value, this.change, this.icon);
  final String label;
  final String value;
  final String change;
  final IconData icon;
}

class _ReportItem {
  const _ReportItem(this.name, this.orders, this.revenue);
  final String name;
  final int orders;
  final double revenue;
}

class _ActivityLog {
  _ActivityLog({required this.label, required this.when, required this.icon});
  final String label;
  final DateTime when;
  final IconData icon;
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
