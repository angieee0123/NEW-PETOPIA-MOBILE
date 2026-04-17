import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'seller_bottom_nav.dart';

class SellerPromotionPage extends StatefulWidget {
  const SellerPromotionPage({super.key});

  @override
  State<SellerPromotionPage> createState() => _SellerPromotionPageState();
}

class _SellerPromotionPageState extends State<SellerPromotionPage> {
  static const _bg = Color(0xFFF6F8FF);
  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  final _searchController = TextEditingController();

  final List<_FlashSalePromo> _flashSales = [
    _FlashSalePromo(
      title: 'Premium Dog Food 5kg',
      originalPrice: 899,
      salePrice: 699,
      stock: 24,
      start: DateTime(2026, 4, 16, 9, 0),
      end: DateTime(2026, 4, 18, 23, 59),
      description: 'Limited-time discount for best sellers.',
    ),
    _FlashSalePromo(
      title: 'Automatic Feeder',
      originalPrice: 1999,
      salePrice: 1699,
      stock: 9,
      start: DateTime(2026, 4, 19, 9, 0),
      end: DateTime(2026, 4, 21, 23, 59),
      description: 'Upcoming promo for weekend shoppers.',
    ),
  ];

  final List<_VoucherPromo> _vouchers = [
    _VoucherPromo(
      code: 'PETO10',
      type: _VoucherType.percent,
      value: 10,
      minSpend: 0,
      cap: 120,
      usageLimit: 100,
      used: 34,
      start: DateTime(2026, 4, 14, 0, 0),
      end: DateTime(2026, 4, 30, 23, 59),
    ),
    _VoucherPromo(
      code: 'SHIP50',
      type: _VoucherType.fixed,
      value: 50,
      minSpend: 499,
      cap: 0,
      usageLimit: 60,
      used: 60,
      start: DateTime(2026, 3, 1, 0, 0),
      end: DateTime(2026, 3, 31, 23, 59),
    ),
  ];

