import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import 'buyer_bottom_nav.dart';

class BuyerCartPage extends StatefulWidget {
  const BuyerCartPage({super.key});

  @override
  State<BuyerCartPage> createState() => _BuyerCartPageState();
}

class _BuyerCartPageState extends State<BuyerCartPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);
  static const _danger = Color(0xFFFF6B6B);

  final int _currentIndex = 2;
  bool _editMode = false;

  final List<_CartItem> _items = [
    _CartItem(
      id: 'c-001',
      name: 'Premium Dog Food 5kg',
      category: 'Food & Treats',
      price: 899,
      quantity: 1,
      isSelected: true,
      badgeColor: const Color(0xFFFFE6C5),
    ),
    _CartItem(
      id: 'c-002',
      name: 'Automatic Feeder',
      category: 'Feeding Supplies',
      price: 1999,
      quantity: 1,
      isSelected: true,
      badgeColor: const Color(0xFFDDEAFF),
    ),
    _CartItem(
      id: 'c-003',
      name: 'Pet Grooming Kit',
      category: 'Grooming & Hygiene',
      price: 749,
      quantity: 2,
      isSelected: false,
      badgeColor: const Color(0xFFE4FFE8),
    ),
    _CartItem(
      id: 'c-004',
      name: 'Orthopedic Pet Bed',
      category: 'Bedding & Housing',
      price: 1350,
      quantity: 1,
      isSelected: true,
      badgeColor: const Color(0xFFF2E4FF),
    ),
    _CartItem(
      id: 'c-005',
      name: 'Portable Water Bottle',
      category: 'Accessories',
      price: 189,
      quantity: 3,
      isSelected: false,
      badgeColor: const Color(0xFFDDF3FF),
    ),
    _CartItem(
      id: 'c-006',
      name: 'Calming Pet Shampoo',
      category: 'Grooming & Hygiene',
      price: 275,
      quantity: 2,
      isSelected: true,
      badgeColor: const Color(0xFFE5FFE9),
    ),
    _CartItem(
      id: 'c-007',
      name: 'Foldable Travel Carrier',
      category: 'Travel',
      price: 1120,
      quantity: 1,
      isSelected: false,
      badgeColor: const Color(0xFFFFEDD8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _selectedTotal;
    final allSelected = _items.isNotEmpty && _items.every((i) => i.isSelected);
    final anySelected = _items.any((i) => i.isSelected);

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _buildTopBar(),
                const SizedBox(height: 14),
                _buildSelectAllRow(allSelected: allSelected),
                const SizedBox(height: 12),
                _buildItemsPanel(),
                const SizedBox(height: 12),
                if (_editMode)
                  _buildDeleteSelectedRow(anySelected: anySelected),
                const SizedBox(height: 12),
                _buildCheckoutBar(total: total),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Buyer Cart',
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
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 2) {
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.buyerDashboard,
            arguments: {'tab': value},
          );
        },
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Select items, adjust quantity, and checkout',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _editMode = !_editMode),
            icon: const Icon(Icons.edit_rounded),
            label: Text(_editMode ? 'Done' : 'Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllRow({required bool allSelected}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            activeColor: _accent2,
            onChanged: (value) {
              final newValue = value ?? false;
              setState(() {
                for (final item in _items) {
                  item.isSelected = newValue;
                }
              });
            },
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Select All',
              style: TextStyle(color: _text, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${_items.length} item(s)',
            style: const TextStyle(color: _muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsPanel() {
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
            'Cart Items',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (_items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 26),
              child: Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ..._items.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CartRow(
                item: entry.value,
                editMode: _editMode,
                onToggleSelected: (selected) {
                  setState(() => entry.value.isSelected = selected);
                },
                onQtyChanged: (qty) {
                  setState(() => entry.value.quantity = qty);
                },
                onRemove: () {
                  setState(() => _items.removeAt(entry.key));
                  _snack('Removed item from cart.');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteSelectedRow({required bool anySelected}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: anySelected ? _deleteSelected : null,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete Selected'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar({required int total}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  const TextSpan(text: 'Total: '),
                  TextSpan(
                    text: '₱${_formatPeso(total)}',
                    style: const TextStyle(color: _accent2),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: total == 0 ? null : _checkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: const Color(0xFF051014),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_accent, _accent2]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _selectedTotal {
    var total = 0;
    for (final item in _items) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  void _deleteSelected() {
    final before = _items.length;
    setState(() => _items.removeWhere((i) => i.isSelected));
    final removed = before - _items.length;
    _snack('Deleted $removed item(s).');
  }

  void _checkout() {
    final selected = _items.where((i) => i.isSelected).toList();
    if (selected.isEmpty) {
      _snack('No selected items to checkout.');
      return;
    }

    final payload = selected
        .map(
          (i) => {
            'id': i.id,
            'name': i.name,
            'category': i.category,
            'price': i.price,
            'quantity': i.quantity,
          },
        )
        .toList();

    Navigator.of(
      context,
    ).pushNamed(AppRoutes.buyerCheckout, arguments: {'items': payload});
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static String _formatPeso(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.item,
    required this.editMode,
    required this.onToggleSelected,
    required this.onQtyChanged,
    required this.onRemove,
  });

  final _CartItem item;
  final bool editMode;
  final ValueChanged<bool> onToggleSelected;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isSelected,
            activeColor: const Color(0xFF8BB6FF),
            onChanged: (value) => onToggleSelected(value ?? false),
          ),
          const SizedBox(width: 4),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pets_rounded, color: Color(0xFF2E5EA7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0B0F1A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: Color(0xFF5B6378),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₱${_BuyerCartPageState._formatPeso(item.price)}',
                      style: const TextStyle(
                        color: Color(0xFF0B0F1A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _QtyControl(
                      quantity: item.quantity,
                      onChanged: onQtyChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (editMode) ...[
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Remove',
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _QtyControl extends StatefulWidget {
  const _QtyControl({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  State<_QtyControl> createState() => _QtyControlState();
}

class _QtyControlState extends State<_QtyControl> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant _QtyControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity &&
        _controller.text != widget.quantity.toString()) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commit(String value) {
    final cleaned = value.trim();
    final parsed = int.tryParse(cleaned);
    final clamped = (parsed ?? 1).clamp(1, 999999);
    if (_controller.text != clamped.toString()) {
      _controller.text = clamped.toString();
    }
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0A0B0F1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: widget.quantity <= 1
                ? null
                : () => widget.onChanged(widget.quantity - 1),
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          SizedBox(
            width: 52,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: const TextStyle(fontWeight: FontWeight.w800),
              onChanged: (value) {
                // Don’t allow empty/zero/negative values (digitsOnly prevents '-').
                if (value.isEmpty) {
                  return;
                }
                final parsed = int.tryParse(value) ?? 1;
                widget.onChanged(parsed.clamp(1, 999999));
              },
              onSubmitted: _commit,
              onEditingComplete: () {
                _commit(_controller.text);
                _focusNode.unfocus();
              },
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => widget.onChanged(widget.quantity + 1),
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _CartItem {
  _CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.badgeColor,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  int quantity;
  bool isSelected;
  final Color badgeColor;
}

class _AuroraBackground extends StatelessWidget {
  const _AuroraBackground();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
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
