import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerShopPublicViewPage extends StatelessWidget {
  const SellerShopPublicViewPage({super.key});

  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    final products = _demoProducts;
    final totalSales = products.fold<int>(0, (sum, p) => sum + p.sold);
    final averageRating =
        products.fold<double>(0, (sum, p) => sum + p.rating) / products.length;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildBanner(
                  totalProducts: products.length,
                  totalSales: totalSales,
                  rating: averageRating,
                ),
                const SizedBox(height: 12),
                _buildInfoSection(context),
                const SizedBox(height: 12),
                _buildProductsSection(products),
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
      bottomNavigationBar: SellerBottomNav(
        currentIndex: 3,
        onTap: (value) {
          if (value == 3) {
            return;
          }
          if (value == 1) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerOrders);
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

  Widget _buildHeader(BuildContext context) {
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
              Icons.storefront_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Shop (Public View)',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'How customers see your storefront',
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
            onPressed: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.sellerProfile);
            },
            icon: const Icon(Icons.person_outline_rounded, size: 18),
            label: const Text('Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner({
    required int totalProducts,
    required int totalSales,
    required double rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_accent, _accent2]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A8BB6FF),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              size: 42,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Angelica Pet Supplies',
            style: TextStyle(
              color: Color(0xFF051014),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your trusted source for quality pet supplies and accessories.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF23272F),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stat('Products', '$totalProducts'),
              const SizedBox(width: 18),
              _stat('Sales', '$totalSales'),
              const SizedBox(width: 18),
              _stat('Rating', rating.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF051014),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF23272F),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width >= 760 ? (width - 16 * 2 - 10) / 2 : width - 16 * 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            'Shop Information',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _InfoCard(
              width: cardWidth,
              icon: Icons.contact_page_outlined,
              title: 'Contact Details',
              lines: [
                'angelicapetsupplies@gmail.com',
                '0917 123 4567',
                'Quezon City, NCR',
              ],
              icons: [
                Icons.email_outlined,
                Icons.phone_outlined,
                Icons.location_on_outlined,
              ],
            ),
            _InfoCard(
              width: cardWidth,
              icon: Icons.schedule_rounded,
              title: 'Business Hours',
              lines: [
                'Monday - Friday: 9:00 AM - 6:00 PM',
                'Saturday: 10:00 AM - 4:00 PM',
                'Sunday: Closed',
              ],
              icons: [
                Icons.schedule_rounded,
                Icons.schedule_rounded,
                Icons.schedule_rounded,
              ],
            ),
            _InfoCard(
              width: cardWidth,
              icon: Icons.local_shipping_outlined,
              title: 'Shipping & Returns',
              lines: [
                'Free shipping on orders over PHP 500',
                '7-day return policy',
                '100% authentic products',
              ],
              icons: [
                Icons.local_shipping_outlined,
                Icons.keyboard_return_outlined,
                Icons.verified_user_outlined,
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductsSection(List<_PublicProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            'Our Products',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.74,
          ),
          itemBuilder: (context, index) {
            final p = products[index];
            return GestureDetector(
              onTap: () => _openProductModal(context, p),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xECFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x120B0F1A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF2F5FF),
                      ),
                      child: Center(
                        child: Icon(
                          p.icon,
                          color: const Color(0xFF2E5EA7),
                          size: 42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rating ${p.rating.toStringAsFixed(1)} • ${p.sold} sold',
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'PHP ${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openProductModal(context, p),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23272F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openProductModal(BuildContext context, _PublicProduct product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        int quantity = 1;
        return StatefulBuilder(
          builder: (context, setModalState) {
            final subtotal = product.price * quantity;
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  12,
                  12,
                  12,
                  MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x120B0F1A)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26101828),
                        blurRadius: 28,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF2F5FF),
                            ),
                            child: Icon(
                              product.icon,
                              color: const Color(0xFF2E5EA7),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                color: _text,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PHP ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: _text,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rating ${product.rating.toStringAsFixed(1)} • ${product.sold} sold',
                        style: const TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0x140B0F1A)),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                color: _text,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: () {
                                if (quantity <= 1) {
                                  return;
                                }
                                setModalState(() => quantity--);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  color: _text,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: () => setModalState(() => quantity++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              color: _muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'PHP ${subtotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '$quantity x ${product.name} added to cart.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Add to Cart'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF23272F),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Checkout flow can be connected next.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Checkout'),
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

  static const _demoProducts = <_PublicProduct>[
    _PublicProduct(
      name: 'Premium Dog Food 5kg',
      price: 899,
      sold: 72,
      rating: 4.8,
      icon: Icons.set_meal_rounded,
    ),
    _PublicProduct(
      name: 'Automatic Feeder',
      price: 1999,
      sold: 41,
      rating: 4.7,
      icon: Icons.settings_remote_outlined,
    ),
    _PublicProduct(
      name: 'Cat Litter 10L',
      price: 289,
      sold: 63,
      rating: 4.6,
      icon: Icons.cleaning_services_outlined,
    ),
    _PublicProduct(
      name: 'Pet Bed Large',
      price: 599,
      sold: 58,
      rating: 4.5,
      icon: Icons.bedroom_baby_outlined,
    ),
  ];
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.lines,
    required this.icons,
  });

  final double width;
  final IconData icon;
  final String title;
  final List<String> lines;
  final List<IconData> icons;

  static const _text = Color(0xFF0B0F1A);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xECFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F5FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF2E5EA7)),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x140B0F1A)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < lines.length; i++) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          icons[i],
                          size: 16,
                          color: const Color(0xFF2E5EA7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lines[i],
                            style: const TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (i != lines.length - 1) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x220B0F1A)),
          color: Colors.white,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF23272F)),
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

class _PublicProduct {
  const _PublicProduct({
    required this.name,
    required this.price,
    required this.sold,
    required this.rating,
    required this.icon,
  });

  final String name;
  final double price;
  final int sold;
  final double rating;
  final IconData icon;
}
