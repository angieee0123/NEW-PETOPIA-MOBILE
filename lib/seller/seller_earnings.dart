import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerEarningsPage extends StatefulWidget {
  const SellerEarningsPage({super.key});

  @override
  State<SellerEarningsPage> createState() => _SellerEarningsPageState();
}

class _SellerEarningsPageState extends State<SellerEarningsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _warning = Color(0xFFFFB86B);
  static const _success = Color(0xFF4ADE80);
  static const _danger = Color(0xFFEF4444);

  final _searchController = TextEditingController();
  _EarningsRange _range = _EarningsRange.last7d;

  late final List<_EarningRow> _rows = [
    _EarningRow(
      orderId: '#2026-4102',
      customer: 'Maria Santos',
      status: _OrderStatus.pending,
      subtotal: 1146,
      adminFee: 114.6,
      riderFee: 59,
      sellerNet: 1031.4,
      dateLabel: '2026-04-16',
    ),
    _EarningRow(
      orderId: '#2026-4105',
      customer: 'Juan Dela Cruz',
      status: _OrderStatus.processing,
      subtotal: 526,
      adminFee: 52.6,
      riderFee: 49,
      sellerNet: 473.4,
      dateLabel: '2026-04-15',
    ),
    _EarningRow(
      orderId: '#2026-4094',
      customer: 'Cynthia Ramos',
      status: _OrderStatus.shipped,
      subtotal: 438,
      adminFee: 43.8,
      riderFee: 59,
      sellerNet: 394.2,
      dateLabel: '2026-04-14',
    ),
    _EarningRow(
      orderId: '#2026-4068',
      customer: 'Mark Villanueva',
      status: _OrderStatus.delivered,
      subtotal: 999,
      adminFee: 99.9,
      riderFee: 0,
      sellerNet: 899.1,
      dateLabel: '2026-04-13',
    ),
    _EarningRow(
      orderId: '#2026-4059',
      customer: 'Alyssa Reyes',
      status: _OrderStatus.cancelled,
      subtotal: 777,
      adminFee: 0,
      riderFee: 0,
      sellerNet: 0,
      dateLabel: '2026-04-12',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final rows = _rows.where((r) {
      if (query.isEmpty) {
        return true;
      }
      return r.orderId.toLowerCase().contains(query) ||
          r.customer.toLowerCase().contains(query);
    }).toList();

    final totals = _computeTotals(_rows);

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
                _buildStatsRow(totals),
                const SizedBox(height: 14),
                _buildPanels(context, rows, totals),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Earnings & Commission',
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
        currentIndex: 0,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerOrders);
            return;
          }
          if (value == 3) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerShopPublicView);
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
              Icons.savings_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earnings & Commission',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Track fees and net income',
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

  Widget _buildStatsRow(_EarningsTotals totals) {
    return LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 520;
        final children = [
          _StatCard(
            label: 'Total Earnings',
            value: '₱ ${totals.sellerNet.toStringAsFixed(0)}',
            icon: Icons.wallet_outlined,
          ),
          _StatCard(
            label: 'This Month',
            value: '₱ ${totals.thisMonth.toStringAsFixed(0)}',
            icon: Icons.calendar_month_outlined,
          ),
          _StatCard(
            label: 'Total Commission Paid',
            value: '₱ ${totals.adminFee.toStringAsFixed(0)}',
            icon: Icons.receipt_long_outlined,
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [
              children[0],
              const SizedBox(height: 12),
              children[1],
              const SizedBox(height: 12),
              children[2],
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: children[0]),
            const SizedBox(width: 12),
            Expanded(child: children[1]),
            const SizedBox(width: 12),
            Expanded(child: children[2]),
          ],
        );
      },
    );
  }

  Widget _buildPanels(
    BuildContext context,
    List<_EarningRow> rows,
    _EarningsTotals totals,
  ) {
    return LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 980;
        final left = _EarningsByOrderPanel(
          searchController: _searchController,
          rows: rows,
          onChanged: () => setState(() {}),
          statusChipBuilder: _statusChip,
        );
        final right = Column(
          children: [
            _TrendPanel(
              range: _range,
              onRangeChanged: (value) => setState(() => _range = value),
              points: _pointsForRange(_range),
            ),
            const SizedBox(height: 14),
            _CommissionBreakdownPanel(totals: totals),
          ],
        );

        if (isNarrow) {
          return Column(
            children: [
              left,
              const SizedBox(height: 14),
              right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 14),
            SizedBox(width: 420, child: right),
          ],
        );
      },
    );
  }

  _EarningsTotals _computeTotals(List<_EarningRow> rows) {
    double admin = 0;
    double rider = 0;
    double seller = 0;
    for (final r in rows) {
      admin += r.adminFee;
      rider += r.riderFee;
      seller += r.sellerNet;
    }

    // Prototype "this month" = delivered + shipped + processing in list
    final thisMonth = rows
        .where(
          (r) =>
              r.status == _OrderStatus.processing ||
              r.status == _OrderStatus.shipped ||
              r.status == _OrderStatus.delivered,
        )
        .fold<double>(0, (sum, r) => sum + r.sellerNet);

    return _EarningsTotals(
      adminFee: admin,
      riderFee: rider,
      sellerNet: seller,
      thisMonth: thisMonth,
    );
  }

  List<_TrendPoint> _pointsForRange(_EarningsRange r) {
    switch (r) {
      case _EarningsRange.last7d:
        return const [
          _TrendPoint('Mon', .32),
          _TrendPoint('Tue', .44),
          _TrendPoint('Wed', .38),
          _TrendPoint('Thu', .70),
          _TrendPoint('Fri', .52),
          _TrendPoint('Sat', .86),
          _TrendPoint('Sun', .62),
        ];
      case _EarningsRange.monthly:
        return const [
          _TrendPoint('W1', .42),
          _TrendPoint('W2', .55),
          _TrendPoint('W3', .72),
          _TrendPoint('W4', .60),
        ];
      case _EarningsRange.yearly:
        return const [
          _TrendPoint('Jan', .28),
          _TrendPoint('Feb', .40),
          _TrendPoint('Mar', .58),
          _TrendPoint('Apr', .62),
          _TrendPoint('May', .52),
          _TrendPoint('Jun', .70),
          _TrendPoint('Jul', .76),
          _TrendPoint('Aug', .66),
          _TrendPoint('Sep', .54),
          _TrendPoint('Oct', .60),
          _TrendPoint('Nov', .74),
          _TrendPoint('Dec', .80),
        ];
    }
  }

  Widget _statusChip(_OrderStatus status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  String _statusLabel(_OrderStatus status) {
    switch (status) {
      case _OrderStatus.pending:
        return 'Pending';
      case _OrderStatus.processing:
        return 'Processing';
      case _OrderStatus.shipped:
        return 'Shipped';
      case _OrderStatus.delivered:
        return 'Delivered';
      case _OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(_OrderStatus status) {
    switch (status) {
      case _OrderStatus.pending:
        return _warning;
      case _OrderStatus.processing:
        return _accent2;
      case _OrderStatus.shipped:
        return _accent;
      case _OrderStatus.delivered:
        return _success;
      case _OrderStatus.cancelled:
        return _danger;
    }
  }
}

class _EarningsByOrderPanel extends StatelessWidget {
  const _EarningsByOrderPanel({
    required this.searchController,
    required this.rows,
    required this.onChanged,
    required this.statusChipBuilder,
  });

  final TextEditingController searchController;
  final List<_EarningRow> rows;
  final VoidCallback onChanged;
  final Widget Function(_OrderStatus) statusChipBuilder;

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
          const Text(
            'Earnings by Order',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: 'Search order ID or customer...',
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
          if (rows.isEmpty)
            const _EmptyState(
              icon: Icons.inbox_outlined,
              title: 'No results',
              subtitle: 'Try searching by customer name or order ID.',
            )
          else
            _EarningsTable(rows: rows, statusChipBuilder: statusChipBuilder),
          const SizedBox(height: 10),
          const Text(
            'Tip: This table matches the seller web module columns (Order ID, Customer, Status, Subtotal, Admin Fee, Rider Fee, Seller Net, Date).',
            style: TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsTable extends StatelessWidget {
  const _EarningsTable({required this.rows, required this.statusChipBuilder});

  final List<_EarningRow> rows;
  final Widget Function(_OrderStatus) statusChipBuilder;

  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    // Horizontal scroll for mobile to preserve the web table columns.
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
            constraints: const BoxConstraints(minWidth: 980),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  color: const Color(0xFFF8FAFF),
                  child: const Row(
                    children: [
                      _HCell('Order ID', w: 110, isHeader: true),
                      _HCell('Customer', w: 160, isHeader: true),
                      _HCell('Status', w: 120, isHeader: true),
                      _HCell('Subtotal', w: 110, isHeader: true),
                      _HCell('Admin Fee', w: 110, isHeader: true),
                      _HCell('Rider Fee', w: 110, isHeader: true),
                      _HCell('Seller Net', w: 120, isHeader: true),
                      _HCell('Date', w: 110, isHeader: true),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (final r in rows) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _HCell(r.orderId, w: 110),
                        _HCell(r.customer, w: 160),
                        SizedBox(
                          width: 120,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: statusChipBuilder(r.status),
                          ),
                        ),
                        _HCell('₱ ${r.subtotal.toStringAsFixed(0)}', w: 110),
                        _HCell('₱ ${r.adminFee.toStringAsFixed(0)}', w: 110),
                        _HCell('₱ ${r.riderFee.toStringAsFixed(0)}', w: 110),
                        _HCell('₱ ${r.sellerNet.toStringAsFixed(0)}', w: 120),
                        _HCell(r.dateLabel, w: 110),
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
}

class _HCell extends StatelessWidget {
  const _HCell(this.text, {required this.w, this.isHeader = false});

  final String text;
  final double w;
  final bool isHeader;

  static const _textColor = Color(0xFF0B0F1A);
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
          color: isHeader ? _textColor : _muted,
          fontWeight: isHeader ? FontWeight.w900 : FontWeight.w700,
          fontSize: isHeader ? 12 : 12,
        ),
      ),
    );
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel({
    required this.range,
    required this.onRangeChanged,
    required this.points,
  });

  final _EarningsRange range;
  final ValueChanged<_EarningsRange> onRangeChanged;
  final List<_TrendPoint> points;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

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
          Row(
            children: [
              Expanded(
                child: Text(
                  range.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<_EarningsRange>(
                  value: range,
                  onChanged: (v) {
                    if (v != null) {
                      onRangeChanged(v);
                    }
                  },
                  items: _EarningsRange.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.menuLabel,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 260,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points
                  .map(
                    (p) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 200 * p.value,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [_accent, _accent2],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.label,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionBreakdownPanel extends StatelessWidget {
  const _CommissionBreakdownPanel({required this.totals});

  final _EarningsTotals totals;

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
          const Text(
            'Commission Breakdown',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: Column(
                children: [
                  _BreakRow(
                    a: 'Admin Commission',
                    b: '₱ ${totals.adminFee.toStringAsFixed(0)}',
                    c: '10% of item subtotal',
                  ),
                  Divider(height: 1, color: _muted.withValues(alpha: .12)),
                  _BreakRow(
                    a: 'Rider Commission',
                    b: '₱ ${totals.riderFee.toStringAsFixed(0)}',
                    c: 'Full shipping fee',
                  ),
                  Divider(height: 1, color: _muted.withValues(alpha: .12)),
                  _BreakRow(
                    a: 'Seller Net',
                    b: '₱ ${totals.sellerNet.toStringAsFixed(0)}',
                    c: 'Subtotal − 10% admin fee',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Note: Buyer pays subtotal + shipping. Admin deducts 10% of subtotal. Shipping goes to rider. Seller gets remaining 90% of subtotal.',
            style: TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakRow extends StatelessWidget {
  const _BreakRow({required this.a, required this.b, required this.c});

  final String a;
  final String b;
  final String c;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              a,
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            b,
            style: const TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: Text(
              c,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12101828),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  _accent2.withValues(alpha: .14),
                  _accent.withValues(alpha: .12),
                ],
              ),
            ),
            child: Icon(icon, color: _accent2),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  static const _muted = Color(0xFF5B6378);
  static const _text = Color(0xFF0B0F1A);

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
      child: Column(
        children: [
          Icon(icon, size: 42, color: _muted.withValues(alpha: .7)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
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

enum _EarningsRange { last7d, monthly, yearly }

extension on _EarningsRange {
  String get title {
    switch (this) {
      case _EarningsRange.last7d:
        return 'Earnings Trend (Last 7 days)';
      case _EarningsRange.monthly:
        return 'Earnings Trend (Monthly)';
      case _EarningsRange.yearly:
        return 'Earnings Trend (Yearly)';
    }
  }

  String get menuLabel {
    switch (this) {
      case _EarningsRange.last7d:
        return 'Last 7 days';
      case _EarningsRange.monthly:
        return 'Monthly';
      case _EarningsRange.yearly:
        return 'Yearly';
    }
  }
}

enum _OrderStatus { pending, processing, shipped, delivered, cancelled }

class _EarningRow {
  const _EarningRow({
    required this.orderId,
    required this.customer,
    required this.status,
    required this.subtotal,
    required this.adminFee,
    required this.riderFee,
    required this.sellerNet,
    required this.dateLabel,
  });

  final String orderId;
  final String customer;
  final _OrderStatus status;
  final double subtotal;
  final double adminFee;
  final double riderFee;
  final double sellerNet;
  final String dateLabel;
}

class _EarningsTotals {
  const _EarningsTotals({
    required this.adminFee,
    required this.riderFee,
    required this.sellerNet,
    required this.thisMonth,
  });

  final double adminFee;
  final double riderFee;
  final double sellerNet;
  final double thisMonth;
}

class _TrendPoint {
  const _TrendPoint(this.label, this.value);
  final String label;
  final double value;
}

