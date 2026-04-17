import 'package:flutter/material.dart';

class BuyerBottomNav extends StatelessWidget {
  const BuyerBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _accent2 = Color(0xFF8BB6FF);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: _accent2,
      unselectedItemColor: _muted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
