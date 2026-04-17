import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'admin_sidebar.dart';

class AdminArchivedUsersPage extends StatefulWidget {
  const AdminArchivedUsersPage({super.key});

  @override
  State<AdminArchivedUsersPage> createState() => _AdminArchivedUsersPageState();
}

class _AdminArchivedUsersPageState extends State<AdminArchivedUsersPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent2 = Color(0xFF8BB6FF);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _roleFilter = 'All';

  final List<_ArchivedUser> _archivedUsers = [
    _ArchivedUser(
      id: 'A2001',
      name: 'Archived Buyer',
      email: 'archived.buyer@example.com',
      role: 'Buyer',
      dateJoined: '2025-12-18',
    ),
    _ArchivedUser(
      id: 'A2002',
      name: 'Archived Seller',
      email: 'archived.seller@example.com',
      role: 'Seller',
      dateJoined: '2025-11-04',
    ),
    _ArchivedUser(
      id: 'A2003',
      name: 'Archived Rider',
      email: 'archived.rider@example.com',
      role: 'Rider',
      dateJoined: '2025-10-09',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _archivedUsers.where((user) {
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
                      'Archived Users',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _text,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFilters(),
                const SizedBox(height: 14),
                _buildList(filtered),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Users',
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

  Widget _buildFilters() {
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
              hintText: 'Search by name or email...',
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
                      borderSide: const BorderSide(color: Color(0x120B0F1A)),
                    ),
                  ),
                  items: const ['All', 'Buyer', 'Seller', 'Rider', 'Admin']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _roleFilter = value ?? 'All'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoutes.adminAllUsers),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0B0F1A),
                  backgroundColor: const Color(0xFFE5E8F0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text(
                  'Back to All Users',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<_ArchivedUser> users) {
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
            'Archived Users List',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _text,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (users.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Center(
                child: Text(
                  'No archived users.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ...users.map(_buildUserRow),
        ],
      ),
    );
  }

  Widget _buildUserRow(_ArchivedUser user) {
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
              _chip('Archived', const Color(0xFFB8C0D4)),
              _chip(user.dateJoined, const Color(0xFFB8C0D4)),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CF4D1),
                foregroundColor: const Color(0xFF051014),
              ),
              onPressed: () => _restoreUser(user),
              child: const Text(
                'Restore',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
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

  void _restoreUser(_ArchivedUser user) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore User'),
        content: Text('Restore ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _archivedUsers.removeWhere((u) => u.id == user.id);
              });
              _info('${user.name} has been restored (prototype).');
            },
            child: const Text('Restore'),
          ),
        ],
      ),
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
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.adminRiderRequests);
        return;
      case AdminSection.products:
        _info('Product Management screen is the next integration step.');
        return;
      case AdminSection.orders:
        _info('Order Management screen is the next integration step.');
        return;
      case AdminSection.commission:
        _info('Commission Tracking screen is the next integration step.');
        return;
      case AdminSection.offenses:
        _info('Offenses & Violations screen is the next integration step.');
        return;
      case AdminSection.reports:
        _info('Reports & Analytics screen is the next integration step.');
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

class _ArchivedUser {
  const _ArchivedUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.dateJoined,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String dateJoined;
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
