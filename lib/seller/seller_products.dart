import 'package:flutter/material.dart';
import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({super.key});

  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();
  final int _currentIndex = 1;

  final List<_Product> _products = [
    const _Product(
      name: 'Premium Dog Food 5kg',
      category: 'Food & Treats',
      stock: 24,
      sales: 72,
      price: '₱ 899',
      badgeColor: Color(0xFFFFE6C5),
    ),
    const _Product(
      name: 'Automatic Feeder',
      category: 'Feeding Supplies',
      stock: 9,
      sales: 41,
      price: '₱ 1,999',
      badgeColor: Color(0xFFDDEAFF),
    ),
    const _Product(
      name: 'Pet Grooming Kit',
      category: 'Grooming & Hygiene',
      stock: 18,
      sales: 35,
      price: '₱ 749',
      badgeColor: Color(0xFFE4FFE8),
    ),
    const _Product(
      name: 'Orthopedic Pet Bed',
      category: 'Bedding & Housing',
      stock: 11,
      sales: 28,
      price: '₱ 1,350',
      badgeColor: Color(0xFFF2E4FF),
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
                _buildFilters(context),
                const SizedBox(height: 14),
                _buildProductsPanel(filtered),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Seller Products',
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

  List<_Product> get _filteredProducts {
    final search = _searchController.text.trim().toLowerCase();
    if (search.isEmpty) {
      return _products;
    }
    return _products.where((p) {
      return p.name.toLowerCase().contains(search) ||
          p.category.toLowerCase().contains(search);
    }).toList();
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
                  'My Products',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Manage your shop inventory from mobile',
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
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.sellerArchivedProducts),
            icon: const Icon(Icons.archive_outlined),
            tooltip: 'Archived products',
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          TextField(
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openAddProductSheet,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: const Color(0xFF051014),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddProductSheet() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String category = 'Food & Treats';

    final result = await showModalBottomSheet<_Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets;
        final maxHeight = MediaQuery.of(context).size.height * 0.88;

        InputDecoration inputDecoration({
          required String label,
          String? hint,
          IconData? prefixIcon,
        }) {
          return InputDecoration(
            labelText: label,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0x120B0F1A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0x120B0F1A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xB38BB6FF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 16 + viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: maxHeight),
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
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [_accent, _accent2],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add_business_rounded,
                                      color: Color(0xFF051014),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add Product',
                                          style: TextStyle(
                                            color: _text,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Create a new listing for your shop',
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Flexible(
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  0,
                                  14,
                                  14,
                                ),
                                children: [
                                  TextField(
                                    controller: nameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration(
                                      label: 'Product name',
                                      hint: 'e.g., Premium Dog Food 5kg',
                                      prefixIcon: Icons.inventory_2_outlined,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    initialValue: category,
                                    decoration: inputDecoration(
                                      label: 'Category',
                                      prefixIcon: Icons.category_outlined,
                                    ),
                                    items:
                                        const [
                                          'Food & Treats',
                                          'Feeding Supplies',
                                          'Grooming & Hygiene',
                                          'Bedding & Housing',
                                          'Accessories',
                                        ].map((c) {
                                          return DropdownMenuItem(
                                            value: c,
                                            child: Text(c),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setSheetState(() => category = value);
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: priceController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          decoration: inputDecoration(
                                            label: 'Price',
                                            hint: '₱ 0',
                                            prefixIcon: Icons.payments_outlined,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: stockController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: false,
                                              ),
                                          decoration: inputDecoration(
                                            label: 'Stock',
                                            hint: '0',
                                            prefixIcon: Icons.numbers_outlined,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            side: const BorderSide(
                                              color: Color(0x220B0F1A),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final name = nameController.text
                                                .trim();
                                            final priceText = priceController
                                                .text
                                                .trim();
                                            final stockText = stockController
                                                .text
                                                .trim();
                                            if (name.isEmpty ||
                                                priceText.isEmpty ||
                                                stockText.isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please fill in name, price, and stock.',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final stock =
                                                int.tryParse(stockText) ?? 0;
                                            final priceValue =
                                                double.tryParse(priceText) ?? 0;
                                            final product = _Product(
                                              name: name,
                                              category: category,
                                              stock: stock,
                                              sales: 0,
                                              price:
                                                  '₱ ${priceValue.toStringAsFixed(0)}',
                                              badgeColor: _categoryColor(
                                                category,
                                              ),
                                            );
                                            Navigator.of(context).pop(product);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _accent,
                                            foregroundColor: const Color(
                                              0xFF051014,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    stockController.dispose();

    if (result != null) {
      setState(() {
        _products.insert(0, result);
      });
    }
  }

  Future<void> _openEditProductSheet(int productIndex, _Product product) async {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: product.price.replaceAll('₱', '').trim(),
    );
    final stockController = TextEditingController(
      text: product.stock.toString(),
    );
    String category = product.category;

    final result = await showModalBottomSheet<_Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets;
        final maxHeight = MediaQuery.of(context).size.height * 0.88;

        InputDecoration inputDecoration({
          required String label,
          String? hint,
          IconData? prefixIcon,
        }) {
          return InputDecoration(
            labelText: label,
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0x120B0F1A)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0x120B0F1A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xB38BB6FF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 16 + viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: maxHeight),
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
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [_accent, _accent2],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      color: Color(0xFF051014),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Edit Product',
                                          style: TextStyle(
                                            color: _text,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Update details, pricing, and stock',
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Flexible(
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  0,
                                  14,
                                  14,
                                ),
                                children: [
                                  TextField(
                                    controller: nameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration(
                                      label: 'Product name',
                                      hint: 'e.g., Premium Dog Food 5kg',
                                      prefixIcon: Icons.inventory_2_outlined,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    initialValue: category,
                                    decoration: inputDecoration(
                                      label: 'Category',
                                      prefixIcon: Icons.category_outlined,
                                    ),
                                    items:
                                        const [
                                          'Food & Treats',
                                          'Feeding Supplies',
                                          'Grooming & Hygiene',
                                          'Bedding & Housing',
                                          'Accessories',
                                        ].map((c) {
                                          return DropdownMenuItem(
                                            value: c,
                                            child: Text(c),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setSheetState(() => category = value);
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: priceController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          decoration: inputDecoration(
                                            label: 'Price',
                                            hint: '₱ 0',
                                            prefixIcon: Icons.payments_outlined,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: stockController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: false,
                                              ),
                                          decoration: inputDecoration(
                                            label: 'Stock',
                                            hint: '0',
                                            prefixIcon: Icons.numbers_outlined,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            side: const BorderSide(
                                              color: Color(0x220B0F1A),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final name = nameController.text
                                                .trim();
                                            final priceText = priceController
                                                .text
                                                .trim();
                                            final stockText = stockController
                                                .text
                                                .trim();
                                            if (name.isEmpty ||
                                                priceText.isEmpty ||
                                                stockText.isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please fill in name, price, and stock.',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final stock =
                                                int.tryParse(stockText) ?? 0;
                                            final priceValue =
                                                double.tryParse(priceText) ?? 0;
                                            final updated = _Product(
                                              name: name,
                                              category: category,
                                              stock: stock,
                                              sales: product.sales,
                                              price:
                                                  '₱ ${priceValue.toStringAsFixed(0)}',
                                              badgeColor: _categoryColor(
                                                category,
                                              ),
                                            );
                                            Navigator.of(context).pop(updated);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _accent,
                                            foregroundColor: const Color(
                                              0xFF051014,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: const Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    stockController.dispose();

    if (result != null && mounted) {
      setState(() {
        _products[productIndex] = result;
      });
    }
  }

  static Color _categoryColor(String category) {
    switch (category) {
      case 'Food & Treats':
        return const Color(0xFFFFE6C5);
      case 'Feeding Supplies':
        return const Color(0xFFDDEAFF);
      case 'Grooming & Hygiene':
        return const Color(0xFFE4FFE8);
      case 'Bedding & Housing':
        return const Color(0xFFF2E4FF);
      default:
        return const Color(0xFFE5E8F0);
    }
  }

  Widget _buildProductsPanel(List<_Product> products) {
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
            'My Products',
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
                  'No products found. Add your first product to get started.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...products.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ProductRow(
                index: entry.key + 1,
                product: entry.value,
                onEdit: () => _openEditProductSheet(entry.key, entry.value),
                onArchive: () => _info(
                  context,
                  'Archive Product will move this to Archived products.',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _info(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.index,
    required this.product,
    required this.onEdit,
    required this.onArchive,
  });

  final int index;
  final _Product product;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

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
                Row(
                  children: [
                    _chip('Stock: ${product.stock}', const Color(0xFF8BB6FF)),
                    const SizedBox(width: 6),
                    _chip('Sold: ${product.sales}', const Color(0xFFFFB86B)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.price,
                style: const TextStyle(
                  color: Color(0xFF0B0F1A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: onArchive,
                    icon: const Icon(Icons.archive_outlined, size: 20),
                    tooltip: 'Archive',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _Product {
  const _Product({
    required this.name,
    required this.category,
    required this.stock,
    required this.sales,
    required this.price,
    required this.badgeColor,
  });

  final String name;
  final String category;
  final int stock;
  final int sales;
  final String price;
  final Color badgeColor;
}

class _AuroraBackground extends StatelessWidget {
  const _AuroraBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
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
          left: 30,
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
