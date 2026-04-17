import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerArchivedProductsPage extends StatefulWidget {
  const SellerArchivedProductsPage({super.key});

  @override
  State<SellerArchivedProductsPage> createState() =>
      _SellerArchivedProductsPageState();
}

class _SellerArchivedProductsPageState
    extends State<SellerArchivedProductsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();
  final int _currentIndex = 1;

  final List<_ArchivedProduct> _products = [
    const _ArchivedProduct(
      id: 'p-arch-001',
      name: 'Cat Litter Lavender (10L)',
      category: 'Accessories',
      stock: 0,
      sales: 19,
      badgeColor: Color(0xFFDDEAFF),
    ),
    const _ArchivedProduct(
      id: 'p-arch-002',
      name: 'Puppy Training Pads (50pcs)',
      category: 'Accessories',
      stock: 0,
      sales: 33,
      badgeColor: Color(0xFFFFE6C5),
    ),
    const _ArchivedProduct(
      id: 'p-arch-003',
      name: 'Detangling Pet Shampoo',
      category: 'Grooming & Hygiene',
      stock: 0,
      sales: 12,
      badgeColor: Color(0xFFE4FFE8),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

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
                _buildSearch(),
                const SizedBox(height: 14),
                _buildPanel(filtered),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Archived Products',
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
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 0) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerDashboard);
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

  List<_ArchivedProduct> get _filteredProducts {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      return _products;
    }
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q),
        )
        .toList();
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
            child: const Icon(Icons.archive_outlined, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Archived Products',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Products you archived',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerProducts),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
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
    );
  }

  Widget _buildPanel(List<_ArchivedProduct> products) {
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
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Center(
                child: Text(
                  'No archived products found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...products.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ArchivedProductRow(
                index: entry.key + 1,
                product: entry.value,
                onRestore: () => _restore(entry.value.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _restore(String id) {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx < 0) {
      return;
    }
    final restored = _products.removeAt(idx);
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Restored "${restored.name}".')));
  }
}

class _ArchivedProductRow extends StatelessWidget {
  const _ArchivedProductRow({
    required this.index,
    required this.product,
    required this.onRestore,
  });

  final int index;
  final _ArchivedProduct product;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFE5E8F0),
            child: Text(
              index.toString(),
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: product.badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pets_rounded, color: Color(0xFF2E5EA7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: Color(0xFF5B6378),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _chip('Stock: ${product.stock}', const Color(0xFF8BB6FF)),
                    _chip('Sold: ${product.sales}', const Color(0xFFFFB86B)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onRestore,
            icon: const Icon(Icons.rotate_left_rounded, size: 18),
            label: const Text('Restore'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CF4D1),
              foregroundColor: const Color(0xFF051014),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .30)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0B0F1A),
        ),
      ),
    );
  }
}

class _ArchivedProduct {
  const _ArchivedProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.sales,
    required this.badgeColor,
  });

  final String id;
  final String name;
  final String category;
  final int stock;
  final int sales;
  final Color badgeColor;
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
          left: 40,
          bottom: -140,
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
