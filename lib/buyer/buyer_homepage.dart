import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'buyer_bottom_nav.dart';

class BuyerDashboardPage extends StatefulWidget {
  const BuyerDashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BuyerDashboardPage> createState() => _BuyerDashboardPageState();
}

class _BuyerDashboardPageState extends State<BuyerDashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _BuyerOverviewPage(),
      const _BuyerProfilePage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          if (_currentIndex == 0) pages[0] else pages[1],
        ],
      ),
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerOrders);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerCart);
            return;
          }
          setState(() => _currentIndex = value);
        },
      ),
    );
  }
}

class _BuyerOverviewPage extends StatelessWidget {
  const _BuyerOverviewPage();

  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  static const List<_ProductItem> _flashSale = [
    _ProductItem(
      title: 'Whiskas Tuna Dry Food',
      price: 'PHP 315',
      oldPrice: 'PHP 399',
      rating: '4.8',
      discount: '-21%',
      desc:
          'Crunchy cat food formula packed with flavor and balanced nutrition.',
      shop: 'Petopia Official',
      icon: Icons.pets_rounded,
      color: Color(0xFFFFF0CC),
    ),
    _ProductItem(
      title: 'Portable Water Bottle',
      price: 'PHP 189',
      oldPrice: 'PHP 249',
      rating: '4.7',
      discount: '-24%',
      desc: 'Travel-ready hydration bottle for walks, trips, and outdoor play.',
      shop: 'Happy Tails Shop',
      icon: Icons.water_drop_outlined,
      color: Color(0xFFDDF3FF),
    ),
    _ProductItem(
      title: 'Vitamin Chews for Dogs',
      price: 'PHP 420',
      oldPrice: 'PHP 560',
      rating: '4.9',
      discount: '-25%',
      desc: 'Daily supplement chews to help support immunity and coat health.',
      shop: 'PawSmart Supplies',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFFE3FCEB),
    ),
  ];

  static const List<_ProductItem> _recommended = [
    _ProductItem(
      title: 'Interactive Cat Toy Ball',
      price: 'PHP 259',
      oldPrice: 'PHP 320',
      rating: '4.6',
      discount: '-19%',
      desc: 'Keeps indoor cats active with light motion and playful sounds.',
      shop: 'Playful Paws',
      icon: Icons.sports_baseball_rounded,
      color: Color(0xFFF6E2FF),
    ),
    _ProductItem(
      title: 'Premium Puppy Training Pads',
      price: 'PHP 349',
      oldPrice: 'PHP 435',
      rating: '4.8',
      discount: '-20%',
      desc: 'Leak-lock layers with odor control for easy indoor training.',
      shop: 'Petopia Official',
      icon: Icons.cleaning_services_outlined,
      color: Color(0xFFE4F7FF),
    ),
    _ProductItem(
      title: 'Foldable Travel Carrier',
      price: 'PHP 1,120',
      oldPrice: 'PHP 1,380',
      rating: '4.7',
      discount: '-19%',
      desc: 'Breathable travel carrier built for comfort and easy storage.',
      shop: 'Happy Trails',
      icon: Icons.luggage_rounded,
      color: Color(0xFFFFEDD8),
    ),
    _ProductItem(
      title: 'Calming Pet Shampoo',
      price: 'PHP 275',
      oldPrice: 'PHP 350',
      rating: '4.9',
      discount: '-21%',
      desc: 'Gentle shampoo for sensitive skin with a clean herbal scent.',
      shop: 'FurCare Store',
      icon: Icons.spa_outlined,
      color: Color(0xFFE5FFE9),
    ),
    _ProductItem(
      title: 'Stainless Pet Bowl Set',
      price: 'PHP 199',
      oldPrice: 'PHP 259',
      rating: '4.7',
      discount: '-23%',
      desc: 'Non-slip stainless bowls for food and water, easy to clean.',
      shop: 'Petopia Official',
      icon: Icons.ramen_dining_rounded,
      color: Color(0xFFDDEAFF),
    ),
    _ProductItem(
      title: 'Dog Leash Reflective 1.5m',
      price: 'PHP 229',
      oldPrice: 'PHP 299',
      rating: '4.8',
      discount: '-23%',
      desc: 'Durable reflective leash for safer night walks.',
      shop: 'Happy Tails Shop',
      icon: Icons.linear_scale_rounded,
      color: Color(0xFFFFEDD8),
    ),
    _ProductItem(
      title: 'Soft Pet Blanket',
      price: 'PHP 189',
      oldPrice: 'PHP 240',
      rating: '4.6',
      discount: '-21%',
      desc: 'Cozy fleece blanket for beds, carriers, and couches.',
      shop: 'SleepyPaws',
      icon: Icons.bedroom_baby_outlined,
      color: Color(0xFFF6E2FF),
    ),
    _ProductItem(
      title: 'Dental Chews (Small Dogs)',
      price: 'PHP 299',
      oldPrice: 'PHP 380',
      rating: '4.9',
      discount: '-21%',
      desc: 'Daily dental chews to help reduce plaque and freshen breath.',
      shop: 'PawSmart Supplies',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFFE3FCEB),
    ),
    _ProductItem(
      title: 'Cat Scratching Post',
      price: 'PHP 799',
      oldPrice: 'PHP 990',
      rating: '4.8',
      discount: '-19%',
      desc: 'Sturdy scratching post to keep claws healthy and furniture safe.',
      shop: 'Playful Paws',
      icon: Icons.pets_outlined,
      color: Color(0xFFE4F7FF),
    ),
    _ProductItem(
      title: 'Portable Grooming Brush',
      price: 'PHP 149',
      oldPrice: 'PHP 199',
      rating: '4.7',
      discount: '-25%',
      desc: 'Compact slicker brush for quick detangling on the go.',
      shop: 'FurCare Store',
      icon: Icons.brush_outlined,
      color: Color(0xFFE5FFE9),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Column(
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 16),
                  _buildHeroCard(context),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Flash Sale',
              actionLabel: 'See Deals',
              onPressed: () => _showInfo(
                context,
                'Flash sale filters can be connected next.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 228,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _flashSale.length,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = _flashSale[index];
                  return _ProductCard(
                    product: product,
                    onTap: () => _showProductSheet(context, product),
                    onAction: () => _showInfo(
                      context,
                      '${product.title} added to prototype cart.',
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
              child: _buildVoucherStrip(context),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Recommended for You',
              actionLabel: 'Browse',
              onPressed: () => _showInfo(
                context,
                'Recommendations can be personalized with buyer data.',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = _recommended[index];
                return _RecommendedCard(
                  product: product,
                  onTap: () => _showProductSheet(context, product),
                );
              }, childCount: _recommended.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
            ),
          ),
        ],
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
          child: const Icon(Icons.pets_rounded, color: Color(0xFF051014)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buyer Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Track orders and discover pet essentials',
                style: TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _IconButtonCard(
          icon: Icons.notifications_none_rounded,
          onTap: () => _showInfo(
            context,
            'Notifications panel can be connected to buyer alerts.',
          ),
        ),
        const SizedBox(width: 8),
        _IconButtonCard(
          icon: Icons.shopping_cart_outlined,
          badge: '3',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.buyerCart),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xEFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x14FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 32,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _accent2.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Overview',
                    style: TextStyle(
                      color: Color(0xFF2E5EA7),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome back, Angelica.',
                  style: TextStyle(
                    color: _text,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage purchases, monitor deliveries, and explore fresh deals for your pets in one mobile dashboard.',
                  style: TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_accent, _accent2]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _showInfo(
                      context,
                      'Search and order flow can be connected next.',
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: const Color(0xFF051014),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 92,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _accent.withValues(alpha: .30),
                  _accent2.withValues(alpha: .28),
                ],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.storefront_rounded,
                  size: 38,
                  color: Color(0xFF2E5EA7),
                ),
                SizedBox(height: 10),
                Text(
                  'Petopia',
                  style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = <_QuickAction>[
      _QuickAction(
        title: 'My Orders',
        icon: Icons.receipt_long_outlined,
        onTap: () => _showInfo(
          context,
          'Orders tracking is ready for backend integration.',
        ),
      ),
      _QuickAction(
        title: 'Wishlist',
        icon: Icons.favorite_border_rounded,
        onTap: () =>
            _showInfo(context, 'Wishlist can be connected to saved products.'),
      ),
      _QuickAction(
        title: 'Addresses',
        icon: Icons.location_on_outlined,
        onTap: () => _showInfo(
          context,
          'Address manager can be linked to buyer profile data.',
        ),
      ),
      _QuickAction(
        title: 'Support',
        icon: Icons.headset_mic_outlined,
        onTap: () =>
            _showInfo(context, 'Support chat entry point can be added here.'),
      ),
    ];

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final action = actions[index];
          return InkWell(
            onTap: action.onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xECFFFFFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: _accent2),
                  const SizedBox(height: 10),
                  Text(
                    action.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoucherStrip(BuildContext context) {
    final vouchers = [
      'Free shipping on orders above PHP 999',
      'Save PHP 100 with code PET100',
      'Weekend cashback up to PHP 50',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: .20),
            _accent2.withValues(alpha: .18),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Vouchers',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...vouchers.map(
            (voucher) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 18,
                      color: Color(0xFF2E5EA7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      voucher,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => _showInfo(
              context,
              'Voucher claiming can be linked to your backend later.',
            ),
            child: const Text('Claim vouchers'),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showProductSheet(
    BuildContext context,
    _ProductItem product,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(
        title: product.title,
        subtitle: product.shop,
        description: product.desc,
        leadingIcon: product.icon,
        background: product.color,
        primaryLabel: 'Buy Now',
        secondaryLabel: 'Add to Cart',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.price,
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w800,
                fontSize: 18,
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
          ],
        ),
        onPrimaryTap: () {
          Navigator.of(context).pop();
          _showInfo(
            context,
            'Checkout flow can be connected to the web backend.',
          );
        },
        onSecondaryTap: () {
          Navigator.of(context).pop();
          _showInfo(context, '${product.title} added to cart.');
        },
      ),
    );
  }

  // Recent Orders moved to its own page via bottom navigation.
}

class _BuyerProfilePage extends StatelessWidget {
  const _BuyerProfilePage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          const _SimplePageHeader(
            title: 'Buyer Profile',
            subtitle:
                'Manage account details, saved addresses, and preferences.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xECFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(
                    0xFF8BB6FF,
                  ).withValues(alpha: .18),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: Color(0xFF2E5EA7),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Angelica D. Cuevas',
                  style: TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Active Member',
                  style: TextStyle(
                    color: Color(0xFF5B6378),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text('Open account page'),
                  subtitle: const Text('Reuse the existing login/profile flow'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.shell, arguments: {'tab': 3});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimplePageHeader extends StatelessWidget {
  const _SimplePageHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0B0F1A),
            fontSize: 28,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF5B6378),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0B0F1A),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: onPressed, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAction,
  });

  final _ProductItem product;
  final VoidCallback onTap;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 176,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xF4FFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x120B0F1A)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10101828),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 84,
                  decoration: BoxDecoration(
                    color: product.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      product.icon,
                      size: 38,
                      color: const Color(0xFF2E5EA7),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _StatusPill(
                    label: product.discount,
                    background: const Color(0xFF8BB6FF),
                    textColor: const Color(0xFF051014),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontWeight: FontWeight.w800,
                fontSize: 13,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.price,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              product.oldPrice,
              style: const TextStyle(
                color: Color(0xFF5B6378),
                fontSize: 11,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Color(0xFFFFC857),
                ),
                const SizedBox(width: 4),
                Text(
                  product.rating,
                  style: const TextStyle(
                    color: Color(0xFF5B6378),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkResponse(
                  onTap: onAction,
                  radius: 22,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0x148BB6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 17,
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

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.product, required this.onTap});

  final _ProductItem product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xF4FFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 92,
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  product.icon,
                  size: 40,
                  color: const Color(0xFF2E5EA7),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontWeight: FontWeight.w800,
                height: 1.18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.shop,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF5B6378),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.price,
                    style: const TextStyle(
                      color: Color(0xFF0B0F1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8BB6FF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    this.background = const Color(0x148BB6FF),
    this.textColor = const Color(0xFF2E5EA7),
  });

  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _IconButtonCard extends StatelessWidget {
  const _IconButtonCard({required this.icon, required this.onTap, this.badge});

  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Icon(icon, color: const Color(0xFF0B0F1A), size: 20),
          ),
          if (badge != null)
            Positioned(
              right: -3,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.leadingIcon,
    required this.background,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.trailing,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData leadingIcon;
  final Color background;
  final String primaryLabel;
  final String secondaryLabel;
  final Widget trailing;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x330B0F1A),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  leadingIcon,
                  size: 56,
                  color: const Color(0xFF2E5EA7),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF5B6378),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontSize: 22,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF5B6378),
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            trailing,
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryTap,
                    child: Text(secondaryLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7CF4D1), Color(0xFF8BB6FF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed: onPrimaryTap,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: const Color(0xFF051014),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        primaryLabel,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
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

class _ProductItem {
  const _ProductItem({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.discount,
    required this.desc,
    required this.shop,
    required this.icon,
    required this.color,
  });

  final String title;
  final String price;
  final String oldPrice;
  final String rating;
  final String discount;
  final String desc;
  final String shop;
  final IconData icon;
  final Color color;
}

class _QuickAction {
  const _QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}
