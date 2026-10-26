import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import '../core/widgets/app_button.dart';
import '../presentation/kiosk/menu_template_config.dart';
import '../presentation/providers/cart_provider.dart';
import '../presentation/providers/menu_provider.dart';
import '../presentation/providers/template_provider.dart';
import 'demo_config.dart';

class _ScanItem {
  final String category;
  final String name;
  final String description;
  final double price;
  final Rect box; // normalised position on the sample photo
  final bool sizes;
  final String photo;

  const _ScanItem(
    this.category,
    this.name,
    this.description,
    this.price,
    this.box,
    this.photo, {
    this.sizes = false,
  });

  int get column => box.left < 0.5 ? 0 : 1;
  double get centerY => (box.top + box.bottom) / 2;
}

const _items = <_ScanItem>[
  _ScanItem('Coffee', 'Flat White', 'Double shot, velvety microfoam', 4.50,
      Rect.fromLTRB(0.0557, 0.300, 0.4943, 0.368), 'demo/menu/flatwhite.jpg', sizes: true),
  _ScanItem('Coffee', 'Cappuccino', 'Espresso, steamed milk, thick foam', 4.50,
      Rect.fromLTRB(0.0557, 0.374, 0.4943, 0.442), 'demo/menu/cappuccino.jpg', sizes: true),
  _ScanItem('Coffee', 'Long Black', 'Double espresso over hot water', 3.80,
      Rect.fromLTRB(0.0557, 0.448, 0.4943, 0.516), 'demo/menu/americano.jpg', sizes: true),
  _ScanItem('Coffee', 'Iced Latte', 'Espresso, cold milk, ice', 5.00,
      Rect.fromLTRB(0.0557, 0.522, 0.4943, 0.590), 'demo/menu/latte.jpg', sizes: true),
  _ScanItem('Tea', 'Chai Latte', 'Spiced black tea, steamed milk', 4.80,
      Rect.fromLTRB(0.0557, 0.668, 0.4943, 0.736), 'demo/menu/hotchoc.jpg', sizes: true),
  _ScanItem('Tea', 'Matcha Latte', 'Ceremonial matcha, steamed milk', 5.20,
      Rect.fromLTRB(0.0557, 0.742, 0.4943, 0.810), 'demo/menu/matcha.jpg', sizes: true),
  _ScanItem('Tea', 'Hot Chocolate', 'Dark chocolate, steamed milk', 4.60,
      Rect.fromLTRB(0.0557, 0.816, 0.4943, 0.884), 'demo/menu/hotchoc.jpg', sizes: true),
  _ScanItem('Meals', 'Avocado Toast', 'Sourdough, lemon, chilli flakes', 12.50,
      Rect.fromLTRB(0.5343, 0.300, 0.9443, 0.368), 'demo/menu/avocado.jpg'),
  _ScanItem('Meals', 'Smashed Eggs', 'Herbed eggs on grilled sourdough', 14.00,
      Rect.fromLTRB(0.5343, 0.374, 0.9443, 0.442), 'demo/menu/avocado.jpg'),
  _ScanItem('Meals', 'Granola Bowl', 'Greek yoghurt, berries, honey', 10.50,
      Rect.fromLTRB(0.5343, 0.448, 0.9443, 0.516), 'demo/menu/muffin.jpg'),
  _ScanItem('Desserts', 'Butter Croissant', 'Baked fresh every morning', 4.20,
      Rect.fromLTRB(0.5343, 0.594, 0.9443, 0.662), 'demo/menu/croissant.jpg'),
  _ScanItem('Desserts', 'Blueberry Muffin', 'Baked in-house', 4.50,
      Rect.fromLTRB(0.5343, 0.668, 0.9443, 0.736), 'demo/menu/muffin.jpg'),
  _ScanItem('Desserts', 'Banana Bread', 'Toasted, with butter', 5.00,
      Rect.fromLTRB(0.5343, 0.742, 0.9443, 0.810), 'demo/menu/muffin.jpg'),
];

const _col0Share = 0.54; // portion of the scan spent on the left column
const _scanTop = 0.26;
const _scanBottom = 0.90;
const _columnX = [Rect.fromLTRB(0.04, 0, 0.50, 0), Rect.fromLTRB(0.52, 0, 0.96, 0)];

