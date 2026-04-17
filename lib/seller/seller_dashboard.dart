import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (_currentIndex == 1 || _currentIndex < 0 || _currentIndex > 3) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _SellerOverviewPage(),
      const _SellerOrdersPage(),
      const _SellerShopPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const _AuroraBackground(),
          if (_currentIndex == 0)
            pages[0]
          else if (_currentIndex == 2)
            pages[1]
          else
            pages[2],
        ],
      ),
      bottomNavigationBar: SellerBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushNamed(AppRoutes.sellerOrders);
            return;
          }
          setState(() => _currentIndex = value);
        },
      ),
    );
  }
}

class _SellerOverviewPage extends StatelessWidget {
  const _SellerOverviewPage();

  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  static const List<_SellerStat> _stats = [
    _SellerStat(
      label: 'Total Sales',
      value: 'PHP 48,520',
      icon: Icons.payments_outlined,
    ),
    _SellerStat(
      label: 'Total Orders',
      value: '126',
      icon: Icons.shopping_cart_checkout_outlined,
    ),
    _SellerStat(
      label: 'Active Products',
      value: '38',
      icon: Icons.inventory_2_outlined,
    ),
    _SellerStat(
      label: 'Net Earnings',
      value: 'PHP 41,930',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  static const List<_SellerProduct> _topProducts = [
    _SellerProduct(
      title: 'Premium Dog Food 5kg',
      subtitle: '72 sold this month',
      price: 'PHP 899',
      stock: '24 in stock',
      icon: Icons.set_meal_rounded,
      color: Color(0xFFFFE6C5),
    ),
    _SellerProduct(
      title: 'Automatic Feeder',
      subtitle: '41 sold this month',
      price: 'PHP 1,999',
      stock: '9 in stock',
      icon: Icons.settings_remote_outlined,
      color: Color(0xFFDDEAFF),
    ),
    _SellerProduct(
      title: 'Pet Grooming Kit',
      subtitle: '35 sold this month',
      price: 'PHP 749',
      stock: '18 in stock',
      icon: Icons.content_cut_rounded,
      color: Color(0xFFE4FFE8),
    ),
    _SellerProduct(
      title: 'Orthopedic Pet Bed',
      subtitle: '28 sold this month',
      price: 'PHP 1,350',
      stock: '11 in stock',
      icon: Icons.bed_outlined,
      color: Color(0xFFF2E4FF),
    ),
  ];

  static const List<_SellerOrder> _recentOrders = [
    _SellerOrder(
      id: '#ORD-2026-101',
      customer: 'Maria Santos',
      amount: 'PHP 1,245',
      status: 'Pending',
      product: 'Royal Canin Mini Adult',
    ),
    _SellerOrder(
      id: '#ORD-2026-102',
      customer: 'John Cruz',
      amount: 'PHP 749',
      status: 'Processing',
      product: 'Pet Grooming Kit',
    ),
    _SellerOrder(
      id: '#ORD-2026-103',
      customer: 'Alyssa Reyes',
      amount: 'PHP 1,999',
      status: 'Shipped',
      product: 'Automatic Feeder',
    ),
  ];

  static const List<_SalesPoint> _salesTrend = [
    _SalesPoint(label: 'Mon', value: 0.42),
    _SalesPoint(label: 'Tue', value: 0.56),
    _SalesPoint(label: 'Wed', value: 0.48),
    _SalesPoint(label: 'Thu', value: 0.78),
    _SalesPoint(label: 'Fri', value: 0.66),
    _SalesPoint(label: 'Sat', value: 0.92),
    _SalesPoint(label: 'Sun', value: 0.74),
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
                  const SizedBox(height: 18),
                  _buildStatsGrid(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Top Products',
              actionLabel: 'Manage',
              onPressed: () =>
                  _showInfo(context, 'Product manager can be connected next.'),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _topProducts.length,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = _topProducts[index];
                  return _TopProductCard(
                    product: product,
                    onTap: () => _showProductSheet(context, product),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Recent Orders',
              actionLabel: 'View All',
              onPressed: () => _showInfo(
                context,
                'Orders list can be synced with seller orders API.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _recentOrders
                    .map(
                      (order) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _OrderSummaryCard(
                          order: order,
                          onTap: () => _showOrderSheet(context, order),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Sales Trend',
              actionLabel: '7 Days',
              onPressed: () => _showInfo(
                context,
                'Range switching can be linked to analytics data.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SalesTrendCard(points: _salesTrend),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: _CommissionCard(
                onManageShop: () => _showInfo(
                  context,
                  'Shop details and theme settings can be integrated here.',
                ),
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
          child: const Icon(Icons.storefront_rounded, color: Color(0xFF051014)),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seller Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Manage your shop and track growth',
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
          icon: Icons.notifications_none_rounded,
          onTap: () =>
              _showInfo(context, 'Seller notifications can be connected next.'),
        ),
        const SizedBox(width: 8),
        _TopIconButton(
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => _openMessagesModal(context),
        ),
      ],
    );
  }

  Future<void> _openMessagesModal(BuildContext context) async {
    final parentContext = context;
    final threads = <_MessageThread>[
      const _MessageThread(
        title: 'Petopia Customer Service',
        subtitle: 'Support • Help center, disputes, and payouts',
        icon: Icons.support_agent_rounded,
        badge: '1',
        isCustomerService: true,
      ),
      const _MessageThread(
        title: 'Angelica Cuevas',
        subtitle: 'Customer • “Is this item available today?”',
        icon: Icons.person_outline_rounded,
        badge: '2',
      ),
      const _MessageThread(
        title: 'Juan Dela Cruz',
        subtitle: 'Customer • “Can I change the delivery address?”',
        icon: Icons.person_outline_rounded,
      ),
      const _MessageThread(
        title: 'Maria Santos',
        subtitle: 'Customer • “Do you have different sizes?”',
        icon: Icons.person_outline_rounded,
      ),
    ];

    final searchController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final q = searchController.text.trim().toLowerCase();
            final filtered = q.isEmpty
                ? threads
                : threads
                      .where(
                        (t) =>
                            t.title.toLowerCase().contains(q) ||
                            t.subtitle.toLowerCase().contains(q),
                      )
                      .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
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
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF051014),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    color: _text,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Chat with customers and support',
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
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => setSheetState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search messages...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0x120B0F1A),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0x120B0F1A),
                            ),
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        itemCount: filtered.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final t = filtered[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).pop();
                              if (t.isCustomerService) {
                                Navigator.of(parentContext).pushNamed(
                                  AppRoutes.sellerCustomerService,
                                );
                                return;
                              }
                              _showInfo(
                                parentContext,
                                'Open chat with "${t.title}" (prototype).',
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0x120B0F1A),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: _accent2.withValues(
                                      alpha: .16,
                                    ),
                                    child: Icon(
                                      t.icon,
                                      color: const Color(0xFF2E5EA7),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                t.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: _text,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            if (t.badge != null)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF8BB6FF,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999,
                                                      ),
                                                ),
                                                child: Text(
                                                  t.badge!,
                                                  style: const TextStyle(
                                                    color: Color(0xFF051014),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          t.subtitle,
                                          maxLines: 2,
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
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFF8BB6FF),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    searchController.dispose();
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
                    'Shop Overview',
                    style: TextStyle(
                      color: Color(0xFF2E5EA7),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome back, Petopia Seller.',
                  style: TextStyle(
                    color: _text,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Review orders, monitor top-selling products, and keep your mobile and web seller tools aligned.',
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
                      'Add product flow can be connected next.',
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
                      'Add New Product',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 96,
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
                  Icons.bar_chart_rounded,
                  size: 38,
                  color: Color(0xFF2E5EA7),
                ),
                SizedBox(height: 10),
                Text(
                  'Growth',
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
        title: 'My Products',
        icon: Icons.inventory_2_outlined,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerProducts),
      ),
      _QuickAction(
        title: 'Orders',
        icon: Icons.receipt_long_outlined,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerOrders),
      ),
      _QuickAction(
        title: 'Earnings',
        icon: Icons.savings_outlined,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerEarnings),
      ),
      _QuickAction(
        title: 'Promotions',
        icon: Icons.campaign_outlined,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerPromotions),
      ),
      _QuickAction(
        title: 'Reports',
        icon: Icons.pie_chart_outline_rounded,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.sellerReports),
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
              width: 102,
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

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final stat = _stats[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xECFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x120B0F1A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _accent2.withValues(alpha: .16),
                child: Icon(stat.icon, color: _accent2, size: 20),
              ),
              Text(
                stat.value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                stat.label,
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showProductSheet(
    BuildContext context,
    _SellerProduct product,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(
        title: product.title,
        subtitle: product.subtitle,
        description:
            'Current price: ${product.price}\nInventory: ${product.stock}\n\nThis section can connect to the seller products module from the web app so edits stay synced on mobile.',
        icon: product.icon,
        background: product.color,
        primaryLabel: 'Edit Product',
        secondaryLabel: 'View Stats',
        onPrimaryTap: () {
          Navigator.of(context).pop();
          _showInfo(context, 'Product editor can be connected next.');
        },
        onSecondaryTap: () {
          Navigator.of(context).pop();
          _showInfo(context, 'Product analytics can be displayed here.');
        },
      ),
    );
  }

  Future<void> _showOrderSheet(BuildContext context, _SellerOrder order) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(
        title: order.id,
        subtitle: '${order.customer} • ${order.status}',
        description:
            'Product: ${order.product}\nAmount: ${order.amount}\n\nTrack order progress, confirm status changes, and sync buyer updates with the seller order backend.',
        icon: Icons.receipt_long_rounded,
        background: const Color(0xFFDDE8FF),
        primaryLabel: 'Update Status',
        secondaryLabel: 'Message Buyer',
        onPrimaryTap: () {
          Navigator.of(context).pop();
          _showInfo(
            context,
            'Order status actions can be connected to seller orders.',
          );
        },
        onSecondaryTap: () {
          Navigator.of(context).pop();
          _showInfo(context, 'Buyer messaging entry point can be added here.');
        },
      ),
    );
  }
}

