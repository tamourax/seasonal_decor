import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';


void main() {
  runApp(const CommerceLandingApp());
}

class CommerceLandingApp extends StatelessWidget {
  const CommerceLandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Souq Noor',
      
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _AppColors.brand,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: _AppColors.backgroundTop,
      ),
    home:  Scaffold(
      body: SeasonalDecor(
          text: "sssssssssssssssssssssssssssssssssss",
  showText: false,
          textAnimationDuration: const Duration(milliseconds: 1200),
          textStyle: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: _AppColors.accent,
            shadows: [
              Shadow(
                color: Color(0xAA000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          textAlignment: Alignment.center,
          textOpacity: 1,
          ramadanBuntingRows: 1,
          particleSpeedMultiplier: 1.2,
          preset: SeasonalPreset.ramadan(
          
          ),
          intensity: DecorIntensity.high,
          playDuration: const Duration(seconds: 8),
          opacity: 1,
          child: const RepaintBoundary(child: _LandingScreen()),
        ),
    ),
    );
  }
}

class _AppColors {
  static const backgroundTop = Color(0xFF0B1218);
  static const backgroundBottom = Color(0xFF111A24);
  static const surface = Color(0xFF1A2631);
  static const surfaceSoft = Color(0xFF223140);
  static const border = Color(0xFF314355);
  static const textPrimary = Color(0xFFE9F2FF);
  static const textSecondary = Color(0xFFB6C7DB);
  static const brand = Color(0xFF59C8C4);
  static const accent = Color(0xFFE6B96A);
  static const action = Color(0xFFB74B5A);
}

class _LandingScreen extends StatelessWidget {
  const _LandingScreen();

