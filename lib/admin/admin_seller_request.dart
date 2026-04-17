import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminSellerRequestPage extends StatefulWidget {
  const AdminSellerRequestPage({super.key});

  @override
  State<AdminSellerRequestPage> createState() => _AdminSellerRequestPageState();
}

class _AdminSellerRequestPageState extends State<AdminSellerRequestPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  final List<_SellerApplication> _applications = [
    _SellerApplication(
      id: 'S-1001',
      fullName: 'Jerome Villanueva',
      email: 'jerome@yahoo.com',
      phone: '09987654321',
      dob: '1998-01-23',
      gender: 'Male',
      address: 'Cebu City, Cebu',
      shopName: 'PawSmart Supplies',
      businessType: 'Sole Proprietor',
      category: 'Food & Treats',
      products: 'Dog kibble, cat treats, supplements, hygiene kits',
      businessAddress: 'Mabolo, Cebu City',
      yearsInOperation: '3',
      businessPhone: '09987654321',
      payoutMethod: 'E-Wallet',
      gcashNumber: '09171234567',
      requestedAt: '2026-04-02',
      status: _RequestStatus.pending,
    ),
    _SellerApplication(
      id: 'S-1002',
      fullName: 'Angela Dela Cruz',
      email: 'angela@gmail.com',
      phone: '09124567890',
      dob: '1997-07-11',
      gender: 'Female',
      address: 'Quezon City, NCR',
      shopName: 'Pet Pantry PH',
      businessType: 'Partnership',
      category: 'Grooming & Hygiene',
      products: 'Shampoos, wipes, grooming sets, dental care',
      businessAddress: 'Novaliches, Quezon City',
      yearsInOperation: '2',
      businessPhone: '09124567890',
      payoutMethod: 'E-Wallet',
      gcashNumber: '09201234567',
      requestedAt: '2026-04-03',
      status: _RequestStatus.approved,
    ),
    _SellerApplication(
      id: 'S-1003',
      fullName: 'Mark Rivera',
      email: 'markrivera@gmail.com',
      phone: '09111222333',
      dob: '1995-12-10',
      gender: 'Male',
      address: 'Pasig City, NCR',
      shopName: 'FurCare Essentials',
      businessType: 'Corporation',
      category: 'Accessories',
      products: 'Harnesses, collars, tags, travel bags',
      businessAddress: 'Ortigas, Pasig City',
      yearsInOperation: '4',
      businessPhone: '09111222333',
      payoutMethod: 'E-Wallet',
      gcashNumber: '09351234567',
      requestedAt: '2026-04-05',
      status: _RequestStatus.rejected,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SellerApplication> get _filteredApplications {
    final search = _searchController.text.trim().toLowerCase();
    if (search.isEmpty) return _applications;
    return _applications.where((app) {
      return app.fullName.toLowerCase().contains(search) ||
          app.email.toLowerCase().contains(search) ||
          app.shopName.toLowerCase().contains(search);
    }).toList();
  }

  int get _pendingSellerCount =>
      _applications.where((a) => a.status == _RequestStatus.pending).length;

  // Prototype rider pending count for sidebar badge parity with web.
  int get _pendingRiderCount => 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.usersSellerRequests,
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
                _buildPendingBadges(),
                const SizedBox(height: 12),
                _buildPanel(),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Seller Requests',
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Open menu',
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Seller Requests',
              style: TextStyle(
                color: _text,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _info('Notifications panel is prototype-only.'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBadges() {
    return Row(
      children: [
        _CounterCard(
          label: 'Pending Sellers',
          value: _pendingSellerCount.toString(),
          icon: Icons.storefront_outlined,
        ),
        const SizedBox(width: 10),
        _CounterCard(
          label: 'Pending Riders',
          value: _pendingRiderCount.toString(),
          icon: Icons.two_wheeler_outlined,
        ),
      ],
    );
  }

  Widget _buildPanel() {
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
            'Pending Seller Applications',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search seller requests...',
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
          if (_filteredApplications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No seller requests found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ..._filteredApplications.map(_buildApplicationCard),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(_SellerApplication app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.fullName,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.email,
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.shopName,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: app.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Requested: ${app.requestedAt}',
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => _openDetails(app),
                child: const Text('View'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: app.status == _RequestStatus.pending
                    ? () => _updateStatus(app, _RequestStatus.approved)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: app.status == _RequestStatus.pending
                      ? _accent
                      : const Color(0xFFCCCCCC),
                  foregroundColor: app.status == _RequestStatus.pending
                      ? const Color(0xFF051014)
                      : const Color(0xFF666666),
                ),
                child: const Text('Approve'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: app.status == _RequestStatus.pending
                    ? () => _updateStatus(app, _RequestStatus.rejected)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: app.status == _RequestStatus.pending
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFFCCCCCC),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reject'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openDetails(_SellerApplication app) async {
    var step = 0;
    final steps = ['Personal Info', 'Business Info', 'Documents'];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F8FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    const Text(
                      'Seller Application Details',
                      style: TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(steps.length, (index) {
                        final isActive = step == index;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == steps.length - 1 ? 0 : 6,
                            ),
                            child: ElevatedButton(
                              onPressed: () =>
                                  setSheetState(() => step = index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isActive
                                    ? _accent2
                                    : const Color(0xFFE5E8F0),
                                foregroundColor: isActive
                                    ? const Color(0xFF051014)
                                    : _text,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                steps[index],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: SingleChildScrollView(
                        child: _stepContent(app, step),
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
  }

  Widget _stepContent(_SellerApplication app, int step) {
    if (step == 0) {
      return _InfoList(
        items: [
          ('Full Name', app.fullName),
          ('Email', app.email),
          ('Phone', app.phone),
          ('Date of Birth', app.dob),
          ('Gender', app.gender),
          ('Address', app.address),
        ],
      );
    }
    if (step == 1) {
      return _InfoList(
        items: [
          ('Store / Business Name', app.shopName),
          ('Business Type', app.businessType),
          ('Category', app.category),
          ('Detailed Products', app.products),
          ('Business Address', app.businessAddress),
          ('Years in Operation', app.yearsInOperation),
          ('Business Contact Number', app.businessPhone),
          ('Preferred Payout Method', app.payoutMethod),
          ('GCash Number', app.gcashNumber),
        ],
      );
    }
    return _InfoList(
      items: const [
        ('DTI / SEC Registration', 'Uploaded'),
        ('Business / Mayor\'s Permit', 'Uploaded'),
        ('BIR Certificate', 'Uploaded'),
        ('Owner / Representative ID', 'Uploaded'),
        ('Selfie with ID', 'Uploaded'),
        ('Proof of Address', 'Uploaded'),
      ],
    );
  }

  void _updateStatus(_SellerApplication app, _RequestStatus status) {
    final idx = _applications.indexOf(app);
    if (idx < 0) return;
    setState(() {
      _applications[idx] = app.copyWith(status: status);
    });
    _info(
      status == _RequestStatus.approved
          ? 'Seller request approved.'
          : 'Seller request rejected.',
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
        return;
      case AdminSection.usersRiderRequests:
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminRiderRequests);
        return;
      case AdminSection.products:
        _info('Product Management page is the next integration step.');
        return;
      case AdminSection.orders:
        _info('Order Management page is the next integration step.');
        return;
      case AdminSection.commission:
        _info('Commission Tracking page is the next integration step.');
        return;
      case AdminSection.offenses:
        _info('Offenses & Violations page is the next integration step.');
        return;
      case AdminSection.reports:
        _info('Reports & Analytics page is the next integration step.');
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

  void _info(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xECFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8BB6FF)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF5B6378),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF0B0F1A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoList extends StatelessWidget {
  const _InfoList({required this.items});

  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xECFFFFFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x120B0F1A)),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: '${item.$1}: ',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: item.$2,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _RequestStatus status;

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFFFFB86B);
    String text = 'pending';
    if (status == _RequestStatus.approved) {
      color = const Color(0xFF4CD964);
      text = 'approved';
    } else if (status == _RequestStatus.rejected) {
      color = const Color(0xFFFF6B6B);
      text = 'rejected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

enum _RequestStatus { pending, approved, rejected }

class _SellerApplication {
  const _SellerApplication({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.address,
    required this.shopName,
    required this.businessType,
    required this.category,
    required this.products,
    required this.businessAddress,
    required this.yearsInOperation,
    required this.businessPhone,
    required this.payoutMethod,
    required this.gcashNumber,
    required this.requestedAt,
    required this.status,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final String gender;
  final String address;
  final String shopName;
  final String businessType;
  final String category;
  final String products;
  final String businessAddress;
  final String yearsInOperation;
  final String businessPhone;
  final String payoutMethod;
  final String gcashNumber;
  final String requestedAt;
  final _RequestStatus status;

  _SellerApplication copyWith({_RequestStatus? status}) {
    return _SellerApplication(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      dob: dob,
      gender: gender,
      address: address,
      shopName: shopName,
      businessType: businessType,
      category: category,
      products: products,
      businessAddress: businessAddress,
      yearsInOperation: yearsInOperation,
      businessPhone: businessPhone,
      payoutMethod: payoutMethod,
      gcashNumber: gcashNumber,
      requestedAt: requestedAt,
      status: status ?? this.status,
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
