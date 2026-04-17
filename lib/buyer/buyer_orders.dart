import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'buyer_bottom_nav.dart';

class BuyerOrdersPage extends StatefulWidget {
  const BuyerOrdersPage({super.key});

  @override
  State<BuyerOrdersPage> createState() => _BuyerOrdersPageState();
}

class _BuyerOrdersPageState extends State<BuyerOrdersPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final int _currentIndex = 1;
  String _activeFilter = 'all';

  final List<_OrderData> _orders = [
    _OrderData(
      id: 'PTP-10241',
      status: 'to_pay',
      items: [
        _OrderItem(
          name: 'Orthopedic Pet Bed',
          qty: 1,
          price: 1350,
          store: 'SleepyPaws',
        ),
      ],
      shippingFee: 59,
      date: 'Apr 17, 2026',
    ),
    _OrderData(
      id: 'PTP-10238',
      status: 'to_ship',
      items: [
        _OrderItem(
          name: 'Premium Dog Food 5kg',
          qty: 1,
          price: 899,
          store: 'Petopia Official',
        ),
        _OrderItem(
          name: 'Portable Water Bottle',
          qty: 2,
          price: 189,
          store: 'Happy Tails Shop',
        ),
      ],
      shippingFee: 59,
      date: 'Apr 15, 2026',
    ),
    _OrderData(
      id: 'PTP-10233',
      status: 'to_receive',
      items: [
        _OrderItem(
          name: 'Automatic Feeder',
          qty: 1,
          price: 1999,
          store: 'PetTech Hub',
        ),
      ],
      shippingFee: 59,
      date: 'Apr 13, 2026',
    ),
    _OrderData(
      id: 'PTP-10220',
      status: 'completed',
      items: [
        _OrderItem(
          name: 'Pet Grooming Kit',
          qty: 1,
          price: 749,
          store: 'FurCare Store',
        ),
      ],
      shippingFee: 59,
      date: 'Apr 05, 2026',
    ),
    _OrderData(
      id: 'PTP-10212',
      status: 'cancelled',
      items: [
        _OrderItem(
          name: 'Cat Scratching Post',
          qty: 1,
          price: 799,
          store: 'Playful Paws',
        ),
      ],
      shippingFee: 59,
      date: 'Apr 01, 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOrders;

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
                _buildOrdersSection(context, filtered),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Buyer Orders',
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
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 1) {
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerCart);
            return;
          }
          if (value == 3) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerProfile);
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.buyerDashboard,
            arguments: {'tab': value},
          );
        },
      ),
    );
  }

  List<_OrderData> get _filteredOrders {
    if (_activeFilter == 'all') {
      return _orders;
    }
    return _orders.where((o) => o.status == _activeFilter).toList();
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
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'View and track your order progress',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.buyerDashboard),
            child: const Text('Shop'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, List<_OrderData> orders) {
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoutes.buyerDashboard),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTabs(),
          const SizedBox(height: 12),
          _buildOrdersWrap(orders),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const tabs = [
      ('all', 'All'),
      ('to_pay', 'To Pay'),
      ('to_ship', 'To Ship'),
      ('to_receive', 'To Receive'),
      ('completed', 'Completed'),
      ('cancelled', 'Cancelled'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tabs.map((tab) {
        final isActive = _activeFilter == tab.$1;
        return GestureDetector(
          onTap: () => setState(() => _activeFilter = tab.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? _tabBg(tab.$1) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? _tabBorder(tab.$1) : const Color(0x140B0F1A),
              ),
            ),
            child: Text(
              tab.$2,
              style: TextStyle(
                color: isActive ? _tabText(tab.$1) : const Color(0xFF23272F),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrdersWrap(List<_OrderData> orders) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x1AE5E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'No orders yet. Start shopping and place your first order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OrderCard(
                order: order,
                onAction: () => _handlePrimaryAction(order),
                onSecondaryAction: () => _handleSecondaryAction(order),
                onViewItems: () => _openItemsSheet(order),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePrimaryAction(_OrderData order) {
    switch (order.status) {
      case 'to_pay':
        _info('Proceed to payment for order ${order.id}.');
        break;
      case 'to_ship':
        _info('Seller is preparing your package for order ${order.id}.');
        break;
      case 'to_receive':
        _info('Track your rider for order ${order.id}.');
        break;
      case 'completed':
        _info('Review flow for order ${order.id} can open here.');
        break;
      case 'cancelled':
        _info('Reorder flow for order ${order.id} is available.');
        break;
      default:
        _info('Order action unavailable.');
    }
  }

  void _handleSecondaryAction(_OrderData order) {
    switch (order.status) {
      case 'to_pay':
        _info('Cancel order ${order.id} request sent.');
        break;
      case 'to_ship':
        _info('Contact seller flow for ${order.id}.');
        break;
      case 'to_receive':
        _info('Confirm delivery for ${order.id}.');
        break;
      case 'completed':
        _info('Buy again flow for ${order.id}.');
        break;
      case 'cancelled':
        _info('View cancellation reason for ${order.id}.');
        break;
      default:
        _info('Order action unavailable.');
    }
  }

  Future<void> _openItemsSheet(_OrderData order) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Color(0xFFF6F8FF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x330B0F1A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Order ${order.id} Items',
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                ...order.items.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x120B0F1A)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDEAFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            color: Color(0xFF2E5EA7),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${item.name} • Qty ${item.qty}',
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '₱${_peso(item.lineTotal)}',
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: const Color(0xFF051014),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _info(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static String _peso(int value) {
    final s = value.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      b.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        b.write(',');
      }
    }
    return b.toString();
  }

  static Color _tabBg(String key) {
    switch (key) {
      case 'to_pay':
        return const Color(0x33FFB86B);
      case 'to_ship':
        return const Color(0x338BB6FF);
      case 'to_receive':
        return const Color(0x337CF4D1);
      case 'completed':
        return const Color(0x334ADE80);
      case 'cancelled':
        return const Color(0x26EF4444);
      default:
        return const Color(0x1F8BB6FF);
    }
  }

  static Color _tabBorder(String key) {
    switch (key) {
      case 'to_pay':
        return const Color(0x73FFB86B);
      case 'to_ship':
        return const Color(0x738BB6FF);
      case 'to_receive':
        return const Color(0x737CF4D1);
      case 'completed':
        return const Color(0x734ADE80);
      case 'cancelled':
        return const Color(0x59EF4444);
      default:
        return const Color(0x738BB6FF);
    }
  }

  static Color _tabText(String key) {
    switch (key) {
      case 'to_pay':
        return const Color(0xFFFFB86B);
      case 'to_ship':
        return const Color(0xFF8BB6FF);
      case 'to_receive':
        return const Color(0xFF2EBE96);
      case 'completed':
        return const Color(0xFF4ADE80);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8BB6FF);
    }
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onAction,
    required this.onSecondaryAction,
    required this.onViewItems,
  });

  final _OrderData order;
  final VoidCallback onAction;
  final VoidCallback onSecondaryAction;
  final VoidCallback onViewItems;

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(order.status);
    final visibleItems = order.items.take(2).toList();
    final hiddenCount = order.items.length - visibleItems.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFF),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: const Color(0x120B0F1A)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      color: _BuyerOrdersPageState._text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: status.$2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status.$1,
                    style: TextStyle(
                      color: status.$3,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...visibleItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDEAFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            color: Color(0xFF2E5EA7),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _BuyerOrdersPageState._text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${item.store} • Qty ${item.qty}',
                                style: const TextStyle(
                                  color: _BuyerOrdersPageState._muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₱${_BuyerOrdersPageState._peso(item.lineTotal)}',
                          style: const TextStyle(
                            color: _BuyerOrdersPageState._text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (hiddenCount > 0)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onViewItems,
                      child: Text('View $hiddenCount more item(s)'),
                    ),
                  ),
                const SizedBox(height: 4),
                _summaryRow('Date', order.date),
                _summaryRow(
                  'Items Subtotal',
                  '₱${_BuyerOrdersPageState._peso(order.subtotal)}',
                ),
                _summaryRow(
                  'Shipping',
                  '₱${_BuyerOrdersPageState._peso(order.shippingFee)}',
                ),
                const Divider(height: 18),
                _summaryRow(
                  'Total',
                  '₱${_BuyerOrdersPageState._peso(order.total)}',
                  isTotal: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSecondaryAction,
                        child: Text(status.$5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7CF4D1),
                          foregroundColor: const Color(0xFF051014),
                        ),
                        child: Text(status.$4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: _BuyerOrdersPageState._muted,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: _BuyerOrdersPageState._text,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ],
    );
  }

  /// label, bg, text, primaryAction, secondaryAction
  static (String, Color, Color, String, String) _statusMeta(String status) {
    switch (status) {
      case 'to_pay':
        return (
          'To Pay',
          const Color(0x33FFB86B),
          const Color(0xFFFFB86B),
          'Pay Now',
          'Cancel',
        );
      case 'to_ship':
        return (
          'To Ship',
          const Color(0x338BB6FF),
          const Color(0xFF8BB6FF),
          'View Progress',
          'Contact Seller',
        );
      case 'to_receive':
        return (
          'To Receive',
          const Color(0x337CF4D1),
          const Color(0xFF2EBE96),
          'Track Order',
          'Confirm Delivery',
        );
      case 'completed':
        return (
          'Completed',
          const Color(0x334ADE80),
          const Color(0xFF4ADE80),
          'Rate & Review',
          'Buy Again',
        );
      case 'cancelled':
        return (
          'Cancelled',
          const Color(0x26EF4444),
          const Color(0xFFEF4444),
          'Reorder',
          'View Reason',
        );
      default:
        return (
          'Unknown',
          const Color(0x1F8BB6FF),
          const Color(0xFF8BB6FF),
          'View',
          'Details',
        );
    }
  }
}

class _OrderData {
  const _OrderData({
    required this.id,
    required this.status,
    required this.items,
    required this.shippingFee,
    required this.date,
  });

  final String id;
  final String status;
  final List<_OrderItem> items;
  final int shippingFee;
  final String date;

  int get subtotal => items.fold<int>(0, (s, i) => s + i.lineTotal);
  int get total => subtotal + shippingFee;
}

class _OrderItem {
  const _OrderItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.store,
  });

  final String name;
  final int qty;
  final int price;
  final String store;

  int get lineTotal => qty * price;
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
