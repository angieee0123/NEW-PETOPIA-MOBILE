import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminArchivedProductsPage extends StatefulWidget {
  const AdminArchivedProductsPage({super.key});

  @override
  State<AdminArchivedProductsPage> createState() =>
      _AdminArchivedProductsPageState();
}

class _AdminArchivedProductsPageState extends State<AdminArchivedProductsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  String _categoryFilter = 'All Categories';
  String _sellerFilter = 'All Sellers';
  String _dateFilter = 'All Time';

  final List<_ArchivedProduct> _archivedProducts = [
    _ArchivedProduct(
      id: 'AP-2201',
      name: 'Cat Litter 10L',
      category: 'Cleaning & Waste Management',
      price: 289,
      stock: 4,
      seller: 'Pet Essentials Hub',
      archivedAt: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Low-dust clumping litter for odor control.',
    ),
    _ArchivedProduct(
      id: 'AP-2202',
      name: 'Old Series Dog Harness',
      category: 'Clothing & Accessories',
      price: 199,
      stock: 2,
      seller: 'Happy Tails Shop',
      archivedAt: DateTime.now().subtract(const Duration(days: 6)),
      description: 'Discontinued harness variant from last season.',
    ),
    _ArchivedProduct(
      id: 'AP-2203',
      name: 'Bird Seed Mix 1kg',
      category: 'Food & Treats',
      price: 145,
      stock: 8,
      seller: 'Angelica Pet Supplies',
      archivedAt: DateTime.now().subtract(const Duration(days: 25)),
      description: 'Legacy packaging item replaced by updated SKU.',
    ),
  ];

  int _restoredCount = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts();
    final month = DateTime.now().month;
    final year = DateTime.now().year;
    final thisMonth = _archivedProducts
        .where((p) => p.archivedAt.month == month && p.archivedAt.year == year)
        .length;
    final recent = _archivedProducts
        .where((p) => DateTime.now().difference(p.archivedAt).inDays <= 7)
        .length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.products,
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
                _buildTopBar(context),
                const SizedBox(height: 12),
                _buildStats(
                  total: _archivedProducts.length,
                  restored: _restoredCount,
                  monthCount: thisMonth,
                  recent: recent,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildTable(filtered),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Admin Archived Products',
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

  Widget _buildTopBar(BuildContext context) {
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
                  Icons.archive_outlined,
                  color: Color(0xFF051014),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Archived Products',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Review and manage archived product listings',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoutes.adminProductManagement),
                child: const Text('Back to Products'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search archived products...',
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
    required int restored,
    required int monthCount,
    required int recent,
  }) {
    final stats = [
      _StatData('Archived Total', '$total', Icons.archive_outlined),
      _StatData('Restored', '$restored', Icons.undo_rounded),
      _StatData('This Month', '$monthCount', Icons.calendar_month_outlined),
      _StatData('Recent (7 Days)', '$recent', Icons.schedule_rounded),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
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
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(10),
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
    final categories = [
      'All Categories',
      ..._archivedProducts.map((e) => e.category).toSet().toList()..sort(),
    ];
    final sellers = [
      'All Sellers',
      ..._archivedProducts.map((e) => e.seller).toSet().toList()..sort(),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Wrap(
        runSpacing: 8,
        spacing: 8,
        children: [
          SizedBox(
            width: 190,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _categoryFilter,
              decoration: _input('Category'),
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _categoryFilter = v ?? 'All Categories'),
            ),
          ),
          SizedBox(
            width: 170,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _sellerFilter,
              decoration: _input('Seller'),
              items: sellers
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _sellerFilter = v ?? 'All Sellers'),
            ),
          ),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _dateFilter,
              decoration: _input('Date'),
              items: const [
                'All Time',
                'Last 7 Days',
                'Last 30 Days',
                'This Month',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _dateFilter = v ?? 'All Time'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _categoryFilter = 'All Categories';
                _sellerFilter = 'All Sellers';
                _dateFilter = 'All Time';
                _searchController.clear();
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<_ArchivedProduct> products) {
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
            'Archived Products',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No archived products found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            )
          else
            ...products.map((p) => _buildArchivedTile(p)),
        ],
      ),
    );
  }

  Widget _buildArchivedTile(_ArchivedProduct p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF2E5EA7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p.category} • ${p.seller}',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE1E1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'ARCHIVED',
                  style: TextStyle(
                    color: Color(0xFFB3261E),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _meta('Price', 'PHP ${p.price.toStringAsFixed(0)}'),
              _meta('Stock', '${p.stock}'),
              _meta('Archived', _fmtDate(p.archivedAt)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _restoreProduct(p),
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: const Text('Restore'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

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

  List<_ArchivedProduct> _filteredProducts() {
    final search = _searchController.text.trim().toLowerCase();
    return _archivedProducts.where((p) {
      final searchMatch =
          search.isEmpty ||
          p.name.toLowerCase().contains(search) ||
          p.description.toLowerCase().contains(search) ||
          p.seller.toLowerCase().contains(search);
      final categoryMatch =
          _categoryFilter == 'All Categories' || p.category == _categoryFilter;
      final sellerMatch =
          _sellerFilter == 'All Sellers' || p.seller == _sellerFilter;
      final diff = DateTime.now().difference(p.archivedAt).inDays;
      final dateMatch = switch (_dateFilter) {
        'Last 7 Days' => diff <= 7,
        'Last 30 Days' => diff <= 30,
        'This Month' =>
          p.archivedAt.month == DateTime.now().month &&
              p.archivedAt.year == DateTime.now().year,
        _ => true,
      };
      return searchMatch && categoryMatch && sellerMatch && dateMatch;
    }).toList();
  }

  void _restoreProduct(_ArchivedProduct p) {
    setState(() {
      _archivedProducts.remove(p);
      _restoredCount++;
    });
    _info('${p.name} restored successfully.');
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

  String _fmtDate(DateTime value) {
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  void _info(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ArchivedProduct {
  _ArchivedProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.seller,
    required this.archivedAt,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String seller;
  final DateTime archivedAt;
  final String description;
}

class _StatData {
  const _StatData(this.title, this.value, this.icon);
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
