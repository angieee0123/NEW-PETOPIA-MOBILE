import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'rider_bottom_nav.dart';

class RiderEarningsPage extends StatefulWidget {
  const RiderEarningsPage({super.key});

  @override
  State<RiderEarningsPage> createState() => _RiderEarningsPageState();
}

class _RiderEarningsPageState extends State<RiderEarningsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();

  final List<_EarningItem> _items = [
    _EarningItem(
      date: DateTime(2026, 4, 16),
      orderId: '#2026-3201',
      customer: 'Maria Santos',
      fee: 59,
      status: _EarningStatus.paid,
    ),
    _EarningItem(
      date: DateTime(2026, 4, 15),
      orderId: '#2026-3202',
      customer: 'Juan Dela Cruz',
      fee: 49,
      status: _EarningStatus.pending,
    ),
    _EarningItem(
      date: DateTime(2026, 4, 14),
      orderId: '#2026-3198',
      customer: 'Alyssa Reyes',
      fee: 55,
      status: _EarningStatus.paid,
    ),
    _EarningItem(
      date: DateTime(2026, 4, 13),
      orderId: '#2026-3192',
      customer: 'Mark Villanueva',
      fee: 52,
      status: _EarningStatus.processing,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchController.text.trim().toLowerCase();
    final filtered = _items.where((e) {
      if (q.isEmpty) {
        return true;
      }
      return e.orderId.toLowerCase().contains(q) ||
          e.customer.toLowerCase().contains(q) ||
          _fmtDate(e.date).toLowerCase().contains(q);
    }).toList();

    final totalEarnings = _items.fold<double>(0, (sum, e) => sum + e.fee);
    final thisMonth = _items
        .where((e) => e.date.month == DateTime.now().month && e.date.year == DateTime.now().year)
        .fold<double>(0, (sum, e) => sum + e.fee);

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
                _buildPanel(
                  filtered: filtered,
                  totalEarnings: totalEarnings,
                  monthEarnings: thisMonth,
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
      bottomNavigationBar: RiderBottomNav(
        currentIndex: 2,
        onTap: (value) {
          if (value == 2) {
            return;
          }
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderDeliveries);
            return;
          }
          if (value == 3) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderProfile);
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.riderDashboard,
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
            child: const Icon(Icons.payments_outlined, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earnings',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your delivery earnings',
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
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel({
    required List<_EarningItem> filtered,
    required double totalEarnings,
    required double monthEarnings,
  }) {
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
          _buildSummary(totalEarnings, monthEarnings),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by order ID, customer, or date...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTable(filtered),
        ],
      ),
    );
  }

  Widget _buildSummary(double total, double month) {
    return _EarningsKpiGrid(
      totalEarnings: total,
      monthEarnings: month,
      totalDeliveries: _items.length,
    );
  }

  Widget _buildTable(List<_EarningItem> items) {
    if (items.isEmpty) {
      return const _EmptyEarnings();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 720),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: const Color(0x148BB6FF),
                  child: const Row(
                    children: [
                      _Cell('Date', w: 120, header: true),
                      _Cell('Order ID', w: 130, header: true),
                      _Cell('Customer', w: 170, header: true),
                      _Cell('Fee', w: 110, header: true),
                      _Cell('Status', w: 120, header: true),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (final e in items) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        _Cell(_fmtDate(e.date), w: 120),
                        _Cell(e.orderId, w: 130),
                        _Cell(e.customer, w: 170),
                        _Cell('₱${e.fee.toStringAsFixed(2)}', w: 110),
                        SizedBox(
                          width: 120,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _StatusChip(status: e.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: _muted.withValues(alpha: .12)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmtDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _EarningsKpiGrid extends StatelessWidget {
  const _EarningsKpiGrid({
    required this.totalEarnings,
    required this.monthEarnings,
    required this.totalDeliveries,
  });

  final double totalEarnings;
  final double monthEarnings;
  final int totalDeliveries;

  static const _success = Color(0xFF4ADE80);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _warning = Color(0xFFFFB86B);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = w < 380 ? 1 : (w < 720 ? 2 : 3);
        final childAspectRatio = w < 380 ? 3.1 : 2.7;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: childAspectRatio,
          children: [
            _KpiTile(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: _success,
              label: 'Total Earnings',
              value: '₱${totalEarnings.toStringAsFixed(2)}',
            ),
            _KpiTile(
              icon: Icons.calendar_month_outlined,
              iconColor: _accent2,
              label: 'This Month',
              value: '₱${monthEarnings.toStringAsFixed(2)}',
            ),
            _KpiTile(
              icon: Icons.local_shipping_outlined,
              iconColor: _warning,
              label: 'Total Deliveries',
              value: '$totalDeliveries',
            ),
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12101828),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: iconColor.withValues(alpha: .25)),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final _EarningStatus status;

  static const _warning = Color(0xFFFFB86B);
  static const _success = Color(0xFF4ADE80);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _EarningStatus.paid => _success,
      _EarningStatus.pending => _warning,
      _EarningStatus.processing => _accent2,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {required this.w, this.header = false});
  final String text;
  final double w;
  final bool header;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: header ? _text : _muted,
          fontWeight: header ? FontWeight.w900 : FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyEarnings extends StatelessWidget {
  const _EmptyEarnings();
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: const Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 42, color: _muted),
          SizedBox(height: 10),
          Text(
            'No earnings found',
            style: TextStyle(
              color: _muted,
              fontWeight: FontWeight.w800,
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

enum _EarningStatus { paid, pending, processing }

extension on _EarningStatus {
  String get label {
    switch (this) {
      case _EarningStatus.paid:
        return 'Paid';
      case _EarningStatus.pending:
        return 'Pending';
      case _EarningStatus.processing:
        return 'Processing';
    }
  }
}

class _EarningItem {
  const _EarningItem({
    required this.date,
    required this.orderId,
    required this.customer,
    required this.fee,
    required this.status,
  });

  final DateTime date;
  final String orderId;
  final String customer;
  final double fee;
  final _EarningStatus status;
}

