import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'rider_bottom_nav.dart';

class RiderDashboardPage extends StatefulWidget {
  const RiderDashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<RiderDashboardPage> createState() => _RiderDashboardPageState();
}

class _RiderDashboardPageState extends State<RiderDashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _RiderOverviewPage(),
      const _RiderDeliveriesPage(),
      const _RiderEarningsPage(),
      const _RiderProfilePage(),
    ];

    return Scaffold(
      body: Stack(children: [const _AuroraBackground(), pages[_currentIndex]]),
      bottomNavigationBar: RiderBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderDeliveries);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderEarnings);
            return;
          }
          if (value == 3) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.riderProfile);
            return;
          }
          setState(() => _currentIndex = value);
        },
      ),
    );
  }
}

class _RiderOverviewPage extends StatelessWidget {
  const _RiderOverviewPage();

  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  static const List<_RiderStat> _stats = [
    _RiderStat(
      label: 'Total Deliveries',
      value: '124',
      icon: Icons.local_shipping_outlined,
    ),
    _RiderStat(
      label: 'Pending',
      value: '5',
      icon: Icons.hourglass_bottom_rounded,
    ),
    _RiderStat(
      label: 'Completed',
      value: '119',
      icon: Icons.check_circle_outline_rounded,
    ),
    _RiderStat(
      label: 'Total Earnings',
      value: 'PHP 18,350',
      icon: Icons.payments_outlined,
    ),
  ];

  static const List<_DeliveryItem> _activeDeliveries = [
    _DeliveryItem(
      orderId: '#2026-3101',
      customer: 'Cynthia Ramos',
      pickup: 'Petopia Official (QC)',
      dropoff: 'Brgy. Bagong Pag-asa, Quezon City',
      status: 'To Ship',
      etaLabel: 'Today',
    ),
    _DeliveryItem(
      orderId: '#2026-3105',
      customer: 'Mark Villanueva',
      pickup: 'PawSmart Supplies',
      dropoff: 'Makati City, NCR',
      status: 'In Transit',
      etaLabel: 'Today',
    ),
    _DeliveryItem(
      orderId: '#2026-3110',
      customer: 'Alyssa Reyes',
      pickup: 'FurCare Store',
      dropoff: 'Pasig City, NCR',
      status: 'To Ship',
      etaLabel: 'Today',
    ),
  ];

  static const List<_EarningPoint> _earningsTrend = [
    _EarningPoint(label: 'Mon', value: 0.32),
    _EarningPoint(label: 'Tue', value: 0.44),
    _EarningPoint(label: 'Wed', value: 0.38),
    _EarningPoint(label: 'Thu', value: 0.70),
    _EarningPoint(label: 'Fri', value: 0.52),
    _EarningPoint(label: 'Sat', value: 0.86),
    _EarningPoint(label: 'Sun', value: 0.62),
  ];

