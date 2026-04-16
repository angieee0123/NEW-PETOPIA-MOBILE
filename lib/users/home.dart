import 'package:flutter/material.dart';
import 'account.dart';
import '../app_routes.dart';

void main() {
  runApp(const PetopiaMobileApp());
}

class PetopiaMobileApp extends StatelessWidget {
  const PetopiaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petopia',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BB6FF),
          surface: const Color(0xFFF6F8FF),
        ),
      ),
      initialRoute: AppRoutes.shell,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

class PetopiaShellPage extends StatefulWidget {
  const PetopiaShellPage({super.key});

  @override
  State<PetopiaShellPage> createState() => _PetopiaShellPageState();
}

class _PetopiaShellPageState extends State<PetopiaShellPage> {
  int _currentIndex = 0;

  static const _accent2 = Color(0xFF8BB6FF);
  static const _muted = Color(0xFF5B6378);

  final List<Widget> _pages = const [
    PetopiaHomePage(),
    _PlaceholderPage(
      icon: Icons.grid_view_rounded,
      title: 'Categories',
      subtitle: 'Browse pet categories and collections.',
    ),
    _PlaceholderPage(
      icon: Icons.shopping_cart_outlined,
      title: 'Cart',
      subtitle: 'Your selected products will appear here.',
    ),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
        selectedItemColor: _accent2,
        unselectedItemColor: _muted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Account'),
        ],
      ),
    );
  }
}

class PetopiaHomePage extends StatelessWidget {
  const PetopiaHomePage({super.key});

  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _cardRadius = 16.0;

  static const List<_ProductItem> _flashProducts = [
    _ProductItem(
      title: 'Premium Dog Food 5kg',
      price: '₱899',
      oldPrice: '₱1,250',
      rating: '4.8',
      discount: '-28%',
      desc: 'High-protein dry food for active dogs with complete vitamins.',
      shop: 'Petopia Official',
    ),
    _ProductItem(
      title: 'Cat Litter Lavender',
      price: '₱339',
      oldPrice: '₱499',
      rating: '4.7',
      discount: '-32%',
      desc: 'Dust-free clumping litter with lavender scent and odor control.',
      shop: 'PawSmart Supplies',
    ),
    _ProductItem(
      title: 'Pet Grooming Kit',
      price: '₱749',
      oldPrice: '₱980',
      rating: '4.9',
      discount: '-24%',
      desc: 'Complete grooming kit with brush, trimmer, and nail clipper.',
      shop: 'FurCare Store',
    ),
  ];

  static const List<_ProductItem> _recommendedProducts = [
    _ProductItem(
      title: 'Cooling Pet Bed',
      price: '₱599',
      oldPrice: '₱799',
      rating: '4.7',
      discount: '-25%',
      desc: 'Breathable cooling bed for pets during warm weather.',
      shop: 'SleepyPaws',
    ),
    _ProductItem(
      title: 'Automatic Feeder',
      price: '₱1,999',
      oldPrice: '₱2,450',
      rating: '4.9',
      discount: '-18%',
      desc: 'Scheduled feeder with timer and portion control.',
      shop: 'PetTech Hub',
    ),
    _ProductItem(
      title: 'Travel Pet Carrier',
      price: '₱1,150',
      oldPrice: '₱1,430',
      rating: '4.6',
      discount: '-20%',
      desc: 'Airline-friendly carrier with breathable side mesh.',
      shop: 'Happy Trails Pet',
    ),
  ];

