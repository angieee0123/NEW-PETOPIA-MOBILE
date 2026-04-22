import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminOffensesPage extends StatefulWidget {
  const AdminOffensesPage({super.key});

  @override
  State<AdminOffensesPage> createState() => _AdminOffensesPageState();
}

class _AdminOffensesPageState extends State<AdminOffensesPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  String _statusFilter = 'all';
  String _severityFilter = 'all';
  String _userTypeFilter = 'all';
  String _dateFilter = 'all';

  final List<_OffenseEntry> _offenses = [
    _OffenseEntry(
      id: 'OFF-001',
      userName: 'Maria Santos',
      userType: 'seller',
      offenseType: 'Late Delivery',
      severity: 'medium',
      status: 'reviewed',
      description: 'Repeated delayed deliveries without prior notice.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      reporterInfo: 'Reported by: Juan Cruz (Buyer)',
      orderId: 'ORD-3001',
    ),
    _OffenseEntry(
      id: 'OFF-002',
      userName: 'Juan Dela Cruz',
      userType: 'buyer',
      offenseType: 'False Dispute',
      severity: 'high',
      status: 'pending',
      description: 'Filed multiple disputes for already delivered items.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      reporterInfo: 'Reported by: Petopia Support',
      orderId: 'ORD-2993',
    ),
    _OffenseEntry(
      id: 'OFF-003',
      userName: 'Ana Garcia',
      userType: 'seller',
      offenseType: 'Fake Product',
      severity: 'critical',
      status: 'resolved',
      description: 'Listing flagged for counterfeit branding.',
      date: DateTime.now().subtract(const Duration(days: 4)),
      reporterInfo: 'Reported by: Jerome V. (Buyer)',
      orderId: 'ORD-2985',
      adminNotes: 'Account suspended and listing removed.',
    ),
    _OffenseEntry(
      id: 'OFF-004',
      userName: 'Pedro Lopez',
      userType: 'rider',
      offenseType: 'Inappropriate Behavior',
      severity: 'high',
      status: 'dismissed',
      description: 'Customer complaint reviewed; insufficient evidence.',
      date: DateTime.now().subtract(const Duration(days: 6)),
      reporterInfo: 'Reported by: Angelica D. (Buyer)',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOffenses();
    final total = _offenses.length;
    final pending = _offenses.where((o) => o.status == 'pending').length;
    final active = _offenses
        .where((o) => o.status == 'pending' || o.status == 'reviewed')
        .length;
    final resolved = _offenses
        .where((o) => o.status == 'resolved' || o.status == 'dismissed')
        .length;

    final low = _offenses.where((o) => o.severity == 'low').length;
    final medium = _offenses.where((o) => o.severity == 'medium').length;
    final high = _offenses.where((o) => o.severity == 'high').length;
    final critical = _offenses.where((o) => o.severity == 'critical').length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.offenses,
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
                _buildStatGrid(
                  total: total,
                  pending: pending,
                  active: active,
                  resolved: resolved,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final sideBySide = constraints.maxWidth > 900;
                    if (sideBySide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildOffensesPanel(filtered),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildRightPanel(
                              low: low,
                              medium: medium,
                              high: high,
                              critical: critical,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildOffensesPanel(filtered),
                        const SizedBox(height: 12),
                        _buildRightPanel(
                          low: low,
                          medium: medium,
                          high: high,
                          critical: critical,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Offenses & Violations',
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
            child: const Icon(Icons.gpp_bad_outlined, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offenses & Violations',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Monitor and manage user violations',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.warning_amber_rounded, color: _muted),
        ],
      ),
    );
  }

  Widget _buildStatGrid({
    required int total,
    required int pending,
    required int active,
    required int resolved,
  }) {
    final stats = [
      _Stat('Total Offenses', '$total', Icons.report_problem_outlined),
      _Stat('Pending Review', '$pending', Icons.schedule_outlined),
      _Stat('Active Offenses', '$active', Icons.block_outlined),
      _Stat('Resolved', '$resolved', Icons.check_circle_outline),
    ];
    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, i) {
        final s = stats[i];
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
                child: Icon(s.icon, color: const Color(0xFF2E5EA7)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      s.value,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 18,
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
            width: 200,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: _input('Search users, offenses, violations...'),
            ),
          ),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _statusFilter,
              decoration: _input('Status'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'reviewed', child: Text('Reviewed')),
                DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                DropdownMenuItem(value: 'dismissed', child: Text('Dismissed')),
              ],
              onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _severityFilter,
              decoration: _input('Severity'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
              ],
              onChanged: (v) => setState(() => _severityFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _userTypeFilter,
              decoration: _input('User Type'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                DropdownMenuItem(value: 'seller', child: Text('Seller')),
                DropdownMenuItem(value: 'rider', child: Text('Rider')),
              ],
              onChanged: (v) => setState(() => _userTypeFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 130,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _dateFilter,
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
                _severityFilter = 'all';
                _userTypeFilter = 'all';
                _dateFilter = 'all';
              });
            },
            child: const Text('Clear Filters'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF23272F),
              foregroundColor: Colors.white,
            ),
            onPressed: () => _info('Print report started (prototype).'),
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text('Print Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildOffensesPanel(List<_OffenseEntry> filtered) {
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
            'Recent Offenses',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No reports found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            ...filtered.map(_buildOffenseCard),
        ],
      ),
    );
  }

  Widget _buildOffenseCard(_OffenseEntry o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x140B0F1A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '#${o.id}',
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _statusBadge(o.status),
              const SizedBox(width: 6),
              _severityBadge(o.severity),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [_accent, _accent2]),
                ),
                child: Center(
                  child: Text(
                    o.userName.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(
                      color: Color(0xFF051014),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.userName,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _capitalize(o.userType),
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              o.offenseType,
              style: const TextStyle(color: _text, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              o.description,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              o.reporterInfo,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          if (o.orderId != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order: ${o.orderId}',
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          if (o.adminNotes != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x1F8BB6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Admin Notes: ${o.adminNotes}',
                style: const TextStyle(
                  color: _text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _fmtDate(o.date),
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _viewDetails(o),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('View'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF23272F),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _openStatusSheet(o),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Change Status'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel({
    required int low,
    required int medium,
    required int high,
    required int critical,
  }) {
    final trend = _offenseTrend();
    final maxVal = trend.fold<int>(1, (m, v) => v > m ? v : m);
    return Column(
      children: [
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
                'Offense Trends (7 days)',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: trend.map((v) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Text(
                            '$v',
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: ((v / maxVal) * 110).clamp(8, 110),
                            decoration: BoxDecoration(
                              color: const Color(0x66EF4444),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0x99EF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
                'Severity Distribution',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              _severityRow(
                'Low',
                '$low',
                const Color(0x1F4ADE80),
                const Color(0xFF117A43),
              ),
              _severityRow(
                'Medium',
                '$medium',
                const Color(0x1FFFF4D6),
                const Color(0xFF8A5A00),
              ),
              _severityRow(
                'High',
                '$high',
                const Color(0xFFFCE1E1),
                const Color(0xFFB3261E),
              ),
              _severityRow(
                'Critical',
                '$critical',
                const Color(0x228B0000),
                const Color(0xFF8B0000),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _severityRow(String label, String value, Color bg, Color fg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: fg, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    late Color bg;
    late Color fg;
    switch (status) {
      case 'resolved':
        bg = const Color(0x1F4ADE80);
        fg = const Color(0xFF117A43);
        break;
      case 'dismissed':
        bg = const Color(0x1F8BB6FF);
        fg = const Color(0xFF2E5EA7);
        break;
      case 'reviewed':
        bg = const Color(0x1FFFF4D6);
        fg = const Color(0xFF8A5A00);
        break;
      default:
        bg = const Color(0xFFFCE1E1);
        fg = const Color(0xFFB3261E);
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

  Widget _severityBadge(String severity) {
    late Color bg;
    late Color fg;
    switch (severity) {
      case 'low':
        bg = const Color(0x1F4ADE80);
        fg = const Color(0xFF117A43);
        break;
      case 'medium':
        bg = const Color(0x1FFFF4D6);
        fg = const Color(0xFF8A5A00);
        break;
      case 'high':
        bg = const Color(0xFFFCE1E1);
        fg = const Color(0xFFB3261E);
        break;
      default:
        bg = const Color(0x228B0000);
        fg = const Color(0xFF8B0000);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        severity.toUpperCase(),
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w900),
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

  List<_OffenseEntry> _filteredOffenses() {
    final search = _searchController.text.trim().toLowerCase();
    return _offenses.where((o) {
      final searchMatch =
          search.isEmpty ||
          o.id.toLowerCase().contains(search) ||
          o.userName.toLowerCase().contains(search) ||
          o.offenseType.toLowerCase().contains(search) ||
          o.description.toLowerCase().contains(search);
      final statusMatch = _statusFilter == 'all' || o.status == _statusFilter;
      final severityMatch =
          _severityFilter == 'all' || o.severity == _severityFilter;
      final userTypeMatch =
          _userTypeFilter == 'all' || o.userType == _userTypeFilter;
      final diff = DateTime.now().difference(o.date).inDays;
      final dateMatch = switch (_dateFilter) {
        'today' => diff == 0,
        'week' => diff <= 7,
        'month' => diff <= 30,
        _ => true,
      };
      return searchMatch &&
          statusMatch &&
          severityMatch &&
          userTypeMatch &&
          dateMatch;
    }).toList();
  }

  List<int> _offenseTrend() {
    final now = DateTime.now();
    return List<int>.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return _offenses.where((o) {
        return o.date.year == day.year &&
            o.date.month == day.month &&
            o.date.day == day.day;
      }).length;
    });
  }

  void _viewDetails(_OffenseEntry o) {
    final details =
        '''
Report Details:

ID: ${o.id}
User: ${o.userName} (${_capitalize(o.userType)})
Type: ${o.offenseType}
Severity: ${_capitalize(o.severity)}
Status: ${_capitalize(o.status)}
Description: ${o.description}
${o.orderId != null ? 'Order: ${o.orderId}' : ''}
${o.reporterInfo}
Date: ${_fmtDate(o.date)}
${o.adminNotes != null ? 'Admin Notes: ${o.adminNotes}' : ''}
''';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Details'),
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

  void _openStatusSheet(_OffenseEntry offense) {
    String selectedStatus = offense.status;
    final notesController = TextEditingController(
      text: offense.adminNotes ?? '',
    );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Update ${offense.id}',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: _input('New Status'),
                      items: const [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'reviewed',
                          child: Text('Reviewed'),
                        ),
                        DropdownMenuItem(
                          value: 'resolved',
                          child: Text('Resolved'),
                        ),
                        DropdownMenuItem(
                          value: 'dismissed',
                          child: Text('Dismissed'),
                        ),
                      ],
                      onChanged: (v) => setModalState(
                        () => selectedStatus = v ?? selectedStatus,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: _input('Admin Notes'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF23272F),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                offense.status = selectedStatus;
                                offense.adminNotes =
                                    notesController.text.trim().isEmpty
                                    ? null
                                    : notesController.text.trim();
                              });
                              Navigator.of(context).pop();
                              _info('Report status updated successfully.');
                            },
                            child: const Text('Update Status'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminCommission);
        return;
      case AdminSection.offenses:
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

class _OffenseEntry {
  _OffenseEntry({
    required this.id,
    required this.userName,
    required this.userType,
    required this.offenseType,
    required this.severity,
    required this.status,
    required this.description,
    required this.date,
    required this.reporterInfo,
    this.orderId,
    this.adminNotes,
  });

  final String id;
  final String userName;
  final String userType;
  final String offenseType;
  final String severity;
  String status;
  final String description;
  final DateTime date;
  final String reporterInfo;
  final String? orderId;
  String? adminNotes;
}

class _Stat {
  const _Stat(this.title, this.value, this.icon);
  final String title;
  final String value;
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
