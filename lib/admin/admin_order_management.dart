import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminOrderManagementPage extends StatefulWidget {
  const AdminOrderManagementPage({super.key});

  @override
  State<AdminOrderManagementPage> createState() =>
      _AdminOrderManagementPageState();
}

class _AdminOrderManagementPageState extends State<AdminOrderManagementPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _customerController = TextEditingController();

  String _activeTab = 'all';
  String _statusFilter = 'all';
  String _dateFilter = 'all';

  final List<_AdminOrder> _orders = [
    _AdminOrder(
      id: 'ORD-3001',
      customerName: 'Maria Santos',
      customerPhone: '09171234567',
      customerAddress: 'Quezon City, NCR',
      status: _OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      paymentMethod: 'COD',
      shopName: 'Angelica Pet Supplies',
      items: [
        _OrderItem('Premium Dog Food 5kg', 1, 899),
        _OrderItem('Portable Water Bottle', 2, 189),
      ],
      shipping: 45,
    ),
    _AdminOrder(
      id: 'ORD-3002',
      customerName: 'Jerome Villanueva',
      customerPhone: '09987654321',
      customerAddress: 'Cebu City, Cebu',
      status: _OrderStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'GCash',
      shopName: 'PawSmart Supplies',
      items: [
        _OrderItem('Calming Pet Shampoo', 1, 275),
        _OrderItem('Dental Chews', 1, 299),
      ],
      shipping: 60,
    ),
    _AdminOrder(
      id: 'ORD-3003',
      customerName: 'Alex Dela Cruz',
      customerPhone: '09199887766',
      customerAddress: 'Davao City',
      status: _OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      paymentMethod: 'Card',
      shopName: 'Happy Tails Shop',
      items: [_OrderItem('Cat Scratching Post', 1, 799)],
      shipping: 80,
    ),
    _AdminOrder(
      id: 'ORD-3004',
      customerName: 'Liza Mae',
      customerPhone: '09170000000',
      customerAddress: 'Pasig City',
      status: _OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'COD',
      shopName: 'FurCare Store',
      items: [_OrderItem('Cat Litter 10L', 2, 289)],
      shipping: 55,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredOrders();
    final total = _orders.length;
    final pending = _orders
        .where((e) => e.status == _OrderStatus.pending)
        .length;
    final processing = _orders
        .where((e) => e.status == _OrderStatus.processing)
        .length;
    final delivered = _orders
        .where((e) => e.status == _OrderStatus.delivered)
        .length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.orders,
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
                _buildHeader(),
                const SizedBox(height: 12),
                _buildStats(
                  total: total,
                  pending: pending,
                  processing: processing,
                  delivered: delivered,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildOrdersPanel(filtered),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Admin Order Management',
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          Row(
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
                  Icons.shopping_cart_checkout_rounded,
                  color: Color(0xFF051014),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Management',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Monitor and manage all marketplace orders',
                      style: TextStyle(
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
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search orders, customers, products...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x120B0F1A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats({
    required int total,
    required int pending,
    required int processing,
    required int delivered,
  }) {
    final stats = [
      _StatData('Total Orders', '$total', Icons.shopping_cart_outlined),
      _StatData('Pending', '$pending', Icons.schedule_rounded),
      _StatData('Processing', '$processing', Icons.inventory_2_outlined),
      _StatData('Delivered', '$delivered', Icons.check_circle_outline),
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
      itemBuilder: (context, index) {
        final s = stats[index];
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
            width: 150,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _statusFilter,
              decoration: _input('Status'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(
                  value: 'processing',
                  child: Text('Processing'),
                ),
                DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
            ),
          ),
          SizedBox(
            width: 170,
            child: TextField(
              controller: _customerController,
              onChanged: (_) => setState(() {}),
              decoration: _input('Customer'),
            ),
          ),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _dateFilter,
              decoration: _input('Date Range'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Time')),
                DropdownMenuItem(value: 'today', child: Text('Today')),
                DropdownMenuItem(value: 'week', child: Text('This Week')),
                DropdownMenuItem(value: 'month', child: Text('This Month')),
              ],
              onChanged: (v) => setState(() => _dateFilter = v ?? 'all'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _statusFilter = 'all';
                _dateFilter = 'all';
                _searchController.clear();
                _customerController.clear();
                _activeTab = 'all';
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersPanel(List<_AdminOrder> orders) {
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
              const Text(
                'All Orders',
                style: TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                'Showing ${orders.length} orders',
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tab('all', 'All Orders'),
              _tab('pending', 'Pending'),
              _tab('processing', 'Processing'),
              _tab('shipped', 'Shipped'),
              _tab('delivered', 'Delivered'),
              _tab('cancelled', 'Cancelled'),
            ],
          ),
          const SizedBox(height: 10),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'No orders found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
                ),
              ),
            )
          else
            ...orders.map(_buildOrderCard),
        ],
      ),
    );
  }

  Widget _tab(String id, String label) {
    final isActive = _activeTab == id;
    return InkWell(
      onTap: () => setState(() => _activeTab = id),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? const Color(0x558BB6FF) : const Color(0x220B0F1A),
          ),
          color: isActive ? const Color(0x1F8BB6FF) : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF2E5EA7) : _text,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(_AdminOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x130B0F1A)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          color: _text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.shopName,
                        style: const TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _OrderStatusPill(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x140B0F1A)),
              ),
              child: Column(
                children: [
                  _line('Customer', order.customerName),
                  _line('Phone', order.customerPhone),
                  _line('Address', order.customerAddress),
                  _line('Payment', order.paymentMethod),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...order.items
                .take(2)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 8, color: _muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item.title} • Qty ${item.qty}',
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _peso(item.qty * item.unitPrice),
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (order.items.length > 2)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '+${order.items.length - 2} more item(s)',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Total: ${_peso(order.total)}',
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => _viewOrderDetails(order),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewOrderDetails(_AdminOrder order) {
    final details = StringBuffer()
      ..writeln('Order ID: ${order.id}')
      ..writeln('Shop: ${order.shopName}')
      ..writeln('Customer: ${order.customerName}')
      ..writeln('Phone: ${order.customerPhone}')
      ..writeln('Address: ${order.customerAddress}')
      ..writeln('Status: ${order.status.label}')
      ..writeln('Payment: ${order.paymentMethod}')
      ..writeln('Date: ${_fmt(order.createdAt)}')
      ..writeln('')
      ..writeln('Items:');

    for (final item in order.items) {
      details.writeln(
        '- ${item.title} x${item.qty} (${_peso(item.unitPrice)})',
      );
    }
    details.writeln('');
    details.writeln('Shipping: ${_peso(order.shipping)}');
    details.writeln('Total: ${_peso(order.total)}');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: SingleChildScrollView(child: Text(details.toString())),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<_AdminOrder> _filteredOrders() {
    final search = _searchController.text.trim().toLowerCase();
    final customer = _customerController.text.trim().toLowerCase();
    return _orders.where((o) {
      final searchMatch =
          search.isEmpty ||
          o.id.toLowerCase().contains(search) ||
          o.customerName.toLowerCase().contains(search) ||
          o.items.any((i) => i.title.toLowerCase().contains(search));
      final statusMatch =
          _statusFilter == 'all' || o.status.key == _statusFilter;
      final tabMatch = _activeTab == 'all' || o.status.key == _activeTab;
      final customerMatch =
          customer.isEmpty || o.customerName.toLowerCase().contains(customer);
      final now = DateTime.now();
      final diff = now.difference(o.createdAt).inDays;
      final dateMatch = switch (_dateFilter) {
        'today' => diff == 0,
        'week' => diff <= 7,
        'month' => diff <= 30,
        _ => true,
      };
      return searchMatch &&
          statusMatch &&
          tabMatch &&
          customerMatch &&
          dateMatch;
    }).toList();
  }

  String _fmt(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _peso(double n) => 'PHP ${n.toStringAsFixed(0)}';

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
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
        return;
      case AdminSection.commission:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminCommission);
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

}

class _OrderStatusPill extends StatelessWidget {
  const _OrderStatusPill({required this.status});
  final _OrderStatus status;

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    switch (status) {
      case _OrderStatus.pending:
        bg = const Color(0xFFFFF4D6);
        fg = const Color(0xFF8A5A00);
        break;
      case _OrderStatus.processing:
        bg = const Color(0x1F8BB6FF);
        fg = const Color(0xFF2E5EA7);
        break;
      case _OrderStatus.shipped:
        bg = const Color(0x1F7CF4D1);
        fg = const Color(0xFF0A7A63);
        break;
      case _OrderStatus.delivered:
        bg = const Color(0x1F4ADE80);
        fg = const Color(0xFF117A43);
        break;
      case _OrderStatus.cancelled:
        bg = const Color(0xFFFCE1E1);
        fg = const Color(0xFFB3261E);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 10),
      ),
    );
  }
}

class _StatData {
  const _StatData(this.title, this.value, this.icon);
  final String title;
  final String value;
  final IconData icon;
}

class _AdminOrder {
  _AdminOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    required this.shopName,
    required this.items,
    required this.shipping,
  });

  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  _OrderStatus status;
  final DateTime createdAt;
  final String paymentMethod;
  final String shopName;
  final List<_OrderItem> items;
  final double shipping;

  double get subtotal => items.fold(0, (sum, i) => sum + i.qty * i.unitPrice);
  double get total => subtotal + shipping;
}

class _OrderItem {
  const _OrderItem(this.title, this.qty, this.unitPrice);
  final String title;
  final int qty;
  final double unitPrice;
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

  String get key {
    switch (this) {
      case _OrderStatus.pending:
        return 'pending';
      case _OrderStatus.processing:
        return 'processing';
      case _OrderStatus.shipped:
        return 'shipped';
      case _OrderStatus.delivered:
        return 'delivered';
      case _OrderStatus.cancelled:
        return 'cancelled';
    }
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
