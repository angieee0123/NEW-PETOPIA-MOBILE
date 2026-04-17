import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerOrdersPage extends StatefulWidget {
  const SellerOrdersPage({super.key});

  @override
  State<SellerOrdersPage> createState() => _SellerOrdersPageState();
}

class _SellerOrdersPageState extends State<SellerOrdersPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _warning = Color(0xFFFFB86B);
  static const _success = Color(0xFF4ADE80);
  static const _danger = Color(0xFFEF4444);

  final _searchController = TextEditingController();
  _OrderFilter _filter = _OrderFilter.all;

  late final List<_SellerOrder> _orders = [
    _SellerOrder(
      id: '#2026-4102',
      customerName: 'Maria Santos',
      customerContact: 'maria.santos@email.com',
      status: _OrderStatus.pending,
      placedAt: DateTime(2026, 4, 16, 9, 12),
      shippingFee: 59,
      items: const [
        _OrderLine(
          title: 'Premium Dog Food 2kg',
          variant: 'Chicken',
          qty: 2,
          price: 399,
          image: 'assets/images/placeholder.png',
        ),
        _OrderLine(
          title: 'Chew Toy Set',
          variant: 'Large',
          qty: 1,
          price: 149,
          image: 'assets/images/placeholder.png',
        ),
        _OrderLine(
          title: 'Pet Shampoo',
          variant: 'Oatmeal',
          qty: 1,
          price: 199,
          image: 'assets/images/placeholder.png',
        ),
      ],
    ),
    _SellerOrder(
      id: '#2026-4105',
      customerName: 'Juan Dela Cruz',
      customerContact: '+63 9xx xxx xxxx',
      status: _OrderStatus.processing,
      placedAt: DateTime(2026, 4, 15, 16, 40),
      shippingFee: 49,
      items: const [
        _OrderLine(
          title: 'Cat Litter 10L',
          variant: 'Unscented',
          qty: 1,
          price: 289,
          image: 'assets/images/placeholder.png',
        ),
        _OrderLine(
          title: 'Cat Treats Pack',
          variant: 'Tuna',
          qty: 3,
          price: 79,
          image: 'assets/images/placeholder.png',
        ),
      ],
    ),
    _SellerOrder(
      id: '#2026-4094',
      customerName: 'Cynthia Ramos',
      customerContact: 'cynthia.ramos@email.com',
      status: _OrderStatus.shipped,
      placedAt: DateTime(2026, 4, 14, 11, 5),
      shippingFee: 59,
      items: const [
        _OrderLine(
          title: 'Dog Harness',
          variant: 'Medium / Blue',
          qty: 1,
          price: 259,
          image: 'assets/images/placeholder.png',
        ),
        _OrderLine(
          title: 'Collar with Tag',
          variant: 'Small',
          qty: 1,
          price: 179,
          image: 'assets/images/placeholder.png',
        ),
      ],
    ),
    _SellerOrder(
      id: '#2026-4068',
      customerName: 'Mark Villanueva',
      customerContact: 'markv@email.com',
      status: _OrderStatus.delivered,
      placedAt: DateTime(2026, 4, 13, 15, 20),
      shippingFee: 0,
      items: const [
        _OrderLine(
          title: 'Aquarium Filter',
          variant: 'Model A',
          qty: 1,
          price: 999,
          image: 'assets/images/placeholder.png',
        ),
      ],
    ),
    _SellerOrder(
      id: '#2026-4059',
      customerName: 'Alyssa Reyes',
      customerContact: 'alyssa.reyes@email.com',
      status: _OrderStatus.cancelled,
      placedAt: DateTime(2026, 4, 12, 10, 2),
      shippingFee: 59,
      items: const [
        _OrderLine(
          title: 'Pet Bed',
          variant: 'Large / Gray',
          qty: 1,
          price: 599,
          image: 'assets/images/placeholder.png',
        ),
        _OrderLine(
          title: 'Water Bowl',
          variant: 'Steel',
          qty: 2,
          price: 89,
          image: 'assets/images/placeholder.png',
        ),
      ],
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
    final filtered = _orders.where((o) {
      final matchesFilter = _filter == _OrderFilter.all
          ? true
          : o.status == _filter.status;
      if (!matchesFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final matches =
          o.id.toLowerCase().contains(query) ||
          o.customerName.toLowerCase().contains(query);
      return matches;
    }).toList();

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Column(
                      children: [
                        _buildTopBar(context),
                        const SizedBox(height: 14),
                        _buildOrdersPanel(context, filtered),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SellerBottomNav(
        currentIndex: 2,
        onTap: (value) {
          if (value == 2) {
            return;
          }
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerProducts);
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
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [_accent, _accent2]),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A8BB6FF),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF051014),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Manage incoming orders and fulfillment',
                style: TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _TopIconButton(
          icon: Icons.refresh_rounded,
          onTap: () => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildOrdersPanel(BuildContext context, List<_SellerOrder> orders) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seller Orders',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
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
          _buildTabs(),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const _EmptyState(
              icon: Icons.inbox_outlined,
              title: 'No orders found',
              subtitle: 'Try changing your filters or search term.',
            )
          else
            Column(
              children: [
                for (final order in orders) ...[
                  _OrderCard(
                    order: order,
                    onViewItems: () => _openItemsSheet(context, order),
                    onPrimaryAction: () => _handlePrimary(order),
                    onSecondaryAction: () => _handleSecondary(order),
                    onDangerAction: () => _handleCancel(order),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = _OrderFilter.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final t in tabs) ...[
            _FilterPill(
              label: t.label,
              selected: _filter == t,
              color: t.color,
              onTap: () => setState(() => _filter = t),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  void _handlePrimary(_SellerOrder order) {
    switch (order.status) {
      case _OrderStatus.pending:
        setState(() => order.status = _OrderStatus.processing);
        _toast('Order ${order.id} accepted.');
        return;
      case _OrderStatus.processing:
        setState(() => order.status = _OrderStatus.shipped);
        _toast('Order ${order.id} marked as shipped.');
        return;
      case _OrderStatus.shipped:
        setState(() => order.status = _OrderStatus.delivered);
        _toast('Order ${order.id} marked as delivered.');
        return;
      case _OrderStatus.delivered:
      case _OrderStatus.cancelled:
        _toast('No primary action for this status.');
        return;
    }
  }

  void _handleSecondary(_SellerOrder order) {
    _openOrderDetailsSheet(context, order);
  }

  void _handleCancel(_SellerOrder order) {
    if (order.status == _OrderStatus.cancelled ||
        order.status == _OrderStatus.delivered) {
      _toast('This order can no longer be cancelled.');
      return;
    }
    setState(() => order.status = _OrderStatus.cancelled);
    _toast('Order ${order.id} cancelled (prototype).');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openItemsSheet(BuildContext context, _SellerOrder order) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xECFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0x120B0F1A)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26101828),
                  blurRadius: 30,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x330B0F1A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Items • ${order.id}',
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${order.customerName} • ${_statusLabel(order.status)}',
                                style: const TextStyle(
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
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      itemCount: order.items.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final line = order.items[index];
                        return _ItemRow(line: line);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openOrderDetailsSheet(
    BuildContext context,
    _SellerOrder order,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final subtotal = order.subtotal;
        final total = order.total;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xECFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0x120B0F1A)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26101828),
                  blurRadius: 30,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x330B0F1A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order details • ${order.id}',
                            style: const TextStyle(
                              color: _text,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.person_outline_rounded,
                          title: order.customerName,
                          subtitle: order.customerContact,
                        ),
                        const SizedBox(height: 10),
                        _InfoTile(
                          icon: Icons.schedule_rounded,
                          title: 'Placed',
                          subtitle: _formatPlacedAt(order.placedAt),
                        ),
                        const SizedBox(height: 10),
                        _InfoTile(
                          icon: Icons.local_shipping_outlined,
                          title: 'Delivery method',
                          subtitle: 'Standard delivery (prototype)',
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x0F8BB6FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0x120B0F1A)),
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label: 'Subtotal',
                                value: 'PHP ${subtotal.toStringAsFixed(0)}',
                              ),
                              const SizedBox(height: 6),
                              _SummaryRow(
                                label: 'Shipping',
                                value: 'PHP ${order.shippingFee.toStringAsFixed(0)}',
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 1),
                              const SizedBox(height: 10),
                              _SummaryRow(
                                label: 'Total',
                                value: 'PHP ${total.toStringAsFixed(0)}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _toast('Print receipt (prototype).');
                                },
                                icon: const Icon(Icons.print_outlined),
                                label: const Text('Print receipt'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _toast('Message customer (prototype).');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: const Color(0xFF051014),
                                ),
                                icon: const Icon(Icons.chat_bubble_outline_rounded),
                                label: const Text('Message'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _formatPlacedAt(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    final m = two(dt.month);
    final d = two(dt.day);
    final h = two(dt.hour);
    final min = two(dt.minute);
    return '${dt.year}-$m-$d  $h:$min';
  }

  static String _statusLabel(_OrderStatus status) {
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

  Color _statusBg(_OrderStatus status) {
    return _statusColor(status).withValues(alpha: .18);
  }

  String? _primaryActionLabel(_OrderStatus status) {
    switch (status) {
      case _OrderStatus.pending:
        return 'Accept';
      case _OrderStatus.processing:
        return 'Mark shipped';
      case _OrderStatus.shipped:
        return 'Mark delivered';
      case _OrderStatus.delivered:
      case _OrderStatus.cancelled:
        return null;
    }
  }

  String? _dangerActionLabel(_OrderStatus status) {
    switch (status) {
      case _OrderStatus.pending:
      case _OrderStatus.processing:
      case _OrderStatus.shipped:
        return 'Cancel';
      case _OrderStatus.delivered:
      case _OrderStatus.cancelled:
        return null;
    }
  }

  Widget _statusChip(_OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _statusBg(status),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _statusColor(status).withValues(alpha: .35)),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onViewItems,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
    required this.onDangerAction,
  });

  final _SellerOrder order;
  final VoidCallback onViewItems;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;
  final VoidCallback onDangerAction;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_SellerOrdersPageState>();
    final chip = state?._statusChip(order.status) ??
        const SizedBox.shrink();
    final primaryLabel = state?._primaryActionLabel(order.status);
    final dangerLabel = state?._dangerActionLabel(order.status);

    final itemsToShow = order.items.take(2).toList();
    final hiddenCount = order.items.length - itemsToShow.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FBFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                chip,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0x148BB6FF),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF2E5EA7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.customerContact,
                            style: const TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Details',
                      onPressed: onSecondaryAction,
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final line in itemsToShow) ...[
                  _MiniItemRow(line: line),
                  const SizedBox(height: 10),
                ],
                if (hiddenCount > 0)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onViewItems,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x128BB6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x258BB6FF)),
                      ),
                      child: Text(
                        'View $hiddenCount more item(s)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF2E5EA7),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x0F8BB6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x120B0F1A)),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: 'PHP ${order.subtotal.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: 6),
                      _SummaryRow(
                        label: 'Shipping',
                        value: 'PHP ${order.shippingFee.toStringAsFixed(0)}',
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      _SummaryRow(
                        label: 'Total',
                        value: 'PHP ${order.total.toStringAsFixed(0)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSecondaryAction,
                        child: const Text('Details'),
                      ),
                    ),
                    if (dangerLabel != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onDangerAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _danger,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(dangerLabel),
                        ),
                      ),
                    ],
                    if (primaryLabel != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPrimaryAction,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniItemRow extends StatelessWidget {
  const _MiniItemRow({required this.line});

  final _OrderLine line;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: const Icon(Icons.inventory_2_outlined, color: _muted),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${line.variant} • x${line.qty}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'PHP ${(line.price * line.qty).toStringAsFixed(0)}',
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.line});

  final _OrderLine line;

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
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: _muted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${line.variant} • x${line.qty}',
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'PHP ${(line.price * line.qty).toStringAsFixed(0)}',
            style: const TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isTotal ? _text : _muted,
      fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0x148BB6FF),
            child: Icon(icon, color: const Color(0xFF2E5EA7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  static const _text = Color(0xFF0B0F1A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .16) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: .4)
                : const Color(0x120B0F1A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : _text,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
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

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: .88),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Icon(icon, color: const Color(0xFF0B0F1A)),
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

enum _OrderStatus { pending, processing, shipped, delivered, cancelled }

enum _OrderFilter {
  all,
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case _OrderFilter.all:
        return 'All';
      case _OrderFilter.pending:
        return 'Pending';
      case _OrderFilter.processing:
        return 'Processing';
      case _OrderFilter.shipped:
        return 'Shipped';
      case _OrderFilter.delivered:
        return 'Delivered';
      case _OrderFilter.cancelled:
        return 'Cancelled';
    }
  }

  _OrderStatus? get status {
    switch (this) {
      case _OrderFilter.all:
        return null;
      case _OrderFilter.pending:
        return _OrderStatus.pending;
      case _OrderFilter.processing:
        return _OrderStatus.processing;
      case _OrderFilter.shipped:
        return _OrderStatus.shipped;
      case _OrderFilter.delivered:
        return _OrderStatus.delivered;
      case _OrderFilter.cancelled:
        return _OrderStatus.cancelled;
    }
  }

  Color get color {
    switch (this) {
      case _OrderFilter.all:
        return const Color(0xFF0B0F1A);
      case _OrderFilter.pending:
        return const Color(0xFFFFB86B);
      case _OrderFilter.processing:
        return const Color(0xFF8BB6FF);
      case _OrderFilter.shipped:
        return const Color(0xFF7CF4D1);
      case _OrderFilter.delivered:
        return const Color(0xFF4ADE80);
      case _OrderFilter.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

class _SellerOrder {
  _SellerOrder({
    required this.id,
    required this.customerName,
    required this.customerContact,
    required this.status,
    required this.placedAt,
    required this.items,
    required this.shippingFee,
  });

  final String id;
  final String customerName;
  final String customerContact;
  _OrderStatus status;
  final DateTime placedAt;
  final List<_OrderLine> items;
  final double shippingFee;

  double get subtotal =>
      items.fold(0, (sum, l) => sum + (l.price * l.qty));

  double get total => subtotal + shippingFee;
}

class _OrderLine {
  const _OrderLine({
    required this.title,
    required this.variant,
    required this.qty,
    required this.price,
    required this.image,
  });

  final String title;
  final String variant;
  final int qty;
  final double price;
  final String image;
}

