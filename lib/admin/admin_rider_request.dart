import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminRiderRequestPage extends StatefulWidget {
  const AdminRiderRequestPage({super.key});

  @override
  State<AdminRiderRequestPage> createState() => _AdminRiderRequestPageState();
}

class _AdminRiderRequestPageState extends State<AdminRiderRequestPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  final List<_RiderApplication> _applications = [
    _RiderApplication(
      id: 'R-2001',
      fullName: 'Paolo Mendoza',
      email: 'paolo@gmail.com',
      phone: '09174561234',
      dob: '1999-05-18',
      gender: 'Male',
      address: 'Davao City, Davao del Sur',
      vehicleType: 'Motorcycle',
      plateNumber: 'ABC 1234',
      yearModel: '2023',
      chassisNumber: 'CHS-11223344',
      vehicleModel: 'Honda Click 125',
      vehicleColor: 'Black',
      engineNumber: 'ENG-99887766',
      licenseNumber: 'N01-23-456789',
      payoutMethod: 'GCash',
      eWalletNumber: '09174561234',
      requestedAt: '2026-04-06',
      status: _RequestStatus.pending,
    ),
    _RiderApplication(
      id: 'R-2002',
      fullName: 'Clarisse Ramos',
      email: 'clarisse@yahoo.com',
      phone: '09221113344',
      dob: '1998-08-22',
      gender: 'Female',
      address: 'Iloilo City, Iloilo',
      vehicleType: 'Scooter',
      plateNumber: 'XYZ 9021',
      yearModel: '2022',
      chassisNumber: 'CHS-77889900',
      vehicleModel: 'Yamaha Mio Gear',
      vehicleColor: 'Blue',
      engineNumber: 'ENG-22334455',
      licenseNumber: 'S12-34-567890',
      payoutMethod: 'GCash',
      eWalletNumber: '09221113344',
      requestedAt: '2026-04-08',
      status: _RequestStatus.approved,
    ),
    _RiderApplication(
      id: 'R-2003',
      fullName: 'Kevin Torres',
      email: 'kevin.torres@gmail.com',
      phone: '09356667788',
      dob: '1996-11-14',
      gender: 'Male',
      address: 'Baguio City, Benguet',
      vehicleType: 'Motorcycle',
      plateNumber: 'LMN 7788',
      yearModel: '2021',
      chassisNumber: 'CHS-55667788',
      vehicleModel: 'Suzuki Burgman',
      vehicleColor: 'Gray',
      engineNumber: 'ENG-11002233',
      licenseNumber: 'T98-76-543210',
      payoutMethod: 'GCash',
      eWalletNumber: '09356667788',
      requestedAt: '2026-04-09',
      status: _RequestStatus.rejected,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_RiderApplication> get _filteredApplications {
    final search = _searchController.text.trim().toLowerCase();
    if (search.isEmpty) {
      return _applications;
    }
    return _applications.where((app) {
      return app.fullName.toLowerCase().contains(search) ||
          app.email.toLowerCase().contains(search) ||
          app.vehicleType.toLowerCase().contains(search) ||
          app.licenseNumber.toLowerCase().contains(search);
    }).toList();
  }

  int get _pendingSellerCount => 3;

  int get _pendingRiderCount =>
      _applications.where((a) => a.status == _RequestStatus.pending).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.usersRiderRequests,
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
                    '© 2025 Petopia — Rider Requests',
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
              'Rider Requests',
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
            'Pending Rider Applications',
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
              hintText: 'Search rider requests...',
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
                  'No rider requests found.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ..._filteredApplications.map(_buildApplicationCard),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(_RiderApplication app) {
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
                      '${app.vehicleType} • ${app.licenseNumber}',
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

  Future<void> _openDetails(_RiderApplication app) async {
    var step = 0;
    final steps = ['Personal Info', 'Vehicle Info', 'Documents'];

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
                      'Rider Application Details',
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

  Widget _stepContent(_RiderApplication app, int step) {
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
          ('Vehicle Type', app.vehicleType),
          ('Plate Number', app.plateNumber),
          ('Year Model', app.yearModel),
          ('Chassis Number', app.chassisNumber),
          ('Vehicle Model', app.vehicleModel),
          ('Vehicle Color', app.vehicleColor),
          ('Engine Number', app.engineNumber),
          ('Driver\'s License Number', app.licenseNumber),
        ],
      );
    }
    return _InfoList(
      items: [
        ('Preferred Payout Method', app.payoutMethod),
        ('E-wallet Number', app.eWalletNumber),
        ('OR/CR (Vehicle Registration)', 'Uploaded'),
        ('Vehicle Photo', 'Uploaded'),
        ('Driver\'s License (Front & Back)', 'Uploaded'),
      ],
    );
  }

  void _updateStatus(_RiderApplication app, _RequestStatus status) {
    final idx = _applications.indexOf(app);
    if (idx < 0) {
      return;
    }
    setState(() {
      _applications[idx] = app.copyWith(status: status);
    });
    _info(
      status == _RequestStatus.approved
          ? 'Rider request approved.'
          : 'Rider request rejected.',
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
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminSellerRequests);
        return;
      case AdminSection.usersRiderRequests:
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
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.account, (route) => false);
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

class _RiderApplication {
  const _RiderApplication({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.address,
    required this.vehicleType,
    required this.plateNumber,
    required this.yearModel,
    required this.chassisNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.engineNumber,
    required this.licenseNumber,
    required this.payoutMethod,
    required this.eWalletNumber,
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
  final String vehicleType;
  final String plateNumber;
  final String yearModel;
  final String chassisNumber;
  final String vehicleModel;
  final String vehicleColor;
  final String engineNumber;
  final String licenseNumber;
  final String payoutMethod;
  final String eWalletNumber;
  final String requestedAt;
  final _RequestStatus status;

  _RiderApplication copyWith({_RequestStatus? status}) {
    return _RiderApplication(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      dob: dob,
      gender: gender,
      address: address,
      vehicleType: vehicleType,
      plateNumber: plateNumber,
      yearModel: yearModel,
      chassisNumber: chassisNumber,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      engineNumber: engineNumber,
      licenseNumber: licenseNumber,
      payoutMethod: payoutMethod,
      eWalletNumber: eWalletNumber,
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