  static const List<_CategoryItem> _categories = [
    _CategoryItem(
      title: 'Dates',
      imageUrl:
          'https://images.unsplash.com/photo-1607228865305-fac6af2f7391?auto=format&fit=crop&w=800&q=80',
    ),
    _CategoryItem(
      title: 'Prayer Essentials',
      imageUrl:
          'https://images.unsplash.com/photo-1542816417-09836793f5b2?auto=format&fit=crop&w=800&q=80',
    ),
    _CategoryItem(
      title: 'Home Decor',
      imageUrl:
          'https://images.unsplash.com/photo-1493666438817-866a91353ca9?auto=format&fit=crop&w=800&q=80',
    ),
    _CategoryItem(
      title: 'Gifting',
      imageUrl:
          'https://images.unsplash.com/photo-1513885535751-8b9238bd345a?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  static const List<_ProductItem> _featuredProducts = [
    _ProductItem(
      name: 'Premium Ajwa Dates Box',
      price: '\$26.00',
      tag: 'Best Seller',
      imageUrl:
          'https://images.unsplash.com/photo-1615484477778-ca3b77940c25?auto=format&fit=crop&w=900&q=80',
    ),
    _ProductItem(
      name: 'Handcrafted Crescent Lantern',
      price: '\$48.00',
      tag: 'Limited',
      imageUrl:
          'https://images.unsplash.com/photo-1470259078422-826894b933aa?auto=format&fit=crop&w=900&q=80',
    ),
    _ProductItem(
      name: 'Prayer Mat Set',
      price: '\$34.00',
      tag: 'Top Rated',
      imageUrl:
          'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=900&q=80',
    ),
    _ProductItem(
      name: 'Ramadan Gift Hamper',
      price: '\$72.00',
      tag: 'Family Pack',
      imageUrl:
          'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?auto=format&fit=crop&w=900&q=80',
    ),
    _ProductItem(
      name: 'Arabic Coffee Collection',
      price: '\$29.00',
      tag: 'Fresh Roast',
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
    ),
    _ProductItem(
      name: 'Golden Serving Tray',
      price: '\$39.00',
      tag: 'New Arrival',
      imageUrl:
          'https://images.unsplash.com/photo-1590794056226-79ef3a8147e1?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxWidth = (size.width - 32).clamp(320.0, 1280.0).toDouble();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_AppColors.backgroundTop, _AppColors.backgroundBottom],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(),
                    const SizedBox(height: 24),
                    _heroSection(),
                    const SizedBox(height: 28),
                    _highlights(),
                    const SizedBox(height: 30),
                    _sectionTitle(
                      'Shop by Category',
                      'Curated picks for Ramadan',
                    ),
                    const SizedBox(height: 16),
                    _categoriesSection(),
                    const SizedBox(height: 32),
                    _sectionTitle(
                      'Featured Picks',
                      'Fast delivery and premium quality from trusted sellers',
                    ),
                    const SizedBox(height: 16),
                    _productsSection(),
                    const SizedBox(height: 32),
                    _promoBanner(),
                    const SizedBox(height: 30),
                    _newsletter(),
                    const SizedBox(height: 26),
                    const Divider(color: _AppColors.border),
                    const SizedBox(height: 16),
                    _footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          const navItems = ['Collections', 'Deals', 'Gift Packs', 'About'];

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: _BrandLogo()),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Shop Now'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _AppColors.action,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in navItems)
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: _AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              const _BrandLogo(),
              const Spacer(),
              for (final item in navItems)
                Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: _AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Shop Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: _AppColors.action,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _heroSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 1000;
          return SizedBox(
            height: compact ? 680 : 470,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const _NetworkImage(
                  url:
                      'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?auto=format&fit=crop&w=1600&q=80',
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xCC1C2024), Color(0x661C2024)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Ramadan Home Collection 2026',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'A premium landing layout for festive shopping moments.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Lantern decor, curated gifts, and family iftar bundles with same-day dispatch.',
                              style: TextStyle(
                                color: Color(0xFFF2EFE7),
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Align(
                              alignment: Alignment.center,
                              child: _HeroMiddleImage(compact: true),
                            ),
                            const Spacer(),
                            _flashOfferCard(width: 250),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ramadan Home Collection 2026',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'A premium landing layout for festive shopping moments.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      height: 1.15,
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'Lantern decor, curated gifts, and family iftar bundles with same-day dispatch.',
                                    style: TextStyle(
                                      color: Color(0xFFF2EFE7),
                                      fontSize: 17,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 26),
                            const _HeroMiddleImage(compact: false),
                            const SizedBox(width: 26),
                            _flashOfferCard(width: 220),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _flashOfferCard({required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _AppColors.surfaceSoft.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _AppColors.border),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flash Offer',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Up to 35% off',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: _AppColors.accent,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'On decor, tableware, and gift collections.',
            style: TextStyle(color: _AppColors.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _highlights() {
    final items = [
      ('24h', 'Express Delivery'),
      ('98%', 'Positive Reviews'),
      ('150+', 'Festive Products'),
      ('7 Days', 'Return Policy'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items
          .map(
            (item) => Container(
              width: 210,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.$1,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: _AppColors.brand,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      color: _AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: _AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 15, color: _AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _categoriesSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _categories
          .map(
            (item) => SizedBox(
              width: 286,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: _NetworkImage(
                        url: item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0x9A000000), Color(0x26000000)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _productsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1200
            ? 3
            : width >= 800
                ? 2
                : 1;
        final spacing = 16.0;
        final cardWidth = (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _featuredProducts
              .map(
                (product) => SizedBox(
                  width: cardWidth,
                  child: _ProductCard(product: product),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _promoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        color: const Color(0xFF143F52),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.35,
              child: const _NetworkImage(
                url:
                    'https://images.unsplash.com/photo-1513151233558-d860c5398176?auto=format&fit=crop&w=1600&q=80',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Family Iftar Bundle',
                          style: TextStyle(
                            color: Color(0xFFF3E8C9),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Set your table in one click. Save 22% this week.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF3C063),
                      foregroundColor: const Color(0xFF402B00),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Claim Offer',
                      style: TextStyle(fontWeight: FontWeight.w800),
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

  Widget _newsletter() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _AppColors.border),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const SizedBox(
            width: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Ramadan Drops and Flash Offers',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Subscribe to receive curated bundles and launch reminders each week.',
                  style: TextStyle(
                    color: _AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 320,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Email address',
                hintStyle: const TextStyle(color: _AppColors.textSecondary),
                filled: true,
                fillColor: _AppColors.surfaceSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: _AppColors.textPrimary),
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: _AppColors.action,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            ),
            child: const Text(
              'Subscribe',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return const Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        Text(
          'Souq Noor',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: _AppColors.textPrimary,
          ),
        ),
        Text('Terms', style: TextStyle(color: _AppColors.textSecondary)),
        Text('Privacy', style: TextStyle(color: _AppColors.textSecondary)),
        Text('Shipping', style: TextStyle(color: _AppColors.textSecondary)),
        Text('Support', style: TextStyle(color: _AppColors.textSecondary)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final _ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 1.35,
              child: _NetworkImage(url: product.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.tag,
                    style: const TextStyle(
                      color: _AppColors.brand,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: _AppColors.accent,
                      ),
                    ),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: _AppColors.brand,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
}

class _ProductItem {
  const _ProductItem({
    required this.name,
    required this.price,
    required this.tag,
    required this.imageUrl,
  });

  final String name;
  final String price;
  final String tag;
  final String imageUrl;
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, color: _AppColors.brand),
        SizedBox(width: 8),
        Text(
          'Souq Noor',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _HeroMiddleImage extends StatelessWidget {
  const _HeroMiddleImage({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 210.0 : 280.0;
    final height = compact ? 155.0 : 220.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: const [
            _NetworkImage(
              url:
                  'https://images.unsplash.com/photo-1519817914152-22f90e8fc093?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x22000000), Color(0x66000000)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: _AppColors.surfaceSoft,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: _AppColors.action),
          ),
        );
      },
    );
  }
}