enum _Phase { idle, scanning, review, imported }

/// Browser-demo version of the app's AI menu import.
///
/// The photo is a sample and the extraction is scripted; the imported items go
/// through the same MenuNotifier.importUserProducts() the onboarding flow uses.
class MenuScanDemoScreen extends ConsumerStatefulWidget {
  const MenuScanDemoScreen({super.key});

  @override
  ConsumerState<MenuScanDemoScreen> createState() => _MenuScanDemoScreenState();
}

class _MenuScanDemoScreenState extends ConsumerState<MenuScanDemoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        setState(() => _phase = _Phase.review);
      }
    });
  final _listController = ScrollController();
  _Phase _phase = _Phase.idle;

  @override
  void dispose() {
    _scan.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() => _phase = _Phase.scanning);
    _scan.forward(from: 0);
  }

  void _reset() {
    _scan.stop();
    _scan.value = 0;
    setState(() => _phase = _Phase.idle);
  }

  ({int column, double y}) _beam(double p) {
    if (p < _col0Share) {
      final t = p / _col0Share;
      return (column: 0, y: _scanTop + t * (_scanBottom - _scanTop));
    }
    final t = (p - _col0Share) / (1 - _col0Share);
    return (column: 1, y: _scanTop + t * (_scanBottom - _scanTop));
  }

  bool _revealed(_ScanItem item, double p) {
    if (_phase == _Phase.review || _phase == _Phase.imported) return true;
    final beam = _beam(p);
    if (item.column < beam.column) return true;
    return item.column == beam.column && item.centerY <= beam.y;
  }

  List<Map<String, dynamic>> _payload() {
    return [
      for (final i in _items)
        {
          'name': i.name,
          'description': i.description,
          'price': i.price,
          'category': i.category,
          'imageUrl': DemoConfig.assetUrl(i.photo),
          if (i.sizes)
            'modifierGroups': [
              {
                'groupName': 'Size',
                'required': true,
                'minSelection': 1,
                'maxSelection': 1,
                'options': [
                  {'name': 'Small', 'price': 0.0},
                  {'name': 'Medium', 'price': 0.5},
                  {'name': 'Large', 'price': 1.0},
                ],
              },
            ],
        },
    ];
  }

  void _import() {
    ref.read(cartProvider.notifier).clear();
    ref.read(menuProvider.notifier).importUserProducts(_payload());
    setState(() => _phase = _Phase.imported);
  }

  void _openKiosk() {
    final template =
        ref.read(selectedTemplateProvider) ??
        MenuDisplayTemplate.categorySidebar;
    context.go('/menu', extra: template);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 7, child: _photoCard()),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 5, child: _resultsCard()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray300)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.document_scanner_outlined,
                color: AppColors.blue),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Import a menu from a photo',
                  style: AppTypography.h3.copyWith(fontSize: 20)),
              Text('Merchant setup · menu scan',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.gray600)),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text('Simulated extraction',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFFB36B00),
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }

  Widget _photoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.image_outlined,
                  size: 18, color: AppColors.gray600),
              const SizedBox(width: 8),
              Text('sample-menu.jpg',
                  style: AppTypography.bodySmall
                      .copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Sample photo',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.gray600)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: AnimatedBuilder(
              animation: _scan,
              builder: (context, _) {
                final p = _scan.value;
                final shown = _items
                    .where((i) => _phase != _Phase.idle && _revealed(i, p))
                    .toList();
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LayoutBuilder(
                              builder: (context, c) => _photoStack(c.biggest),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _stat(Icons.restaurant_menu, 'Items', shown.length),
                        _stat(Icons.sell_outlined, 'Prices', shown.length),
                        _stat(Icons.category_outlined, 'Categories',
                            shown.map((i) => i.category).toSet().length),
                        _stat(Icons.tune, 'Size options',
                            shown.where((i) => i.sizes).length),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String label, int value) {
    final on = value > 0;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: on ? AppColors.blue.withOpacity(0.07) : AppColors.gray50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: on ? AppColors.blue : AppColors.gray400),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$value',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: on ? AppColors.black : AppColors.gray400,
                      )),
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.gray600, fontSize: 10.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoStack(Size size) {
    final p = _scan.value;
    final beam = _beam(p);
    final scanning = _phase == _Phase.scanning;
    final col = _columnX[beam.column];
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          DemoConfig.assetUrl('demo/sample_menu.jpg'),
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => Container(color: AppColors.gray100),
        ),
        for (final item in _items)
          if (_phase != _Phase.idle && _revealed(item, p))
            Positioned(
              left: item.box.left * size.width,
              top: item.box.top * size.height,
              width: item.box.width * size.width,
              height: item.box.height * size.height,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 280),
                builder: (_, v, __) => Opacity(
                  opacity: v,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.09),
                      border: Border.all(color: AppColors.blue, width: 1.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
        if (scanning)
          Positioned(
            left: col.left * size.width,
            width: (col.right - col.left) * size.width,
            top: beam.y * size.height - 54,
            height: 56,
            child: IgnorePointer(
              child: Column(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.blue.withOpacity(0),
                            AppColors.blue.withOpacity(0.22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.8),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _resultsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: AnimatedBuilder(
        animation: _scan,
        builder: (context, _) {
          final p = _scan.value;
          final shown =
              _items.where((i) => _phase != _Phase.idle && _revealed(i, p));
          final count = shown.length;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_listController.hasClients && _phase == _Phase.scanning) {
              _listController.jumpTo(_listController.position.maxScrollExtent);
            }
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Detected items',
                      style: AppTypography.h4.copyWith(fontSize: 17)),
                  const Spacer(),
                  if (_phase != _Phase.idle)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('$count / ${_items.length}',
                          style: AppTypography.caption
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _phase == _Phase.idle
                      ? 0
                      : (_phase == _Phase.scanning ? p : 1),
                  minHeight: 4,
                  backgroundColor: AppColors.gray200,
                  color: _phase == _Phase.imported
                      ? AppColors.success
                      : AppColors.blue,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: _phase == _Phase.idle
                    ? _emptyState()
                    : _itemList(shown.toList()),
              ),
              const SizedBox(height: AppSpacing.sm),
              _actions(),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Simulated here on a sample photo. In the app, the optional scan sends the photo to Google Gemini and needs an API key.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.gray500,
                  fontSize: 11,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.blue),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Turn a paper menu into products',
              style: AppTypography.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            'Names, prices, categories and size options are read from the photo, ready to review.',
            textAlign: TextAlign.center,
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _itemList(List<_ScanItem> shown) {
    final children = <Widget>[];
    String? last;
    for (final item in shown) {
      if (item.category != last) {
        last = item.category;
        children.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(item.category.toUpperCase(),
              style: AppTypography.caption.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              )),
        ));
      }
      children.add(_ItemRow(key: ValueKey(item.name), item: item));
    }
    return ListView(controller: _listController, children: children);
  }

  Widget _actions() {
    switch (_phase) {
      case _Phase.idle:
        return AppButton(
          label: 'Scan menu photo',
          icon: Icons.document_scanner_outlined,
          size: AppButtonSize.large,
          fullWidth: true,
          onPressed: _start,
        );
      case _Phase.scanning:
        return const AppButton(
          label: 'Reading menu…',
          size: AppButtonSize.large,
          fullWidth: true,
          isLoading: true,
          onPressed: null,
        );
      case _Phase.review:
        return Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Scan again',
                variant: AppButtonVariant.outline,
                size: AppButtonSize.large,
                fullWidth: true,
                onPressed: _reset,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: AppButton(
                label: 'Import ${_items.length} items',
                icon: Icons.check,
                size: AppButtonSize.large,
                fullWidth: true,
                onPressed: _import,
              ),
            ),
          ],
        );
      case _Phase.imported:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_items.length} items in 4 categories added to the menu',
                    style: AppTypography.bodySmall
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Rescan',
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.large,
                    fullWidth: true,
                    onPressed: _reset,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'Open in kiosk',
                    icon: Icons.arrow_forward,
                    size: AppButtonSize.large,
                    fullWidth: true,
                    onPressed: _openKiosk,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.gray200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

class _ItemRow extends StatelessWidget {
  final _ScanItem item;

  const _ItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 10 * (1 - v)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: AppTypography.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.gray600, fontSize: 11.5)),
                ],
              ),
            ),
            if (item.sizes)
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('3 sizes',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                    )),
              ),
            Text('\$${item.price.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