  final List<_FreeShippingRule> _shippingRules = [
    _FreeShippingRule(
      name: 'Free Ship over ₱1,000',
      minSpend: 1000,
      cap: 0,
      areas: 'NCR',
      start: DateTime(2026, 4, 10, 0, 0),
      end: DateTime(2026, 4, 30, 23, 59),
    ),
    _FreeShippingRule(
      name: 'Luzon cap ₱80',
      minSpend: 799,
      cap: 80,
      areas: 'Luzon',
      start: DateTime(2026, 4, 1, 0, 0),
      end: DateTime(2026, 4, 12, 23, 59),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchController.text.trim().toLowerCase();
    final flash = _flashSales
        .where((p) => q.isEmpty || p.title.toLowerCase().contains(q))
        .toList();
    final vouchers = _vouchers
        .where((v) => q.isEmpty || v.code.toLowerCase().contains(q))
        .toList();
    final ships = _shippingRules
        .where((s) => q.isEmpty || s.name.toLowerCase().contains(q))
        .toList();

    final activeSummary = _buildActiveSummary();

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const _AuroraBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _buildTopBar(context),
                const SizedBox(height: 14),
                _buildHeaderActions(context),
                const SizedBox(height: 14),
                _PromoPanel(
                  title: 'Flash Sale',
                  subtitle:
                      'Discount specific items for a limited time (prototype).',
                  child: _PromoList(
                    emptyLabel: 'No flash sales yet.',
                    items: [
                      for (final p in flash)
                        _PromoTile(
                          title: p.title,
                          subtitle:
                              '₱${p.salePrice.toStringAsFixed(0)} (was ₱${p.originalPrice.toStringAsFixed(0)}) • ${p.stock} stock',
                          trailing: _StatusPill(
                            label: _promoStatus(p.start, p.end).label,
                            kind: _promoStatus(p.start, p.end),
                          ),
                          onTap: () => _openFlashEditor(existing: p),
                          actions: [
                            _SmallAction(
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              onTap: () => _openFlashEditor(existing: p),
                            ),
                            _SmallAction(
                              label: 'Delete',
                              icon: Icons.delete_outline_rounded,
                              danger: true,
                              onTap: () => _deleteFlash(p),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _PromoPanel(
                  title: 'Store Vouchers',
                  subtitle:
                      'Create fixed or percent discounts with min spend and caps.',
                  child: _PromoList(
                    emptyLabel: 'No vouchers created.',
                    items: [
                      for (final v in vouchers)
                        _PromoTile(
                          title: v.code,
                          subtitle: _voucherSubtitle(v),
                          trailing: _StatusPill(
                            label: _promoStatus(v.start, v.end, usedUp: v.isUsedUp)
                                .label,
                            kind: _promoStatus(v.start, v.end, usedUp: v.isUsedUp),
                          ),
                          onTap: () => _openVoucherEditor(existing: v),
                          actions: [
                            _SmallAction(
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              onTap: () => _openVoucherEditor(existing: v),
                            ),
                            _SmallAction(
                              label: 'Delete',
                              icon: Icons.delete_outline_rounded,
                              danger: true,
                              onTap: () => _deleteVoucher(v),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _PromoPanel(
                  title: 'Free Shipping',
                  subtitle:
                      'Subsidize shipping above a minimum spend or up to a cap.',
                  child: _PromoList(
                    emptyLabel: 'No shipping rules.',
                    items: [
                      for (final s in ships)
                        _PromoTile(
                          title: s.name,
                          subtitle:
                              'Min spend ₱${s.minSpend.toStringAsFixed(0)} • Cap ${s.cap <= 0 ? 'None' : '₱${s.cap.toStringAsFixed(0)}'} • ${s.areas}',
                          trailing: _StatusPill(
                            label: _promoStatus(s.start, s.end).label,
                            kind: _promoStatus(s.start, s.end),
                          ),
                          onTap: () => _openShipEditor(existing: s),
                          actions: [
                            _SmallAction(
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              onTap: () => _openShipEditor(existing: s),
                            ),
                            _SmallAction(
                              label: 'Delete',
                              icon: Icons.delete_outline_rounded,
                              danger: true,
                              onTap: () => _deleteShip(s),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _PromoPanel(
                  title: 'Active Promotions (Preview)',
                  subtitle:
                      'This is a summary that buyer pages can read later.',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x120B0F1A)),
                    ),
                    child: Text(
                      activeSummary,
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© 2025 Petopia — Seller Promotions',
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
      bottomNavigationBar: SellerBottomNav(
        currentIndex: 0,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerProducts);
            return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.sellerOrders);
            return;
          }
          if (value == 3) {
            Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.sellerShopPublicView);
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.sellerDashboard,
            arguments: {'tab': value},
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_accent, _accent2]),
            ),
            child: const Icon(Icons.campaign_outlined, color: Color(0xFF051014)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promotions Manager',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Create Flash Sales, Vouchers, and Free Shipping rules',
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
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search code, title...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search_rounded),
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PrimaryPillButton(
                icon: Icons.bolt_rounded,
                label: 'New Flash Sale',
                onTap: () => _openFlashEditor(),
              ),
              _SecondaryPillButton(
                icon: Icons.confirmation_number_outlined,
                label: 'New Voucher',
                onTap: () => _openVoucherEditor(),
              ),
              _SecondaryPillButton(
                icon: Icons.local_shipping_outlined,
                label: 'Free Shipping Rule',
                onTap: () => _openShipEditor(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _PromoStatus _promoStatus(
    DateTime start,
    DateTime end, {
    bool usedUp = false,
  }) {
    final now = DateTime.now();
    if (usedUp) {
      return _PromoStatus.expired;
    }
    if (now.isBefore(start)) {
      return _PromoStatus.upcoming;
    }
    if (now.isAfter(end)) {
      return _PromoStatus.expired;
    }
    return _PromoStatus.active;
  }

  String _voucherSubtitle(_VoucherPromo v) {
    final type = v.type == _VoucherType.percent ? '${v.value}% off' : '₱${v.value.toStringAsFixed(0)} off';
    final min = v.minSpend <= 0 ? 'No min spend' : 'Min ₱${v.minSpend.toStringAsFixed(0)}';
    final cap = v.cap <= 0
        ? 'No cap'
        : 'Cap ₱${v.cap.toStringAsFixed(0)}';
    return '$type • $min • $cap • Used ${v.used}/${v.usageLimit}';
  }

  String _buildActiveSummary() {
    final now = DateTime.now();
    final activeFlash = _flashSales
        .where((f) => now.isAfter(f.start) && now.isBefore(f.end))
        .length;
    final activeVoucher = _vouchers
        .where((v) => !v.isUsedUp && now.isAfter(v.start) && now.isBefore(v.end))
        .length;
    final activeShip = _shippingRules
        .where((s) => now.isAfter(s.start) && now.isBefore(s.end))
        .length;

    if (activeFlash + activeVoucher + activeShip == 0) {
      return 'No active promos.';
    }
    return 'Active: $activeFlash flash sale(s), $activeVoucher voucher(s), $activeShip free shipping rule(s).';
  }

  Future<void> _openFlashEditor({_FlashSalePromo? existing}) async {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final origCtrl = TextEditingController(
      text: existing == null ? '' : existing.originalPrice.toStringAsFixed(0),
    );
    final saleCtrl = TextEditingController(
      text: existing == null ? '' : existing.salePrice.toStringAsFixed(0),
    );
    final stockCtrl = TextEditingController(
      text: existing == null ? '10' : existing.stock.toString(),
    );
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    var start = existing?.start ?? DateTime.now().add(const Duration(hours: 1));
    var end = existing?.end ?? DateTime.now().add(const Duration(days: 2));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final orig = double.tryParse(origCtrl.text.trim()) ?? 0;
            final sale = double.tryParse(saleCtrl.text.trim()) ?? 0;
            final pct = (orig > 0 && sale > 0 && sale < orig)
                ? ((1 - (sale / orig)) * 100).round()
                : null;

            return _EditorSheet(
              title: existing == null ? 'New Flash Sale' : 'Edit Flash Sale',
              subtitle:
                  pct == null ? 'Discount is auto-computed.' : '$pct% off',
              child: Column(
                children: [
                  _Field(label: 'Title', controller: titleCtrl, hint: 'e.g. Premium Dog Food 5kg'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'Original Price (₱)',
                          controller: origCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Field(
                          label: 'Sale Price (₱)',
                          controller: saleCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'Stock',
                          controller: stockCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateButton(
                          label: 'Start',
                          value: _fmtDate(start),
                          onTap: () async {
                            final v = await _pickDateTime(context, start);
                            if (v == null) return;
                            setSheetState(() => start = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _DateButton(
                    label: 'End',
                    value: _fmtDate(end),
                    onTap: () async {
                      final v = await _pickDateTime(context, end);
                      if (v == null) return;
                      setSheetState(() => end = v);
                    },
                  ),
                  const SizedBox(height: 10),
                  _Field(
                    label: 'Description',
                    controller: descCtrl,
                    maxLines: 3,
                    hint: 'Short description...',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: const Color(0xFF051014),
                          ),
                          onPressed: () {
                            final title = titleCtrl.text.trim();
                            final orig = double.tryParse(origCtrl.text.trim());
                            final sale = double.tryParse(saleCtrl.text.trim());
                            final stock = int.tryParse(stockCtrl.text.trim());
                            if (title.isEmpty ||
                                orig == null ||
                                sale == null ||
                                stock == null ||
                                orig <= 0 ||
                                sale <= 0 ||
                                sale >= orig ||
                                stock <= 0) {
                              _toast('Please fill valid flash sale details.');
                              return;
                            }
                            setState(() {
                              final promo = _FlashSalePromo(
                                title: title,
                                originalPrice: orig,
                                salePrice: sale,
                                stock: stock,
                                start: start,
                                end: end,
                                description: descCtrl.text.trim(),
                              );
                              if (existing == null) {
                                _flashSales.insert(0, promo);
                              } else {
                                final i = _flashSales.indexOf(existing);
                                if (i >= 0) _flashSales[i] = promo;
                              }
                            });
                            Navigator.of(context).pop();
                            _toast('Flash sale saved (prototype).');
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    titleCtrl.dispose();
    origCtrl.dispose();
    saleCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
  }

  Future<void> _openVoucherEditor({_VoucherPromo? existing}) async {
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    var type = existing?.type ?? _VoucherType.percent;
    final valueCtrl = TextEditingController(
      text: existing == null ? '' : existing.value.toStringAsFixed(0),
    );
    final minCtrl = TextEditingController(
      text: existing == null ? '0' : existing.minSpend.toStringAsFixed(0),
    );
    final capCtrl = TextEditingController(
      text: existing == null ? '0' : existing.cap.toStringAsFixed(0),
    );
    final limitCtrl = TextEditingController(
      text: existing == null ? '100' : existing.usageLimit.toString(),
    );
    var start = existing?.start ?? DateTime.now();
    var end = existing?.end ?? DateTime.now().add(const Duration(days: 14));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _EditorSheet(
              title: existing == null ? 'New Voucher' : 'Edit Voucher',
              subtitle: 'Create fixed or percent discounts',
              child: Column(
                children: [
                  _Field(label: 'Code', controller: codeCtrl, hint: 'e.g. PETO10'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownField<_VoucherType>(
                          label: 'Type',
                          value: type,
                          items: const [
                            DropdownMenuItem(
                              value: _VoucherType.percent,
                              child: Text('Percent'),
                            ),
                            DropdownMenuItem(
                              value: _VoucherType.fixed,
                              child: Text('Fixed'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setSheetState(() => type = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Field(
                          label: 'Discount Value',
                          controller: valueCtrl,
                          keyboardType: TextInputType.number,
                          hint: type == _VoucherType.percent
                              ? '10 = 10%'
                              : '50 = ₱50',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'Min Spend (₱)',
                          controller: minCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Field(
                          label: 'Max Discount Cap (₱)',
                          controller: capCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Field(
                    label: 'Usage Limit',
                    controller: limitCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: 'Start',
                          value: _fmtDate(start),
                          onTap: () async {
                            final v = await _pickDateTime(context, start);
                            if (v == null) return;
                            setSheetState(() => start = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateButton(
                          label: 'End',
                          value: _fmtDate(end),
                          onTap: () async {
                            final v = await _pickDateTime(context, end);
                            if (v == null) return;
                            setSheetState(() => end = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: const Color(0xFF051014),
                          ),
                          onPressed: () {
                            final code = codeCtrl.text.trim().toUpperCase();
                            final value = double.tryParse(valueCtrl.text.trim());
                            final min = double.tryParse(minCtrl.text.trim()) ?? 0;
                            final cap = double.tryParse(capCtrl.text.trim()) ?? 0;
                            final limit = int.tryParse(limitCtrl.text.trim());
                            if (code.isEmpty ||
                                value == null ||
                                value <= 0 ||
                                limit == null ||
                                limit <= 0 ||
                                (type == _VoucherType.percent && value > 100)) {
                              _toast('Please fill valid voucher details.');
                              return;
                            }
                            setState(() {
                              final v = _VoucherPromo(
                                code: code,
                                type: type,
                                value: value,
                                minSpend: min,
                                cap: cap,
                                usageLimit: limit,
                                used: existing?.used ?? 0,
                                start: start,
                                end: end,
                              );
                              if (existing == null) {
                                _vouchers.insert(0, v);
                              } else {
                                final i = _vouchers.indexOf(existing);
                                if (i >= 0) _vouchers[i] = v;
                              }
                            });
                            Navigator.of(context).pop();
                            _toast('Voucher saved (prototype).');
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    codeCtrl.dispose();
    valueCtrl.dispose();
    minCtrl.dispose();
    capCtrl.dispose();
    limitCtrl.dispose();
  }

  Future<void> _openShipEditor({_FreeShippingRule? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final minCtrl = TextEditingController(
      text: existing == null ? '500' : existing.minSpend.toStringAsFixed(0),
    );
    final capCtrl = TextEditingController(
      text: existing == null ? '0' : existing.cap.toStringAsFixed(0),
    );
    final areasCtrl = TextEditingController(text: existing?.areas ?? '');
    var start = existing?.start ?? DateTime.now();
    var end = existing?.end ?? DateTime.now().add(const Duration(days: 14));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _EditorSheet(
              title: existing == null
                  ? 'New Free Shipping Rule'
                  : 'Edit Free Shipping Rule',
              subtitle: 'Subsidize shipping with rules',
              child: Column(
                children: [
                  _Field(
                    label: 'Rule Name',
                    controller: nameCtrl,
                    hint: 'e.g. Free Ship over ₱1,000',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'Minimum Spend (₱)',
                          controller: minCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Field(
                          label: 'Shipping Cap (₱)',
                          controller: capCtrl,
                          keyboardType: TextInputType.number,
                          hint: '0 = no cap',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Field(
                    label: 'Areas',
                    controller: areasCtrl,
                    hint: 'e.g. NCR, Luzon',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DateButton(
                          label: 'Start',
                          value: _fmtDate(start),
                          onTap: () async {
                            final v = await _pickDateTime(context, start);
                            if (v == null) return;
                            setSheetState(() => start = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateButton(
                          label: 'End',
                          value: _fmtDate(end),
                          onTap: () async {
                            final v = await _pickDateTime(context, end);
                            if (v == null) return;
                            setSheetState(() => end = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: const Color(0xFF051014),
                          ),
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final min = double.tryParse(minCtrl.text.trim());
                            final cap = double.tryParse(capCtrl.text.trim()) ?? 0;
                            final areas = areasCtrl.text.trim();
                            if (name.isEmpty ||
                                min == null ||
                                min < 0 ||
                                areas.isEmpty ||
                                cap < 0) {
                              _toast('Please fill valid shipping rule details.');
                              return;
                            }
                            setState(() {
                              final s = _FreeShippingRule(
                                name: name,
                                minSpend: min,
                                cap: cap,
                                areas: areas,
                                start: start,
                                end: end,
                              );
                              if (existing == null) {
                                _shippingRules.insert(0, s);
                              } else {
                                final i = _shippingRules.indexOf(existing);
                                if (i >= 0) _shippingRules[i] = s;
                              }
                            });
                            Navigator.of(context).pop();
                            _toast('Shipping rule saved (prototype).');
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    nameCtrl.dispose();
    minCtrl.dispose();
    capCtrl.dispose();
    areasCtrl.dispose();
  }

  void _deleteFlash(_FlashSalePromo p) {
    setState(() => _flashSales.remove(p));
    _toast('Flash sale deleted (prototype).');
  }

  void _deleteVoucher(_VoucherPromo v) {
    setState(() => _vouchers.remove(v));
    _toast('Voucher deleted (prototype).');
  }

  void _deleteShip(_FreeShippingRule s) {
    setState(() => _shippingRules.remove(s));
    _toast('Shipping rule deleted (prototype).');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static String _fmtDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    final m = two(dt.month);
    final d = two(dt.day);
    final h = two(dt.hour);
    final min = two(dt.minute);
    return '${dt.year}-$m-$d  $h:$min';
  }

  Future<DateTime?> _pickDateTime(BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (date == null) return null;
    if (!context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    final t = time ?? TimeOfDay.fromDateTime(initial);
    return DateTime(date.year, date.month, date.day, t.hour, t.minute);
  }
}

class _PromoPanel extends StatelessWidget {
  const _PromoPanel({required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xECFFFFFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PromoList extends StatelessWidget {
  const _PromoList({required this.items, required this.emptyLabel});

  final List<Widget> items;
  final String emptyLabel;

  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x120B0F1A)),
        ),
        child: Text(
          emptyLabel,
          style: const TextStyle(
            color: _muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Column(children: items);
  }
}

class _PromoTile extends StatelessWidget {
  const _PromoTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final List<_SmallAction> actions;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x120B0F1A)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                trailing,
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: actions
                  .map(
                    (a) => OutlinedButton.icon(
                      onPressed: a.onTap,
                      icon: Icon(a.icon, size: 18),
                      label: Text(a.label),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: a.danger
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF0B0F1A),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallAction {
  const _SmallAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
}

class _EditorSheet extends StatelessWidget {
  const _EditorSheet({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);
  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(colors: [_accent, _accent2]),
                    ),
                    child: const Icon(
                      Icons.campaign_outlined,
                      color: Color(0xFF051014),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _text,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
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
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _muted),
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
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  static const _text = Color(0xFF0B0F1A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
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
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.label, required this.value, required this.onTap});
  final String label;
  final String value;
  final VoidCallback onTap;

  static const _text = Color(0xFF0B0F1A);
  static const _muted = Color(0xFF5B6378);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _text, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x120B0F1A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_outlined, color: _muted, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(color: _muted, fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: _muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryPillButton extends StatelessWidget {
  const _PrimaryPillButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _accent = Color(0xFF7CF4D1);
  static const _accent2 = Color(0xFF8BB6FF);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_accent, _accent2]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF051014),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _SecondaryPillButton extends StatelessWidget {
  const _SecondaryPillButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

enum _PromoStatus { active, upcoming, expired }

extension on _PromoStatus {
  String get label {
    switch (this) {
      case _PromoStatus.active:
        return 'Active';
      case _PromoStatus.upcoming:
        return 'Upcoming';
      case _PromoStatus.expired:
        return 'Expired';
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.kind});
  final String label;
  final _PromoStatus kind;

  static const _success = Color(0xFF4ADE80);
  static const _blue = Color(0xFF8BB6FF);
  static const _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final c = switch (kind) {
      _PromoStatus.active => _success,
      _PromoStatus.upcoming => _blue,
      _PromoStatus.expired => _danger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withValues(alpha: .35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

enum _VoucherType { percent, fixed }

class _FlashSalePromo {
  _FlashSalePromo({
    required this.title,
    required this.originalPrice,
    required this.salePrice,
    required this.stock,
    required this.start,
    required this.end,
    required this.description,
  });

  final String title;
  final double originalPrice;
  final double salePrice;
  final int stock;
  final DateTime start;
  final DateTime end;
  final String description;
}

class _VoucherPromo {
  _VoucherPromo({
    required this.code,
    required this.type,
    required this.value,
    required this.minSpend,
    required this.cap,
    required this.usageLimit,
    required this.used,
    required this.start,
    required this.end,
  });

  final String code;
  final _VoucherType type;
  final double value;
  final double minSpend;
  final double cap;
  final int usageLimit;
  final int used;
  final DateTime start;
  final DateTime end;

  bool get isUsedUp => used >= usageLimit;
}

class _FreeShippingRule {
  _FreeShippingRule({
    required this.name,
    required this.minSpend,
    required this.cap,
    required this.areas,
    required this.start,
    required this.end,
  });

  final String name;
  final double minSpend;
  final double cap;
  final String areas;
  final DateTime start;
  final DateTime end;
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

