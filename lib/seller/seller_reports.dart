import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerReportsPage extends StatefulWidget {
  const SellerReportsPage({super.key});

  @override
  State<SellerReportsPage> createState() => _SellerReportsPageState();
}

class _SellerReportsPageState extends State<SellerReportsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _warning = Color(0xFFFFB86B);
  static const _success = Color(0xFF4ADE80);
  static const _danger = Color(0xFFEF4444);

  DateTime? _fromDate;
  DateTime? _toDate;
  _OrderStatusFilter _statusFilter = _OrderStatusFilter.all;
  _SalesRange _salesRange = _SalesRange.last7d;

  late final List<_ReportOrder> _orders = [
    _ReportOrder(
      id: '#2026-4102',
      status: _OrderStatus.pending,
      customer: 'Maria Santos',
      subtotal: 1146,
      shipping: 59,
      adminFee: 114.6,
      date: DateTime(2026, 4, 16, 9, 12),
      lines: const [
        _OrderLine('Premium Dog Food 2kg', 2, 399),
        _OrderLine('Chew Toy Set', 1, 149),
        _OrderLine('Pet Shampoo', 1, 199),
      ],
    ),
    _ReportOrder(
      id: '#2026-4105',
      status: _OrderStatus.processing,
      customer: 'Juan Dela Cruz',
      subtotal: 526,
      shipping: 49,
      adminFee: 52.6,
      date: DateTime(2026, 4, 15, 16, 40),
      lines: const [
        _OrderLine('Cat Litter 10L', 1, 289),
        _OrderLine('Cat Treats Pack', 3, 79),
      ],
    ),
    _ReportOrder(
      id: '#2026-4094',
      status: _OrderStatus.shipped,
      customer: 'Cynthia Ramos',
      subtotal: 438,
      shipping: 59,
      adminFee: 43.8,
      date: DateTime(2026, 4, 14, 11, 5),
      lines: const [
        _OrderLine('Dog Harness', 1, 259),
        _OrderLine('Collar with Tag', 1, 179),
      ],
    ),
    _ReportOrder(
      id: '#2026-4068',
      status: _OrderStatus.delivered,
      customer: 'Mark Villanueva',
      subtotal: 999,
      shipping: 0,
      adminFee: 99.9,
      date: DateTime(2026, 4, 13, 15, 20),
      lines: const [
        _OrderLine('Aquarium Filter', 1, 999),
      ],
    ),
    _ReportOrder(
      id: '#2026-4059',
      status: _OrderStatus.cancelled,
      customer: 'Alyssa Reyes',
      subtotal: 777,
      shipping: 59,
      adminFee: 0,
      date: DateTime(2026, 4, 12, 10, 2),
      lines: const [
        _OrderLine('Pet Bed', 1, 599),
        _OrderLine('Water Bowl', 2, 89),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOrders;
    final overview = _computeOverview(filtered);
    final topProducts = _computeTopProducts(filtered);

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
                _buildFilters(context),
                const SizedBox(height: 14),
                _OverviewPanel(overview: overview),
                const SizedBox(height: 14),
                _SalesTrendPanel(
                  range: _salesRange,
                  onRangeChanged: (v) => setState(() => _salesRange = v),
                  points: _pointsForRange(_salesRange),
                ),
                const SizedBox(height: 14),
                _SummaryPanel(overview: overview),
                const SizedBox(height: 14),
                _OrdersTablePanel(
                  orders: filtered,
                  statusChipBuilder: _statusChip,
                ),
                const SizedBox(height: 14),
                _TopProductsPanel(items: topProducts),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Seller Reports',
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
            child: const Icon(Icons.pie_chart_rounded, color: Color(0xFF051014)),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Export sales, orders, and commission data',
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

  Widget _buildFilters(BuildContext context) {
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
            'Filters',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DatePill(
                label: 'From',
                value: _fromDate == null ? '—' : _fmtDateOnly(_fromDate!),
                onTap: () async {
                  final d = await _pickDate(context, _fromDate);
                  if (d == null) return;
                  setState(() => _fromDate = d);
                },
              ),
              _DatePill(
                label: 'To',
                value: _toDate == null ? '—' : _fmtDateOnly(_toDate!),
                onTap: () async {
                  final d = await _pickDate(context, _toDate);
                  if (d == null) return;
                  setState(() => _toDate = d);
                },
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<_OrderStatusFilter>(
                  initialValue: _statusFilter,
                  items: _OrderStatusFilter.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(
                            s.label,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _statusFilter = v);
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: Colors.white,
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
              ),
              OutlinedButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
              OutlinedButton.icon(
                onPressed: () => _toast('Export CSV (prototype).'),
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('CSV'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: const Color(0xFF051014),
                ),
                onPressed: () => _toast('Export PDF (prototype).'),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text(
                  'PDF',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _fromDate = null;
                  _toDate = null;
                  _statusFilter = _OrderStatusFilter.all;
                }),
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<_ReportOrder> get _filteredOrders {
    return _orders.where((o) {
      if (_statusFilter.status != null && o.status != _statusFilter.status) {
        return false;
      }
      if (_fromDate != null) {
        final from = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
        if (o.date.isBefore(from)) return false;
      }
      if (_toDate != null) {
        final to = DateTime(_toDate!.year, _toDate!.month, _toDate!.day, 23, 59);
        if (o.date.isAfter(to)) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  _Overview _computeOverview(List<_ReportOrder> orders) {
    final totalOrders = orders.length;
    final delivered = orders.where((o) => o.status == _OrderStatus.delivered).length;
    final gross = orders.fold<double>(0, (s, o) => s + o.subtotal);
    final shipping = orders.fold<double>(0, (s, o) => s + o.shipping);
    final admin = orders.fold<double>(0, (s, o) => s + o.adminFee);
    final net = orders.fold<double>(0, (s, o) => s + o.sellerNet);
    return _Overview(
      totalOrders: totalOrders,
      deliveredOrders: delivered,
      grossSubtotal: gross,
      shippingCollected: shipping,
      adminFees: admin,
      sellerNet: net,
    );
  }

  List<_TopProduct> _computeTopProducts(List<_ReportOrder> orders) {
    final map = <String, _TopProduct>{};
    for (final o in orders) {
      for (final l in o.lines) {
        final current = map[l.title];
        final sales = l.qty * l.price;
        if (current == null) {
          map[l.title] = _TopProduct(title: l.title, qty: l.qty, sales: sales);
        } else {
          map[l.title] = _TopProduct(
            title: l.title,
            qty: current.qty + l.qty,
            sales: current.sales + sales,
          );
        }
      }
    }
    final list = map.values.toList();
    list.sort((a, b) => b.sales.compareTo(a.sales));
    return list.take(8).toList();
  }

  List<_TrendPoint> _pointsForRange(_SalesRange r) {
    switch (r) {
      case _SalesRange.last7d:
        return const [
          _TrendPoint('Mon', .32),
          _TrendPoint('Tue', .44),
          _TrendPoint('Wed', .38),
          _TrendPoint('Thu', .70),
          _TrendPoint('Fri', .52),
          _TrendPoint('Sat', .86),
          _TrendPoint('Sun', .62),
        ];
      case _SalesRange.monthly:
        return const [
          _TrendPoint('W1', .42),
          _TrendPoint('W2', .55),
          _TrendPoint('W3', .72),
          _TrendPoint('W4', .60),
        ];
      case _SalesRange.yearly:
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
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
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

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
  }

  static String _fmtDateOnly(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({required this.overview});
  final _Overview overview;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    final kpis = [
      ('Total Orders', '${overview.totalOrders}'),
      ('Gross Subtotal', '₱ ${overview.grossSubtotal.toStringAsFixed(0)}'),
      ('Shipping Collected', '₱ ${overview.shippingCollected.toStringAsFixed(0)}'),
      ('Fees (10%)', '₱ ${overview.adminFees.toStringAsFixed(0)}'),
      ('Net to Seller', '₱ ${overview.sellerNet.toStringAsFixed(0)}'),
    ];
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
            'Overview',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final isNarrow = c.maxWidth < 720;
              final cross = isNarrow ? 2 : 5;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kpis.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: isNarrow ? 2.4 : 1.9,
                ),
                itemBuilder: (context, index) {
                  final item = kpis[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x120B0F1A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            color: _muted,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          const Text(
            'Net to Seller = Gross Subtotal − Fees. Shipping is paid to rider.',
            style: TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesTrendPanel extends StatelessWidget {
  const _SalesTrendPanel({
    required this.range,
    required this.onRangeChanged,
    required this.points,
  });

  final _SalesRange range;
  final ValueChanged<_SalesRange> onRangeChanged;
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
                child: DropdownButton<_SalesRange>(
                  value: range,
                  onChanged: (v) {
                    if (v != null) onRangeChanged(v);
                  },
                  items: _SalesRange.values
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
            height: 340,
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
                                  height: 260 * p.value,
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

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.overview});
  final _Overview overview;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Total Orders', '${overview.totalOrders}'),
      ('Delivered Orders', '${overview.deliveredOrders}'),
      ('Gross Subtotal', '₱ ${overview.grossSubtotal.toStringAsFixed(0)}'),
      ('Shipping Collected', '₱ ${overview.shippingCollected.toStringAsFixed(0)}'),
      ('Admin Commission (10%)', '₱ ${overview.adminFees.toStringAsFixed(0)}'),
      ('Seller Net', '₱ ${overview.sellerNet.toStringAsFixed(0)}'),
    ];
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
            'Summary',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < rows.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              rows[i].$1,
                              style: const TextStyle(
                                color: _text,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            rows[i].$2,
                            style: const TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i != rows.length - 1)
                      Divider(height: 1, color: _muted.withValues(alpha: .12)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersTablePanel extends StatelessWidget {
  const _OrdersTablePanel({required this.orders, required this.statusChipBuilder});

  final List<_ReportOrder> orders;
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
            'Orders',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 1040),
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
                            _Cell('ID', w: 110, header: true),
                            _Cell('Status', w: 120, header: true),
                            _Cell('Customer', w: 160, header: true),
                            _Cell('Subtotal', w: 110, header: true),
                            _Cell('Shipping', w: 110, header: true),
                            _Cell('Admin', w: 100, header: true),
                            _Cell('Seller Net', w: 120, header: true),
                            _Cell('Date', w: 130, header: true),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      for (final o in orders) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              _Cell(o.id, w: 110),
                              SizedBox(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: statusChipBuilder(o.status),
                                ),
                              ),
                              _Cell(o.customer, w: 160),
                              _Cell('₱ ${o.subtotal.toStringAsFixed(0)}', w: 110),
                              _Cell('₱ ${o.shipping.toStringAsFixed(0)}', w: 110),
                              _Cell('₱ ${o.adminFee.toStringAsFixed(0)}', w: 100),
                              _Cell('₱ ${o.sellerNet.toStringAsFixed(0)}', w: 120),
                              _Cell(_fmtRowDate(o.date), w: 130),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: _muted.withValues(alpha: .12)),
                      ],
                      if (orders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                            'No orders match your filters.',
                            style: TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtRowDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _TopProductsPanel extends StatelessWidget {
  const _TopProductsPanel({required this.items});
  final List<_TopProduct> items;

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
            'Top Products (by sales)',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 434),
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
                            _Cell('Product', w: 220, header: true),
                            _Cell('Qty', w: 80, header: true),
                            _Cell('Sales (₱)', w: 110, header: true),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                            'No product sales to show.',
                            style: TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      else
                        ...items.map(
                          (p) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                _Cell(p.title, w: 220),
                                _Cell('${p.qty}', w: 80),
                                _Cell('₱ ${p.sales.toStringAsFixed(0)}', w: 110),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_outlined, color: _muted, size: 18),
            const SizedBox(width: 8),
            Text(
              '$label: ',
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
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

enum _SalesRange { last7d, monthly, yearly }

extension on _SalesRange {
  String get title {
    switch (this) {
      case _SalesRange.last7d:
        return 'Sales Trend (7 days)';
      case _SalesRange.monthly:
        return 'Sales Trend (Monthly)';
      case _SalesRange.yearly:
        return 'Sales Trend (Yearly)';
    }
  }

  String get menuLabel {
    switch (this) {
      case _SalesRange.last7d:
        return 'Last 7 days';
      case _SalesRange.monthly:
        return 'Monthly';
      case _SalesRange.yearly:
        return 'Yearly';
    }
  }
}

enum _OrderStatus { pending, processing, shipped, delivered, cancelled }

extension on _OrderStatus {
  String get label {
    switch (this) {
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
}

enum _OrderStatusFilter { all, pending, processing, shipped, delivered, cancelled }

extension on _OrderStatusFilter {
  String get label {
    switch (this) {
      case _OrderStatusFilter.all:
        return 'All Status';
      case _OrderStatusFilter.pending:
        return 'Pending';
      case _OrderStatusFilter.processing:
        return 'Processing';
      case _OrderStatusFilter.shipped:
        return 'Shipped';
      case _OrderStatusFilter.delivered:
        return 'Delivered';
      case _OrderStatusFilter.cancelled:
        return 'Cancelled';
    }
  }

  _OrderStatus? get status {
    switch (this) {
      case _OrderStatusFilter.all:
        return null;
      case _OrderStatusFilter.pending:
        return _OrderStatus.pending;
      case _OrderStatusFilter.processing:
        return _OrderStatus.processing;
      case _OrderStatusFilter.shipped:
        return _OrderStatus.shipped;
      case _OrderStatusFilter.delivered:
        return _OrderStatus.delivered;
      case _OrderStatusFilter.cancelled:
        return _OrderStatus.cancelled;
    }
  }
}

class _ReportOrder {
  _ReportOrder({
    required this.id,
    required this.status,
    required this.customer,
    required this.subtotal,
    required this.shipping,
    required this.adminFee,
    required this.date,
    required this.lines,
  });

  final String id;
  final _OrderStatus status;
  final String customer;
  final double subtotal;
  final double shipping;
  final double adminFee;
  final DateTime date;
  final List<_OrderLine> lines;

  double get sellerNet => subtotal - adminFee;
}

class _OrderLine {
  const _OrderLine(this.title, this.qty, this.price);
  final String title;
  final int qty;
  final double price;
}

class _Overview {
  const _Overview({
    required this.totalOrders,
    required this.deliveredOrders,
    required this.grossSubtotal,
    required this.shippingCollected,
    required this.adminFees,
    required this.sellerNet,
  });

  final int totalOrders;
  final int deliveredOrders;
  final double grossSubtotal;
  final double shippingCollected;
  final double adminFees;
  final double sellerNet;
}

class _TopProduct {
  const _TopProduct({required this.title, required this.qty, required this.sales});
  final String title;
  final int qty;
  final double sales;
}

class _TrendPoint {
  const _TrendPoint(this.label, this.value);
  final String label;
  final double value;
}