  static const List<_StoreItem> _stores = [
    _StoreItem(
      name: 'Petopia Official',
      tagline: 'Top pet essentials and exclusive bundles',
    ),
    _StoreItem(
      name: 'PawSmart Supplies',
      tagline: 'Trusted pet nutrition and hygiene picks',
    ),
    _StoreItem(
      name: 'PetTech Hub',
      tagline: 'Smart gadgets and feeder devices',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _buildTopBar(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildHeroCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, left: 16),
              child: _buildCategoryChips(),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Flash Sale',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 228,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: _flashProducts
                    .map(
                      (product) => _ProductCard(
                        title: product.title,
                        price: product.price,
                        oldPrice: product.oldPrice,
                        rating: product.rating,
                        discount: product.discount,
                        onTap: () => _showProductModal(context, product),
                        onAddToCart: () => _showLoginPrompt(context, 'add to cart'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: _buildVouchers(),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Recommended for You',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 216,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: _recommendedProducts
                    .map(
                      (product) => _ProductCard(
                        title: product.title,
                        price: product.price,
                        oldPrice: product.oldPrice,
                        rating: product.rating,
                        discount: product.discount,
                        onTap: () => _showProductModal(context, product),
                        onAddToCart: () => _showLoginPrompt(context, 'add to cart'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Official Stores',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _stores.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  final store = _stores[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showStoreModal(context, store),
                    child: Container(
                      width: 210,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xECFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x120B0F1A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: _accent2.withValues(alpha: .20),
                                child: const Icon(
                                  Icons.storefront_outlined,
                                  size: 16,
                                  color: _accent2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  store.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            store.tagline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [_accent, _accent2]),
              ),
              child: const Icon(Icons.pets_rounded, color: Color(0xFF051014)),
            ),
            const SizedBox(width: 10),
            const Text(
              'Petopia',
              style: TextStyle(
                color: _text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            _IconCircle(
              icon: Icons.notifications_none_rounded,
              onTap: () => _showLoginPrompt(context, 'access notifications'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x100B0F1A)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products, brands and categories',
                    hintStyle: TextStyle(color: _muted, fontSize: 13),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search_rounded, color: _muted),
                    contentPadding: EdgeInsets.only(top: 13, right: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(colors: [_accent, _accent2]),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune_rounded, color: Color(0xFF051014)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEFFFFFFF),
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: const [BoxShadow(color: Color(0x14101828), blurRadius: 24)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pet Essentials Mega Sale',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Up to 70% off on food, grooming, and accessories for your pets.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: [_accent, _accent2]),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Shop Pet Essentials',
                      style: TextStyle(
                        color: Color(0xFF051014),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  _accent2.withValues(alpha: .20),
                  _accent.withValues(alpha: .25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.pets,
              size: 44,
              color: Color(0xFF2E5EA7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = <Map<String, dynamic>>[
      {'label': 'Food & Treats', 'icon': Icons.set_meal},
      {'label': 'Health', 'icon': Icons.health_and_safety_outlined},
      {'label': 'Grooming', 'icon': Icons.content_cut_rounded},
      {'label': 'Toys', 'icon': Icons.sports_baseball_rounded},
      {'label': 'Travel', 'icon': Icons.luggage_rounded},
      {'label': 'Accessories', 'icon': Icons.checkroom_rounded},
    ];

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final c = categories[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xF2FFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Row(
              children: [
                Icon(c['icon'] as IconData, size: 18, color: _accent2),
                const SizedBox(width: 8),
                Text(
                  c['label'] as String,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVouchers() {
    final vouchers = [
      '₱100 off ₱1,000+ • CODE: SAVE100',
      'Free Shipping • Orders ₱799+',
      '5% Coins Back • Max ₱50',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vouchers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text),
        ),
        const SizedBox(height: 10),
        ...vouchers.map(
          (voucher) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xECFFFFFF),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, color: _accent2, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    voucher,
                    style: const TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showLoginPrompt(BuildContext context, String actionText) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: Text('You need to be logged in first to $actionText.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AccountPage(),
                ),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _showProductModal(BuildContext context, _ProductItem product) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: Color(0xFFF6F8FF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: _accent2.withValues(alpha: .20),
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 16,
                        color: _accent2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.shop,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC8F8E9), Color(0xFFD4E3FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.pets_rounded, size: 56, color: Color(0xFF2E5EA7)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.desc,
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.oldPrice,
                      style: const TextStyle(
                        color: _muted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      product.rating,
                      style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showLoginPrompt(context, 'add to cart'),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showLoginPrompt(context, 'buy now'),
                        child: const Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showStoreModal(BuildContext context, _StoreItem store) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(store.name),
        content: Text(store.tagline),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showInfo(context, 'Store page integration is coming soon.');
            },
            child: const Text('Visit Store'),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PetopiaHomePage._text,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
    required this.onTap,
    required this.onAddToCart,
  });

  final String title;
  final String price;
  final String oldPrice;
  final String rating;
  final String discount;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xF4FFFFFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x120B0F1A)),
          boxShadow: const [BoxShadow(color: Color(0x10101828), blurRadius: 14)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC8F8E9), Color(0xFFD4E3FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.pets_rounded, size: 36, color: Color(0xFF2E5EA7)),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFF8BB6FF),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF051014),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PetopiaHomePage._text,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              price,
              style: const TextStyle(
                color: PetopiaHomePage._text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              oldPrice,
              style: const TextStyle(
                color: PetopiaHomePage._muted,
                fontSize: 11,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 16),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: const TextStyle(
                    color: PetopiaHomePage._muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkResponse(
                  onTap: onAddToCart,
                  radius: 22,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0x108BB6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x148BB6FF)),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 16,
                      color: Color(0xFF2E5EA7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0x100B0F1A)),
        ),
        child: Icon(icon, color: PetopiaHomePage._text, size: 20),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 54, color: const Color(0xFF8BB6FF)),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B0F1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF5B6378),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductItem {
  const _ProductItem({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
    required this.desc,
    required this.shop,
  });

  final String title;
  final String price;
  final String oldPrice;
  final String rating;
  final String discount;
  final String desc;
  final String shop;
}

class _StoreItem {
  const _StoreItem({
    required this.name,
    required this.tagline,
  });

  final String name;
  final String tagline;
}