class _MessageThread {
  const _MessageThread({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badge,
    this.isCustomerService = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? badge;
  final bool isCustomerService;
}

class _SellerOrdersPage extends StatelessWidget {
  const _SellerOrdersPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: const [
          _SimpleHeader(
            title: 'Seller Orders',
            subtitle: 'Review pending, processing, and shipped orders.',
          ),
          SizedBox(height: 16),
          _OrdersStatusCard(),
        ],
      ),
    );
  }
}

class _SellerShopPage extends StatelessWidget {
  const _SellerShopPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          const _SimpleHeader(
            title: 'Shop Settings',
            subtitle: 'Update brand identity, contact details, and policies.',
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
                    Icons.storefront_rounded,
                    size: 36,
                    color: Color(0xFF2E5EA7),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Petopia Official',
                  style: TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Theme, hours, contact, and shipping settings',
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

class _TopProductCard extends StatelessWidget {
  const _TopProductCard({required this.product, required this.onTap});

  final _SellerProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 182,
        padding: const EdgeInsets.all(12),
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
            Container(
              height: 92,
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
            const SizedBox(height: 10),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.subtitle,
              style: const TextStyle(
                color: Color(0xFF5B6378),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              product.price,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.stock,
              style: const TextStyle(
                color: Color(0xFF2E5EA7),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order, required this.onTap});

  final _SellerOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xECFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(
                      color: Color(0xFF0B0F1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0x148BB6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                        order.customer,
                        style: const TextStyle(
                          color: Color(0xFF0B0F1A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.product,
                        style: const TextStyle(
                          color: Color(0xFF5B6378),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  order.amount,
                  style: const TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontWeight: FontWeight.w800,
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

class _SalesTrendCard extends StatelessWidget {
  const _SalesTrendCard({required this.points});

  final List<_SalesPoint> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly sales performance',
            style: TextStyle(
              color: Color(0xFF0B0F1A),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points
                  .map(
                    (point) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 130 * point.value,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF7CF4D1),
                                        Color(0xFF8BB6FF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              point.label,
                              style: const TextStyle(
                                color: Color(0xFF5B6378),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionCard extends StatelessWidget {
  const _CommissionCard({required this.onManageShop});

  final VoidCallback onManageShop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x207CF4D1), Color(0x1E8BB6FF)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Commission Breakdown',
            style: TextStyle(
              color: Color(0xFF0B0F1A),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const _BreakdownRow(label: 'Gross Revenue', value: 'PHP 48,520'),
          const _BreakdownRow(label: 'Admin Commission', value: 'PHP 6,590'),
          const _BreakdownRow(
            label: 'Seller Net Earnings',
            value: 'PHP 41,930',
          ),
          const SizedBox(height: 16),
          const Text(
            'Use this section to bring in the same commission and earnings totals from the seller web dashboard.',
            style: TextStyle(
              color: Color(0xFF5B6378),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onManageShop,
            child: const Text('Manage shop profile and policies'),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0B0F1A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0B0F1A),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersStatusCard extends StatelessWidget {
  const _OrdersStatusCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Pending confirmation', '12 orders'),
      ('Preparing for shipment', '8 orders'),
      ('Out for delivery', '4 orders'),
      ('Completed this week', '23 orders'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8BB6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.$1,
                        style: const TextStyle(
                          color: Color(0xFF0B0F1A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        color: Color(0xFF5B6378),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader({required this.title, required this.subtitle});

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

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Icon(icon, color: const Color(0xFF0B0F1A), size: 20),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color background = const Color(0x14FFB86B);
    Color textColor = const Color(0xFFCC7A00);

    if (status == 'Processing') {
      background = const Color(0x148BB6FF);
      textColor = const Color(0xFF2E5EA7);
    } else if (status == 'Shipped') {
      background = const Color(0x147CF4D1);
      textColor = const Color(0xFF0B8C73);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.background,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color background;
  final String primaryLabel;
  final String secondaryLabel;
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
                child: Icon(icon, size: 56, color: const Color(0xFF2E5EA7)),
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

class _SellerStat {
  const _SellerStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _SellerProduct {
  const _SellerProduct({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.stock,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String price;
  final String stock;
  final IconData icon;
  final Color color;
}

class _SellerOrder {
  const _SellerOrder({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.product,
  });

  final String id;
  final String customer;
  final String amount;
  final String status;
  final String product;
}

class _SalesPoint {
  const _SalesPoint({required this.label, required this.value});

  final String label;
  final double value;
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