  static const List<_HistoryItem> _recentHistory = [
    _HistoryItem(
      orderId: '#2026-3090',
      customer: 'J. Cruz',
      status: 'Completed',
      date: 'Apr 15',
    ),
    _HistoryItem(
      orderId: '#2026-3088',
      customer: 'M. Santos',
      status: 'Completed',
      date: 'Apr 15',
    ),
    _HistoryItem(
      orderId: '#2026-3082',
      customer: 'A. Reyes',
      status: 'Cancelled',
      date: 'Apr 14',
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
                  const SizedBox(height: 18),
                  _buildStatsGrid(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Active Deliveries',
              actionLabel: 'View All',
              onPressed: () => _showInfo(
                context,
                'Deliveries page is available in bottom navigation.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _activeDeliveries
                    .map(
                      (delivery) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DeliveryCard(
                          item: delivery,
                          onTap: () => _showDeliverySheet(context, delivery),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Earnings Trend',
              actionLabel: '7 Days',
              onPressed: () => _showInfo(
                context,
                'Range switching can be linked to rider earnings API.',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _EarningsTrendCard(points: _earningsTrend),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: 'Recent History',
              actionLabel: 'History',
              onPressed: () =>
                  _showInfo(context, 'History page can be connected next.'),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _HistoryCard(items: _recentHistory),
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
          child: const Icon(
            Icons.two_wheeler_rounded,
            color: Color(0xFF051014),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rider Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Overview of your deliveries',
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
              _showInfo(context, 'Rider notifications can be connected next.'),
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
        subtitle: 'Support • Delivery issues, payouts, and account help',
        icon: Icons.support_agent_rounded,
        badge: '1',
        isCustomerService: true,
      ),
      const _MessageThread(
        title: 'Petopia Dispatch',
        subtitle: 'Ops • “New delivery assigned. Confirm pickup.”',
        icon: Icons.local_shipping_outlined,
        badge: '2',
      ),
      const _MessageThread(
        title: 'Petopia Official Store',
        subtitle: 'Store • “Thanks for completing the delivery!”',
        icon: Icons.storefront_outlined,
      ),
      const _MessageThread(
        title: 'Buyer: Maria Santos',
        subtitle: 'Customer • “I’m at the gate, please call me.”',
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
                                  AppRoutes.riderCustomerService,
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
                    'Today',
                    style: TextStyle(
                      color: Color(0xFF2E5EA7),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome back, Rider.',
                  style: TextStyle(
                    color: _text,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Accept new deliveries, track in-transit orders, and keep your rider web and mobile tools in sync.',
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
                      'Accept-delivery flow can be connected next.',
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
                      'Find Deliveries',
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
                Icon(Icons.route_rounded, size: 38, color: Color(0xFF2E5EA7)),
                SizedBox(height: 10),
                Text(
                  'Routes',
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
        title: 'My Deliveries',
        icon: Icons.local_shipping_outlined,
        onTap: () => _showInfo(
          context,
          'Deliveries view can be synced with rider dashboard API.',
        ),
      ),
      _QuickAction(
        title: 'Earnings',
        icon: Icons.payments_outlined,
        onTap: () => _showInfo(
          context,
          'Earnings view is available in bottom navigation.',
        ),
      ),
      _QuickAction(
        title: 'Messages',
        icon: Icons.chat_bubble_outline_rounded,
        onTap: () =>
            _showInfo(context, 'Rider messages panel can be connected next.'),
      ),
      _QuickAction(
        title: 'Support',
        icon: Icons.support_agent_outlined,
        onTap: () => _showInfo(context, 'Support contacts can be shown here.'),
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
              width: 106,
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

  Future<void> _showDeliverySheet(
    BuildContext context,
    _DeliveryItem item,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(
        title: '${item.orderId} — ${item.customer}',
        subtitle: item.status,
        description:
            'Pickup: ${item.pickup}\nDeliver to: ${item.dropoff}\nETA: ${item.etaLabel}\n\nHook this to `/rider/dashboard/data` and delivery status update endpoints to keep web + mobile synced.',
        icon: Icons.local_shipping_rounded,
        background: const Color(0xFFDDE8FF),
        primaryLabel: 'Update Status',
        secondaryLabel: 'Open Map',
        onPrimaryTap: () {
          Navigator.of(context).pop();
          _showInfo(context, 'Status update actions can be connected next.');
        },
        onSecondaryTap: () {
          Navigator.of(context).pop();
          _showInfo(
            context,
            'Map routing can be connected (Google Maps / Waze).',
          );
        },
      ),
    );
  }
}

class _RiderDeliveriesPage extends StatelessWidget {
  const _RiderDeliveriesPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          const _SimpleHeader(
            title: 'My Deliveries',
            subtitle: 'View active deliveries and update order status.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xECFFFFFF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 56,
                  color: Color(0xFF8BB6FF),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Deliveries module ready',
                  style: TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect this screen to your rider deliveries endpoints so assignments, tracking, and status updates are shared between web and mobile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5B6378),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Delivery assignment API integration can be added next.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Refresh Deliveries'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiderEarningsPage extends StatelessWidget {
  const _RiderEarningsPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: const [
          _SimpleHeader(
            title: 'Earnings',
            subtitle: 'Track payouts and daily earnings trend.',
          ),
          SizedBox(height: 16),
          _EarningsSummaryCard(),
        ],
      ),
    );
  }
}

class _RiderProfilePage extends StatelessWidget {
  const _RiderProfilePage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          const _SimpleHeader(
            title: 'Rider Profile',
            subtitle: 'Manage rider info, contact details, and account access.',
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
                    Icons.two_wheeler_rounded,
                    size: 36,
                    color: Color(0xFF2E5EA7),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Active Rider',
                  style: TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Profile settings and rider details',
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

class _EarningsTrendCard extends StatelessWidget {
  const _EarningsTrendCard({required this.points});

  final List<_EarningPoint> points;

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
            'Daily earnings (sample)',
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

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.items});

  final List<_HistoryItem> items;

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
            'Latest completed/cancelled',
            style: TextStyle(
              color: Color(0xFF0B0F1A),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.orderId,
                          style: const TextStyle(
                            color: Color(0xFF0B0F1A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          h.customer,
                          style: const TextStyle(
                            color: Color(0xFF5B6378),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    h.date,
                    style: const TextStyle(
                      color: Color(0xFF5B6378),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusPill(status: h.status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color background = const Color(0x147CF4D1);
    Color textColor = const Color(0xFF0B8C73);
    if (status == 'Cancelled') {
      background = const Color(0x14FF6B6B);
      textColor = const Color(0xFFB42318);
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

class _EarningsSummaryCard extends StatelessWidget {
  const _EarningsSummaryCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Today', 'PHP 420'),
      ('This week', 'PHP 2,950'),
      ('This month', 'PHP 8,120'),
      ('Total', 'PHP 18,350'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Earnings summary',
            style: TextStyle(
              color: Color(0xFF0B0F1A),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.$1,
                      style: const TextStyle(
                        color: Color(0xFF0B0F1A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    r.$2,
                    style: const TextStyle(
                      color: Color(0xFF0B0F1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Connect this to `/rider/dashboard/data` and `/rider/earnings` endpoints for real totals.',
            style: TextStyle(
              color: Color(0xFF5B6378),
              fontWeight: FontWeight.w600,
              height: 1.35,
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

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.item, required this.onTap});

  final _DeliveryItem item;
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
                    '${item.orderId} • ${item.customer}',
                    style: const TextStyle(
                      color: Color(0xFF0B0F1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _DeliveryStatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0x148BB6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF2E5EA7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup: ${item.pickup}',
                        style: const TextStyle(
                          color: Color(0xFF0B0F1A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dropoff: ${item.dropoff}',
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
                  item.etaLabel,
                  style: const TextStyle(
                    color: Color(0xFF5B6378),
                    fontWeight: FontWeight.w700,
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

class _DeliveryStatusBadge extends StatelessWidget {
  const _DeliveryStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color background = const Color(0x14FFB86B);
    Color textColor = const Color(0xFFCC7A00);

    if (status == 'In Transit') {
      background = const Color(0x148BB6FF);
      textColor = const Color(0xFF2E5EA7);
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

class _RiderStat {
  const _RiderStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
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

class _DeliveryItem {
  const _DeliveryItem({
    required this.orderId,
    required this.customer,
    required this.pickup,
    required this.dropoff,
    required this.status,
    required this.etaLabel,
  });

  final String orderId;
  final String customer;
  final String pickup;
  final String dropoff;
  final String status;
  final String etaLabel;
}

class _EarningPoint {
  const _EarningPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class _HistoryItem {
  const _HistoryItem({
    required this.orderId,
    required this.customer,
    required this.status,
    required this.date,
  });

  final String orderId;
  final String customer;
  final String status;
  final String date;
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
