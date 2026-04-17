import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'rider_bottom_nav.dart';

class RiderDeliveriesPage extends StatefulWidget {
  const RiderDeliveriesPage({super.key});

  @override
  State<RiderDeliveriesPage> createState() => _RiderDeliveriesPageState();
}

class _RiderDeliveriesPageState extends State<RiderDeliveriesPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _warning = Color(0xFFFFB86B);
  static const _success = Color(0xFF4ADE80);

  final _searchController = TextEditingController();
  _DeliveryFilter _filter = _DeliveryFilter.all;

  final List<_DeliveryTask> _tasks = [
    _DeliveryTask(
      orderId: '#2026-3201',
      customer: 'Maria Santos',
      pickup: 'Petopia Official (QC)',
      dropoff: 'Brgy. Bagong Pag-asa, Quezon City',
      earnings: 59,
      status: _DeliveryStatus.available,
    ),
    _DeliveryTask(
      orderId: '#2026-3202',
      customer: 'Juan Dela Cruz',
      pickup: 'PawSmart Supplies',
      dropoff: 'Makati City, NCR',
      earnings: 49,
      status: _DeliveryStatus.processing,
    ),
    _DeliveryTask(
      orderId: '#2026-3198',
      customer: 'Alyssa Reyes',
      pickup: 'FurCare Store',
      dropoff: 'Pasig City, NCR',
      earnings: 55,
      status: _DeliveryStatus.delivered,
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
    final filtered = _tasks.where((t) {
      if (_filter.status != null && t.status != _filter.status) {
        return false;
      }
      if (q.isEmpty) {
        return true;
      }
      return t.orderId.toLowerCase().contains(q) ||
          t.pickup.toLowerCase().contains(q) ||
          t.dropoff.toLowerCase().contains(q);
    }).toList();

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
                _buildPanel(context, filtered),
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
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Deliveries',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Manage your pickup and delivery tasks',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.riderHistory),
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('History'),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildPanel(BuildContext context, List<_DeliveryTask> tasks) {
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
              const Expanded(
                child: Text(
                  'Delivery Tasks',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                'Total: ${tasks.length}',
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by order ID or address...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in _DeliveryFilter.values) ...[
                  _FilterPill(
                    label: f.label,
                    selected: _filter == f,
                    onTap: () => setState(() => _filter = f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            const _EmptyState()
          else
            Column(
              children: [
                for (final task in tasks) ...[
                  _DeliveryCard(
                    task: task,
                    statusChip: _statusChip(task.status),
                    onPrimary: () => _handlePrimary(task),
                    onSecondary: () => _showDetails(task),
                    primaryLabel: _primaryLabel(task.status),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _statusChip(_DeliveryStatus status) {
    final color = switch (status) {
      _DeliveryStatus.available => _warning,
      _DeliveryStatus.processing => _accent2,
      _DeliveryStatus.delivered => _success,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12),
      ),
    );
  }

  String _primaryLabel(_DeliveryStatus status) {
    switch (status) {
      case _DeliveryStatus.available:
        return 'Accept';
      case _DeliveryStatus.processing:
        return 'Mark delivered';
      case _DeliveryStatus.delivered:
        return 'Completed';
    }
  }

  void _handlePrimary(_DeliveryTask task) {
    if (task.status == _DeliveryStatus.delivered) {
      _toast('Delivery already completed.');
      return;
    }
    setState(() {
      if (task.status == _DeliveryStatus.available) {
        task.status = _DeliveryStatus.processing;
      } else {
        task.status = _DeliveryStatus.delivered;
      }
    });
    _toast('Delivery ${task.orderId} updated.');
  }

  void _showDetails(_DeliveryTask task) {
    _toast(
      '${task.orderId}\n${task.pickup}\n→ ${task.dropoff}\nEarnings: PHP ${task.earnings.toStringAsFixed(0)}',
    );
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({
    required this.task,
    required this.statusChip,
    required this.onPrimary,
    required this.onSecondary,
    required this.primaryLabel,
  });

  final _DeliveryTask task;
  final Widget statusChip;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final String primaryLabel;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == _DeliveryStatus.delivered;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.orderId,
                  style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
                ),
              ),
              statusChip,
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.person_outline_rounded, text: task.customer),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.storefront_outlined, text: task.pickup),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.location_on_outlined, text: task.dropoff),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rider earnings',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'PHP ${task.earnings.toStringAsFixed(0)}',
                style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondary,
                  child: const Text('Details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: isDone ? null : onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: const Color(0xFF051014),
                  ),
                  child: Text(
                    primaryLabel,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: _muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _text = Color(0xFF0B0F1A);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _accent2.withValues(alpha: .16) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? _accent2.withValues(alpha: .35) : const Color(0x120B0F1A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _accent2 : _text,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
          Icon(Icons.local_shipping_outlined, size: 42, color: _muted),
          SizedBox(height: 10),
          Text(
            'No deliveries found',
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

enum _DeliveryStatus { available, processing, delivered }

extension on _DeliveryStatus {
  String get label {
    switch (this) {
      case _DeliveryStatus.available:
        return 'Available';
      case _DeliveryStatus.processing:
        return 'Processing';
      case _DeliveryStatus.delivered:
        return 'Delivered';
    }
  }
}

enum _DeliveryFilter { all, available, processing, delivered }

extension on _DeliveryFilter {
  String get label {
    switch (this) {
      case _DeliveryFilter.all:
        return 'All';
      case _DeliveryFilter.available:
        return 'Available';
      case _DeliveryFilter.processing:
        return 'Processing';
      case _DeliveryFilter.delivered:
        return 'Delivered';
    }
  }

  _DeliveryStatus? get status {
    switch (this) {
      case _DeliveryFilter.all:
        return null;
      case _DeliveryFilter.available:
        return _DeliveryStatus.available;
      case _DeliveryFilter.processing:
        return _DeliveryStatus.processing;
      case _DeliveryFilter.delivered:
        return _DeliveryStatus.delivered;
    }
  }
}

class _DeliveryTask {
  _DeliveryTask({
    required this.orderId,
    required this.customer,
    required this.pickup,
    required this.dropoff,
    required this.earnings,
    required this.status,
  });

  final String orderId;
  final String customer;
  final String pickup;
  final String dropoff;
  final double earnings;
  _DeliveryStatus status;
}

