import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminAllUsersPage extends StatefulWidget {
  const AdminAllUsersPage({super.key});

  @override
  State<AdminAllUsersPage> createState() => _AdminAllUsersPageState();
}

class _AdminAllUsersPageState extends State<AdminAllUsersPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _roleFilter = 'All';

  final List<_AdminUser> _users = [
    _AdminUser(
      id: 'U1001',
      name: 'Angelica Cuevas',
      email: 'angelica@gmail.com',
      role: 'Admin',
      status: 'Active',
      dateJoined: '2026-03-01',
      phone: '09123456789',
      dob: '2000-06-11',
      gender: 'Female',
      address: 'Quezon City, Metro Manila',
    ),
    _AdminUser(
      id: 'U1002',
      name: 'Jerome Villanueva',
      email: 'jerome@yahoo.com',
      role: 'Seller',
      status: 'Pending',
      dateJoined: '2026-04-02',
      phone: '09987654321',
      dob: '1998-01-23',
      gender: 'Male',
      address: 'Cebu City, Cebu',
      businessName: 'PawSmart Supplies',
      businessType: 'Sole Proprietor',
      category: 'Food & Treats',
    ),
    _AdminUser(
      id: 'U1003',
      name: 'Maria Santos',
      email: 'maria@gmail.com',
      role: 'Buyer',
      status: 'Active',
      dateJoined: '2026-04-07',
      phone: '09124567890',
      dob: '1999-08-15',
      gender: 'Female',
      address: 'Davao City, Davao del Sur',
    ),
    _AdminUser(
      id: 'U1004',
      name: 'Mark Dela Cruz',
      email: 'mark@yahoo.com',
      role: 'Rider',
      status: 'Active',
      dateJoined: '2026-04-10',
      phone: '09111222333',
      dob: '1997-12-05',
      gender: 'Male',
      address: 'Pasig City, Metro Manila',
      vehicleType: 'Motorcycle',
      plateNumber: 'ABC-1234',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      final search = _searchController.text.trim().toLowerCase();
      final roleMatch = _roleFilter == 'All' || user.role == _roleFilter;
      final searchMatch =
          search.isEmpty ||
          user.name.toLowerCase().contains(search) ||
          user.email.toLowerCase().contains(search);
      return roleMatch && searchMatch;
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: AdminSidebar(
        activeSection: AdminSection.usersAll,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                      tooltip: 'Open menu',
                    ),
                    const Spacer(),
                    const Text(
                      'All Users',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _text,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
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
                          hintText: 'Search by name or email...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0x120B0F1A),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0x120B0F1A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _roleFilter,
                              decoration: InputDecoration(
                                labelText: 'Role Filter',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0x120B0F1A),
                                  ),
                                ),
                              ),
                              items:
                                  const [
                                        'All',
                                        'Buyer',
                                        'Seller',
                                        'Rider',
                                        'Admin',
                                      ]
                                      .map(
                                        (r) => DropdownMenuItem(
                                          value: r,
                                          child: Text(r),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) =>
                                  setState(() => _roleFilter = value ?? 'All'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8B8B)],
                              ),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.adminArchivedUsers),
                              child: const Text(
                                'Archived',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
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
                        'Users List',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _text,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (filteredUsers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: Center(
                            child: Text(
                              'No users found.',
                              style: TextStyle(
                                color: _muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ...filteredUsers.map((user) => _buildUserCard(user)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — All Users',
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

  void _onSidebarSelect(AdminSection section) {
    Navigator.of(context).pop(); // close drawer
    switch (section) {
      case AdminSection.overview:
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminDashboard);
        return;
      case AdminSection.usersAll:
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
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminProductManagement);
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

  Widget _buildUserCard(_AdminUser user) {
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
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w800, color: _text),
          ),
          const SizedBox(height: 3),
          Text(user.email, style: const TextStyle(color: _muted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _chip(user.role, _accent2),
              _chip(
                user.status,
                user.status == 'Active'
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFFBBF24),
              ),
              _chip(user.dateJoined, const Color(0xFFB8C0D4)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openUserModal(user),
                  child: const Text('View'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                  ),
                  onPressed: () => _archiveUser(user),
                  child: const Text(
                    'Archive',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
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

  void _openUserModal(_AdminUser user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DefaultTabController(
        length: user.role == 'Seller' || user.role == 'Rider' ? 3 : 1,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
              Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: _text,
                ),
              ),
              const SizedBox(height: 8),
              if (user.role == 'Seller' || user.role == 'Rider')
                TabBar(
                  labelColor: _text,
                  unselectedLabelColor: _muted,
                  indicatorColor: _accent2,
                  tabs: [
                    const Tab(text: 'Personal'),
                    Tab(text: user.role == 'Seller' ? 'Business' : 'Vehicle'),
                    const Tab(text: 'Documents'),
                  ],
                ),
              Expanded(
                child: user.role == 'Seller' || user.role == 'Rider'
                    ? TabBarView(
                        children: [
                          _personalSection(user),
                          user.role == 'Seller'
                              ? _sellerSection(user)
                              : _riderSection(user),
                          _documentsSection(user),
                        ],
                      )
                    : _personalSection(user),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _personalSection(_AdminUser user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _line('Full Name', user.name),
        _line('Email', user.email),
        _line('Phone', user.phone),
        _line('Date of Birth', user.dob),
        _line('Gender', user.gender),
        _line('Address', user.address),
      ],
    );
  }

  Widget _sellerSection(_AdminUser user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _line('Store / Business Name', user.businessName ?? '—'),
        _line('Business Type', user.businessType ?? '—'),
        _line('Primary Category', user.category ?? '—'),
        _line('Business Address', user.address),
      ],
    );
  }

  Widget _riderSection(_AdminUser user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _line('Vehicle Type', user.vehicleType ?? '—'),
        _line('Plate Number', user.plateNumber ?? '—'),
        _line('Address', user.address),
      ],
    );
  }

  Widget _documentsSection(_AdminUser user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          'Document links are the next integration step.',
          style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _line(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: _text),
          children: [
            TextSpan(
              text: '$key: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _archiveUser(_AdminUser user) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive User'),
        content: Text('Archive ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _users.removeWhere((u) => u.id == user.id);
              });
              _info('${user.name} has been archived.');
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _info(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AdminUser {
  const _AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.dateJoined,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.address,
    this.businessName,
    this.businessType,
    this.category,
    this.vehicleType,
    this.plateNumber,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String dateJoined;
  final String phone;
  final String dob;
  final String gender;
  final String address;
  final String? businessName;
  final String? businessType;
  final String? category;
  final String? vehicleType;
  final String? plateNumber;
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
