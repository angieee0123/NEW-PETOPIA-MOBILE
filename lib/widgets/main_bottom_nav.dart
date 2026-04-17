import 'package:flutter/material.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

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
      items: items,
    );
  }
}
