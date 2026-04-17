import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_routes.dart';
import 'buyer_bottom_nav.dart';

class BuyerCheckoutPage extends StatefulWidget {
  const BuyerCheckoutPage({super.key, required this.items});

  /// Route argument from `AppRoutes.buyerCheckout`.
  /// Each item expects: { id, name, category, price (int), quantity (int) }.
  final List<Map<String, dynamic>> items;

  @override
  State<BuyerCheckoutPage> createState() => _BuyerCheckoutPageState();
}

class _BuyerCheckoutPageState extends State<BuyerCheckoutPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final int _currentIndex = 2; // keep buyer nav consistent with cart flow

  final _fullNameController = TextEditingController(text: 'Juan Dela Cruz');
  final _phoneController = TextEditingController(text: '09xxxxxxxxx');
  final _addressController = TextEditingController(
    text: 'House No., Street, Barangay, City, Province, ZIP',
  );
  final _notesController = TextEditingController();
  final _voucherController = TextEditingController();

  bool _voucherApplied = false;
  String? _voucherLabel;
  int _voucherDiscount = 0;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final hasItems = items.isNotEmpty;
    final subtotal = _subtotal(items);
    final shipping = _shipping(subtotal);
    final total = (subtotal - _voucherDiscount + shipping).clamp(0, 1 << 30);

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 124),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    Expanded(child: _buildEmptyState(context))
                  else ...[
                    _buildShippingAndPayment(),
                    const SizedBox(height: 12),
                    _buildTotals(
                      subtotal: subtotal,
                      shipping: shipping,
                      discount: _voucherDiscount,
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _buildOrderSummary(items)),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 8,
            child: _buildCheckoutStickyBar(total: total, enabled: hasItems),
          ),
        ],
      ),
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.buyerCart);
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

  Widget _buildHeader(BuildContext context) {
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
              Icons.receipt_long_outlined,
              color: Color(0xFF051014),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checkout',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Review items, shipping, and place your order',
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.remove_shopping_cart_outlined,
            size: 56,
            color: Color(0xFF8BB6FF),
          ),
          const SizedBox(height: 12),
          const Text(
            'No selected items to checkout.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Go back to cart to select products.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.buyerCart),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: const Color(0xFF051014),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Back to Cart',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(List<_CheckoutItem> items) {
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
            'Order Summary',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _SummaryRow(item: items[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAndPayment() {
    InputDecoration deco(String label, {String? hint, IconData? icon}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x120B0F1A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x120B0F1A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xB38BB6FF), width: 2),
        ),
      );
    }

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
            'Shipping Details',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _fullNameController,
            textInputAction: TextInputAction.next,
            decoration: deco(
              'Full Name',
              hint: 'Juan Dela Cruz',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: deco(
              'Phone',
              hint: '09xxxxxxxxx',
              icon: Icons.phone_outlined,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressController,
            textInputAction: TextInputAction.next,
            decoration: deco(
              'Address',
              hint: 'House No., Street, Barangay, City, Province, ZIP',
              icon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            textInputAction: TextInputAction.done,
            decoration: deco(
              'Order Notes (optional)',
              hint: 'Any instructions for delivery',
              icon: Icons.sticky_note_2_outlined,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Method',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_shipping_outlined, color: Color(0xFF2E5EA7)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cash on Delivery',
                    style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  'Default',
                  style: TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals({
    required int subtotal,
    required int shipping,
    required int discount,
  }) {
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _voucherController,
                  decoration: InputDecoration(
                    hintText: 'Enter voucher code',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0x120B0F1A)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0x120B0F1A)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _applyVoucher(subtotal),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: const Color(0xFF051014),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_voucherApplied && _voucherLabel != null)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x148BB6FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x338BB6FF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.confirmation_number_outlined,
                        size: 16,
                        color: _accent2,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _voucherLabel!,
                        style: const TextStyle(
                          color: _accent2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _voucherApplied = false;
                    _voucherLabel = null;
                    _voucherDiscount = 0;
                    _voucherController.clear();
                  }),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          _kvRow('Subtotal', '₱${_peso(subtotal)}'),
          if (discount > 0)
            _kvRow(
              'Discount',
              '-₱${_peso(discount)}',
              valueColor: const Color(0xFF16A34A),
            ),
          _kvRow('Shipping', '₱${_peso(shipping)}'),
        ],
      ),
    );
  }

  Widget _buildCheckoutStickyBar({required int total, required bool enabled}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x120B0F1A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A101828),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₱${_peso(total)}',
                  style: const TextStyle(
                    color: _accent2,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: enabled ? _placeOrder : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: const Color(0xFF051014),
              disabledForegroundColor: const Color(0x805B6378),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: enabled
                    ? const LinearGradient(colors: [_accent, _accent2])
                    : const LinearGradient(
                        colors: [Color(0xFFE5E8F0), Color(0xFFD8DDE8)],
                      ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Text(
                  'Place Order',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kvRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: _muted,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xB30B0F1A),
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _applyVoucher(int subtotal) {
    final code = _voucherController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _snack('Enter a voucher code first.');
      return;
    }

    // Prototype rules (based on template’s voucher input behavior).
    // - PET100: ₱100 off if subtotal >= ₱1000
    // - SAVE50: ₱50 off if subtotal >= ₱500
    if (code == 'PET100') {
      if (subtotal < 1000) {
        _snack('PET100 requires subtotal of ₱1,000+.');
        return;
      }
      setState(() {
        _voucherApplied = true;
        _voucherLabel = 'PET100 • ₱100 off';
        _voucherDiscount = 100;
      });
      return;
    }

    if (code == 'SAVE50') {
      if (subtotal < 500) {
        _snack('SAVE50 requires subtotal of ₱500+.');
        return;
      }
      setState(() {
        _voucherApplied = true;
        _voucherLabel = 'SAVE50 • ₱50 off';
        _voucherDiscount = 50;
      });
      return;
    }

    _snack('Invalid voucher code (prototype). Try PET100 or SAVE50.');
  }

  void _placeOrder() {
    final name = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      _snack('Please complete shipping details first.');
      return;
    }
    _snack('Order placed (prototype).');
    Navigator.of(context).pushReplacementNamed(AppRoutes.buyerDashboard);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<_CheckoutItem> get _items {
    final routeItems = widget.items
        .map(
          (m) => _CheckoutItem(
            id: (m['id'] as Object?)?.toString() ?? '',
            name: (m['name'] as String?) ?? 'Item',
            category: (m['category'] as String?) ?? '',
            price: (m['price'] as int?) ?? 0,
            quantity: (m['quantity'] as int?) ?? 1,
          ),
        )
        .where((i) => i.id.isNotEmpty)
        .toList();

    if (routeItems.isNotEmpty) {
      return routeItems;
    }

    // Prototype fallback so checkout still demonstrates complete UI
    // when opened directly without route payload.
    return const [
      _CheckoutItem(
        id: 'sample-001',
        name: 'Premium Dog Food 5kg',
        category: 'Food & Treats',
        price: 899,
        quantity: 1,
      ),
      _CheckoutItem(
        id: 'sample-002',
        name: 'Portable Water Bottle',
        category: 'Accessories',
        price: 189,
        quantity: 2,
      ),
    ];
  }

  static int _subtotal(List<_CheckoutItem> items) {
    var total = 0;
    for (final it in items) {
      total += it.price * it.quantity;
    }
    return total;
  }

  // Prototype shipping similar to template’s default shipping behavior.
  static int _shipping(int subtotal) {
    if (subtotal <= 0) {
      return 0;
    }
    return 59;
  }

  static String _peso(int value) {
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.item});

  final _CheckoutItem item;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    final lineTotal = item.price * item.quantity;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFDDEAFF),
              borderRadius: BorderRadius.circular(12),
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
                    color: _text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.category} • Qty ${item.quantity}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₱${_BuyerCheckoutPageState._peso(lineTotal)}',
            style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _CheckoutItem {
  const _CheckoutItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final int quantity;
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
