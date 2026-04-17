import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'rider_bottom_nav.dart';

class RiderHistoryPage extends StatefulWidget {
  const RiderHistoryPage({super.key});

  @override
  State<RiderHistoryPage> createState() => _RiderHistoryPageState();
}

class _RiderHistoryPageState extends State<RiderHistoryPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<_HistoryItem> _history = [
    _HistoryItem(
      orderId: '#2026-3198',
      customer: 'Alyssa Reyes',
      pickup: 'FurCare Store',
      dropoff: 'Pasig City, NCR',
      date: DateTime(2026, 4, 14),
      fee: 55,
      status: _HistoryStatus.delivered,
    ),
    _HistoryItem(
      orderId: '#2026-3192',
      customer: 'Mark Villanueva',
      pickup: 'Petopia Official (QC)',
      dropoff: 'Makati City, NCR',
      date: DateTime(2026, 4, 13),
      fee: 52,
      status: _HistoryStatus.delivered,
    ),
    _HistoryItem(
      orderId: '#2026-3184',
      customer: 'John Ramos',
      pickup: 'PawSmart Supplies',
      dropoff: 'Taguig City, NCR',
      date: DateTime(2026, 4, 12),
      fee: 0,
      status: _HistoryStatus.cancelled,
    ),
    _HistoryItem(
      orderId: '#2026-3175',
      customer: 'Cynthia Cruz',
      pickup: 'Petopia Official (QC)',
      dropoff: 'Quezon City, NCR',
      date: DateTime(2026, 4, 10),
      fee: 48,
      status: _HistoryStatus.delivered,
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
    final filtered = _history.where((h) {
      if (_fromDate != null) {
        final from = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
        if (h.date.isBefore(from)) return false;
      }
      if (_toDate != null) {
        final to = DateTime(_toDate!.year, _toDate!.month, _toDate!.day, 23, 59);
        if (h.date.isAfter(to)) return false;
      }
      if (q.isEmpty) return true;
      return h.orderId.toLowerCase().contains(q) ||
          h.customer.toLowerCase().contains(q) ||
          h.pickup.toLowerCase().contains(q) ||
          h.dropoff.toLowerCase().contains(q);
    }).toList();

    final completed = filtered.where((h) => h.status == _HistoryStatus.delivered).length;
    final totalFee = filtered.fold<double>(0, (sum, h) => sum + h.fee);

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
                _buildPanel(filtered, completed, totalFee),
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
        currentIndex: 1,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderDeliveries);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderEarnings);
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
            child: const Icon(Icons.history_rounded, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery History',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Review completed and past delivery records',
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

  Widget _buildPanel(List<_HistoryItem> items, int completed, double totalFee) {
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
          _KpiGrid(
            totalRecords: items.length,
            completed: completed,
            totalFee: totalFee,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search order ID, customer, or address...',
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _FilterChipButton(
                icon: Icons.date_range_rounded,
                label: _fromDate == null ? 'From date' : _fmtDate(_fromDate!),
                onTap: () async {
                  final d = await _pickDate(context, _fromDate);
                  if (d == null) return;
                  setState(() => _fromDate = d);
                },
              ),
              _FilterChipButton(
                icon: Icons.event_available_rounded,
                label: _toDate == null ? 'To date' : _fmtDate(_toDate!),
                onTap: () async {
                  final d = await _pickDate(context, _toDate);
                  if (d == null) return;
                  setState(() => _toDate = d);
                },
              ),
              if (_fromDate != null || _toDate != null || _searchController.text.isNotEmpty)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _fromDate = null;
                    _toDate = null;
                    _searchController.clear();
                  }),
                  icon: const Icon(Icons.clear_rounded),
                  label: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTable(items),
        ],
      ),
    );
  }

  Widget _buildTable(List<_HistoryItem> items) {
    if (items.isEmpty) {
      return const _EmptyHistory();
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
            constraints: const BoxConstraints(minWidth: 940),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: const Color(0xFFF8FAFF),
                  child: const Row(
                    children: [
                      _Cell('Order ID', w: 110, header: true),
                      _Cell('Customer', w: 140, header: true),
                      _Cell('Pickup Address', w: 180, header: true),
                      _Cell('Delivery Address', w: 180, header: true),
                      _Cell('Date', w: 110, header: true),
                      _Cell('Status', w: 110, header: true),
                      _Cell('Fee', w: 90, header: true),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (final h in items) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        _Cell(h.orderId, w: 110),
                        _Cell(h.customer, w: 140),
                        _Cell(h.pickup, w: 180),
                        _Cell(h.dropoff, w: 180),
                        _Cell(_fmtDate(h.date), w: 110),
                        SizedBox(
                          width: 110,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _StatusPill(status: h.status),
                          ),
                        ),
                        _Cell('PHP ${h.fee.toStringAsFixed(0)}', w: 90),
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

  Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(2024),
      lastDate: DateTime(2032),
    );
  }

  static String _fmtDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.totalRecords,
    required this.completed,
    required this.totalFee,
  });

  final int totalRecords;
  final int completed;
  final double totalFee;

  static const _accent2 = Color(0xFF8BB6FF);
  static const _success = Color(0xFF4ADE80);
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
              icon: Icons.receipt_long_outlined,
              iconColor: _accent2,
              label: 'Total Records',
              value: '$totalRecords',
            ),
            _KpiTile(
              icon: Icons.check_circle_outline_rounded,
              iconColor: _success,
              label: 'Completed',
              value: '$completed',
            ),
            _KpiTile(
              icon: Icons.payments_outlined,
              iconColor: _warning,
              label: 'Total Fee',
              value: 'PHP ${totalFee.toStringAsFixed(0)}',
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

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: _muted),
      label: Text(
        label,
        style: const TextStyle(
          color: _text,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: _text,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0x120B0F1A)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final _HistoryStatus status;

  static const _success = Color(0xFF4ADE80);
  static const _warning = Color(0xFFFFB86B);
  static const _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _HistoryStatus.delivered => _success,
      _HistoryStatus.pending => _warning,
      _HistoryStatus.cancelled => _danger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
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

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

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
          Icon(Icons.archive_outlined, size: 42, color: _muted),
          SizedBox(height: 10),
          Text(
            'No delivery history found',
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

enum _HistoryStatus { delivered, pending, cancelled }

extension on _HistoryStatus {
  String get label {
    switch (this) {
      case _HistoryStatus.delivered:
        return 'Delivered';
      case _HistoryStatus.pending:
        return 'Pending';
      case _HistoryStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class _HistoryItem {
  const _HistoryItem({
    required this.orderId,
    required this.customer,
    required this.pickup,
    required this.dropoff,
    required this.date,
    required this.status,
    required this.fee,
  });

  final String orderId;
  final String customer;
  final String pickup;
  final String dropoff;
  final DateTime date;
  final _HistoryStatus status;
  final double fee;
}

