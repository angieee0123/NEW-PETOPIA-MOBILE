import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminProductManagementPage extends StatefulWidget {
  const AdminProductManagementPage({super.key});

  @override
  State<AdminProductManagementPage> createState() =>
      _AdminProductManagementPageState();
}

class _AdminProductManagementPageState
    extends State<AdminProductManagementPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  String _categoryFilter = 'All Categories';
  String _sellerFilter = 'All Sellers';

  final List<_AdminProduct> _products = [
    _AdminProduct(
      id: 'P-1201',
      name: 'Premium Dog Food 5kg',
      category: 'Food & Treats',
      price: 899,
      stock: 24,
      seller: 'Angelica Pet Supplies',
      status: _ProductStatus.active,
      description: 'Nutritious dry food with protein-rich ingredients.',
      colors: ['Brown'],
      sizes: ['5kg'],
      weights: ['5kg'],
    ),
    _AdminProduct(
      id: 'P-1202',
      name: 'Calming Pet Shampoo',
      category: 'Grooming & Hygiene',
      price: 275,
      stock: 9,
      seller: 'FurCare Store',
      status: _ProductStatus.pending,
      description: 'Mild cleansing formula for sensitive skin.',
      colors: ['Blue', 'White'],
      sizes: ['250ml', '500ml'],
      weights: ['0.5kg'],
    ),
    _AdminProduct(
      id: 'P-1203',
      name: 'Cat Scratching Post',
      category: 'Furniture & Decor',
      price: 799,
      stock: 0,
      seller: 'Playful Paws',
      status: _ProductStatus.inactive,
      description: 'Durable scratching post with sisal rope.',
      colors: ['Gray'],
      sizes: ['Large'],
      weights: ['3kg'],
    ),
    _AdminProduct(
      id: 'P-1204',
      name: 'Portable Water Bottle',
      category: 'Travel & Outdoors',
      price: 189,
      stock: 41,
      seller: 'Happy Tails Shop',
      status: _ProductStatus.active,
      description: 'Leak-proof bottle for outdoor walks and trips.',
      colors: ['Pink', 'Green'],
      sizes: ['500ml'],
      weights: ['0.3kg'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts();
    final total = _products.length;
    final active = _products
        .where((p) => p.status == _ProductStatus.active)
        .length;
    final archived = _products
        .where((p) => p.status == _ProductStatus.inactive)
        .length;
    final sellers = _products.map((e) => e.seller).toSet().length;

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
                _buildTopBar(),
                const SizedBox(height: 12),
                _buildStats(
                  total: total,
                  active: active,
                  sellers: sellers,
                  archived: archived,
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 12),
                _buildProductsTable(filtered),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Admin Product Management',
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
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open menu',
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
                      'Product Management',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _text,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Manage all marketplace products',
                      style: TextStyle(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.adminArchivedProducts),
                icon: const Icon(Icons.archive_outlined, size: 18),
                label: const Text('Archived'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
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
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [_accent, _accent2]),
                ),
                child: ElevatedButton.icon(
                  onPressed: _openAddProductSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF051014),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add Product',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats({
    required int total,
    required int active,
    required int sellers,
    required int archived,
  }) {
    final items = [
      _MiniStatData('Total Products', '$total', Icons.inventory_2_outlined),
      _MiniStatData('Active Products', '$active', Icons.check_circle_outline),
      _MiniStatData('Total Sellers', '$sellers', Icons.storefront_outlined),
      _MiniStatData('Archived Products', '$archived', Icons.archive_outlined),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.58,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
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
                child: Icon(item.icon, color: const Color(0xFF2E5EA7)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      item.value,
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
      },
    );
  }

  Widget _buildFilters() {
    final categories = [
      'All Categories',
      ..._products.map((e) => e.category).toSet().toList()..sort(),
    ];
    final sellers = [
      'All Sellers',
      ..._products.map((e) => e.seller).toSet().toList()..sort(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Column(
            children: [
              if (!compact)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _categoryFilter,
                        decoration: _inputDecoration('Category'),
                        items: categories
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(
                          () => _categoryFilter = v ?? 'All Categories',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _sellerFilter,
                        decoration: _inputDecoration('Seller'),
                        items: sellers
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _sellerFilter = v ?? 'All Sellers'),
                      ),
                    ),
                  ],
                )
              else ...[
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _categoryFilter,
                  decoration: _inputDecoration('Category'),
                  items: categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _categoryFilter = v ?? 'All Categories'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _sellerFilter,
                  decoration: _inputDecoration('Seller'),
                  items: sellers
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _sellerFilter = v ?? 'All Sellers'),
                ),
              ],
              const SizedBox(height: 8),
              if (!compact)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration('Min Price'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration('Max Price'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear'),
                    ),
                  ],
                )
              else ...[
                TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDecoration('Min Price'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                  decoration: _inputDecoration('Max Price'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear Filters'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _categoryFilter = 'All Categories';
      _sellerFilter = 'All Sellers';
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  Widget _buildProductsTable(List<_AdminProduct> products) {
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
                'Products',
                style: TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _exportProducts,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Export'),
              ),
              TextButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 26),
              child: Center(
                child: Text(
                  'No products found with current filters.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            )
          else
            ...products.map(_buildProductTile),
        ],
      ),
    );
  }

  Widget _buildProductTile(_AdminProduct p) {
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF2F5FF),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: p.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _meta('Price', 'PHP ${p.price.toStringAsFixed(0)}'),
              _meta('Stock', '${p.stock}'),
              _meta('ID', p.id),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openEditProductSheet(p),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23272F),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _archiveProduct(p),
                  icon: const Icon(Icons.archive_outlined, size: 18),
                  label: const Text('Archive'),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      isDense: true,
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

  List<_AdminProduct> _filteredProducts() {
    final search = _searchController.text.trim().toLowerCase();
    final minPrice = double.tryParse(_minPriceController.text.trim());
    final maxPrice = double.tryParse(_maxPriceController.text.trim());

    return _products.where((p) {
      final searchMatch =
          search.isEmpty ||
          p.name.toLowerCase().contains(search) ||
          p.description.toLowerCase().contains(search) ||
          p.seller.toLowerCase().contains(search);
      final categoryMatch =
          _categoryFilter == 'All Categories' || p.category == _categoryFilter;
      final sellerMatch =
          _sellerFilter == 'All Sellers' || p.seller == _sellerFilter;
      final minMatch = minPrice == null || p.price >= minPrice;
      final maxMatch = maxPrice == null || p.price <= maxPrice;
      return searchMatch &&
          categoryMatch &&
          sellerMatch &&
          minMatch &&
          maxMatch;
    }).toList();
  }

  void _openAddProductSheet() {
    _openProductFormSheet();
  }

  void _openEditProductSheet(_AdminProduct product) {
    _openProductFormSheet(existing: product);
  }

  void _openProductFormSheet({_AdminProduct? existing}) {
    final isEdit = existing != null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    final priceController = TextEditingController(
      text: existing?.price.toStringAsFixed(0) ?? '',
    );
    final stockController = TextEditingController(
      text: existing?.stock.toString() ?? '',
    );

    String selectedCategory = existing?.category ?? 'Food & Treats';
    String selectedSeller =
        existing?.seller ??
        (_products.isNotEmpty ? _products.first.seller : 'Petopia Seller');
    _ProductStatus selectedStatus = existing?.status ?? _ProductStatus.active;

    final colorChips = List<String>.from(existing?.colors ?? <String>[]);
    final sizeChips = List<String>.from(existing?.sizes ?? <String>[]);
    final weightChips = List<String>.from(existing?.weights ?? <String>[]);

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
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            isEdit ? 'Edit Product' : 'Add New Product',
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      TextField(
                        controller: nameController,
                        decoration: _inputDecoration('Product Name'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: _inputDecoration('Category'),
                        items:
                            const [
                                  'Food & Treats',
                                  'Health & Wellness',
                                  'Grooming & Hygiene',
                                  'Toys & Entertainment',
                                  'Bedding & Housing',
                                  'Clothing & Accessories',
                                  'Training & Behavior',
                                  'Travel & Outdoors',
                                  'Feeding Supplies',
                                  'Cleaning & Waste Management',
                                  'Safety & Security',
                                  'Breeding & Habitat Essentials',
                                  'Furniture & Decor',
                                  'Other',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setModalState(
                          () => selectedCategory = v ?? selectedCategory,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration('Price'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: stockController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _inputDecoration('Stock'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: _inputDecoration('Description'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedSeller,
                        decoration: _inputDecoration('Seller'),
                        items: _products
                            .map((e) => e.seller)
                            .toSet()
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setModalState(
                          () => selectedSeller = v ?? selectedSeller,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<_ProductStatus>(
                        initialValue: selectedStatus,
                        decoration: _inputDecoration('Status'),
                        items: _ProductStatus.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.label),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setModalState(
                          () => selectedStatus = v ?? selectedStatus,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _variationEditor(
                        title: 'Colors',
                        values: colorChips,
                        onAdd: () => setModalState(() => colorChips.add('New')),
                        onRemove: (i) =>
                            setModalState(() => colorChips.removeAt(i)),
                        onEdit: (i, value) => colorChips[i] = value,
                      ),
                      _variationEditor(
                        title: 'Sizes',
                        values: sizeChips,
                        onAdd: () => setModalState(() => sizeChips.add('New')),
                        onRemove: (i) =>
                            setModalState(() => sizeChips.removeAt(i)),
                        onEdit: (i, value) => sizeChips[i] = value,
                      ),
                      _variationEditor(
                        title: 'Weights',
                        values: weightChips,
                        onAdd: () =>
                            setModalState(() => weightChips.add('New')),
                        onRemove: (i) =>
                            setModalState(() => weightChips.removeAt(i)),
                        onEdit: (i, value) => weightChips[i] = value,
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
                                final name = nameController.text.trim();
                                final description = descController.text.trim();
                                final price = double.tryParse(
                                  priceController.text.trim(),
                                );
                                final stock = int.tryParse(
                                  stockController.text.trim(),
                                );
                                if (name.isEmpty ||
                                    description.isEmpty ||
                                    price == null ||
                                    stock == null) {
                                  _showInfo('Please fill all required fields.');
                                  return;
                                }

                                setState(() {
                                  if (isEdit) {
                                    existing
                                      ..name = name
                                      ..description = description
                                      ..price = price
                                      ..stock = stock
                                      ..category = selectedCategory
                                      ..seller = selectedSeller
                                      ..status = selectedStatus
                                      ..colors = List<String>.from(colorChips)
                                      ..sizes = List<String>.from(sizeChips)
                                      ..weights = List<String>.from(
                                        weightChips,
                                      );
                                  } else {
                                    _products.insert(
                                      0,
                                      _AdminProduct(
                                        id: 'P-${math.Random().nextInt(9000) + 1000}',
                                        name: name,
                                        category: selectedCategory,
                                        price: price,
                                        stock: stock,
                                        seller: selectedSeller,
                                        status: selectedStatus,
                                        description: description,
                                        colors: List<String>.from(colorChips),
                                        sizes: List<String>.from(sizeChips),
                                        weights: List<String>.from(weightChips),
                                      ),
                                    );
                                  }
                                });

                                Navigator.of(context).pop();
                                _showInfo(
                                  isEdit
                                      ? 'Product updated successfully.'
                                      : 'Product added successfully.',
                                );
                              },
                              child: Text(
                                isEdit ? 'Update Product' : 'Save Product',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _variationEditor({
    required String title,
    required List<String> values,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
    required void Function(int index, String value) onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x130B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: onAdd, child: const Text('+ Add')),
            ],
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (int i = 0; i < values.length; i++)
                _EditableChip(
                  value: values[i],
                  onChanged: (v) => onEdit(i, v),
                  onDelete: () => onRemove(i),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _archiveProduct(_AdminProduct product) {
    setState(() => product.status = _ProductStatus.inactive);
    _showInfo('Product archived.');
  }

  void _exportProducts() {
    _showInfo('Export completed (prototype CSV).');
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
          'Are you sure you want to logout from Admin Dashboard?',
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

  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MiniStatData {
  const _MiniStatData(this.title, this.value, this.icon);
  final String title;
  final String value;
  final IconData icon;
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final _ProductStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    switch (status) {
      case _ProductStatus.active:
        bg = const Color(0xFFD9F7E8);
        fg = const Color(0xFF117A43);
        break;
      case _ProductStatus.inactive:
        bg = const Color(0xFFFCE1E1);
        fg = const Color(0xFFB3261E);
        break;
      case _ProductStatus.pending:
        bg = const Color(0xFFFFF4D6);
        fg = const Color(0xFF8A5A00);
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
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _EditableChip extends StatelessWidget {
  const _EditableChip({
    required this.value,
    required this.onChanged,
    required this.onDelete,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x180B0F1A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          InkWell(
            onTap: onDelete,
            child: const Icon(Icons.close_rounded, size: 16),
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

enum _ProductStatus { active, inactive, pending }

extension on _ProductStatus {
  String get label {
    switch (this) {
      case _ProductStatus.active:
        return 'Active';
      case _ProductStatus.inactive:
        return 'Inactive';
      case _ProductStatus.pending:
        return 'Pending';
    }
  }
}

class _AdminProduct {
  _AdminProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.seller,
    required this.status,
    required this.description,
    required this.colors,
    required this.sizes,
    required this.weights,
  });

  String id;
  String name;
  String category;
  double price;
  int stock;
  String seller;
  _ProductStatus status;
  String description;
  List<String> colors;
  List<String> sizes;
  List<String> weights;
}
