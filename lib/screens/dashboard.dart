// Full-featured Stylish Admin Dashboard
// Combines: Glassmorphism, Dark Neon accents, Soft (Neumorphic) cards,
// Material 3, Sidebar Layout, Page Transitions, Hero Animations
// Single-file Flutter example for an e-commerce bookstore admin panel.

import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


// --------------------------- Theme Constants ---------------------------
class SColors {
  static const neon = Color(0xFF7C4DFF);
  static const neonAlt = Color(0xFFFF6B6B);
  static const glassFill = Color(0x22FFFFFF);
  static const softCard = Color(0xFF0F1724);
  static const background = Color(0xFF071028);
  static const accent = Color(0xFFFFB86B);
}

// --------------------------- Admin Home (Sidebar Layout) ---------------------------
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _controller;

  final List<Widget> _pages = [
    const DashboardPage(),
    const ProductsPage(),
    const CategoriesPage(),
    const OrdersPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelect(int idx) {
    setState(() => _selectedIndex = idx);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SColors.background.withOpacity(0.9),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 12,
                  offset: const Offset(6, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // logo + title
                Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [SColors.neon, SColors.neonAlt],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: SColors.neon.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.book, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'E Book Store',
                        style: TextStyle(
                          fontSize: 16,color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // navigation
                Expanded(
                  child: ListView(
                    children: [
                      _NavItem(
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        index: 0,
                        selectedIndex: _selectedIndex,
                        onTap: _onSelect,
                      ),
                      _NavItem(
                        icon: Icons.book,
                        label: 'Products',
                        index: 1,
                        selectedIndex: _selectedIndex,
                        onTap: _onSelect,
                      ),
                      _NavItem(
                        icon: Icons.category,
                        label: 'Categories',
                        index: 2,
                        selectedIndex: _selectedIndex,
                        onTap: _onSelect,
                      ),
                      _NavItem(
                        icon: Icons.shopping_bag,
                        label: 'Orders',
                        index: 3,
                        selectedIndex: _selectedIndex,
                        onTap: _onSelect,
                      ),
                      _NavItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        index: 4,
                        selectedIndex: _selectedIndex,
                        onTap: _onSelect,
                      ),
                    ],
                  ),
                ),

                // footer quick actions (glass)
                GestureDetector(
                  onTap: () => _onSelect(1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: SColors.glassFill,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Add new Book',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main content (animated crossfade between pages)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeInOut,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = index == selectedIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: active ? SColors.glassFill : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: SColors.neon.withOpacity(0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: active ? SColors.neon : Colors.white70),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(color: active ? Colors.white : Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- Pages ---------------------------

// 1) Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('dashboard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _SearchBar(),
                const SizedBox(width: 12),
                _ProfileAvatar(),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // KPI cards
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SizedBox(width: 6),
              KPIcard(title: 'Total Sales', value: '\$24.2k', change: '+8%'),
              SizedBox(width: 12),
              KPIcard(title: 'Orders', value: '312', change: '-2%'),
              SizedBox(width: 12),
              KPIcard(title: 'Products', value: '148', change: '+5%'),
              SizedBox(width: 12),
              KPIcard(title: 'Visitors', value: '12.8k', change: '+12%'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Recent products preview
        const Text(
          'Recent Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Expanded(child: RecentProductsGrid()),
      ],
    );
  }
}

class KPIcard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  const KPIcard({
    required this.title,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SColors.glassFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    change.startsWith('-')
                        ? Icons.trending_down
                        : Icons.trending_up,
                    color: change.startsWith('-')
                        ? Colors.redAccent
                        : Colors.greenAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(change, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: SColors.softCard,
          hintText: 'Search products, orders...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'admin-avatar',
      child: CircleAvatar(
        radius: 22,
        backgroundColor: SColors.neon.withOpacity(0.18),
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}

// Recent Products Grid (network images + hero)
class RecentProductsGrid extends StatelessWidget {
  const RecentProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final products = FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .limit(6);

    return StreamBuilder<QuerySnapshot>(
      stream: products.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.74,
          ),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final p = docs[i];
            final img = (p['imageUrl'] ?? '') as String;
            return GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(_fadePageRoute(ProductDetailPage(product: p))),
              child: ProductCardSmall(
                id: p.id,
                title: p['title'],
                price: p['price'].toString(),
                imageUrl: img,
              ),
            );
          },
        );
      },
    );
  }
}

class ProductCardSmall extends StatelessWidget {
  final String id, title, price, imageUrl;
  const ProductCardSmall({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: SColors.glassFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: 'product-$id',
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.book, size: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(
                      '\\${price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2) Products Page - Full management UI
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final CollectionReference products = FirebaseFirestore.instance.collection(
    'products',
  );
  final TextEditingController titleC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController descC = TextEditingController();
  final TextEditingController urlC = TextEditingController();
  File? _picked;

  Future<void> _pick() async {
    final p = ImagePicker();
    final f = await p.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => _picked = File(f.path));
  }

  Future<String?> _uploadImage() async {
    if (_picked == null) return null;
    final ref = FirebaseStorage.instance.ref().child(
      'products/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(_picked!);
    return ref.getDownloadURL();
  }

  Future<void> _add() async {
    final img = urlC.text.trim().isNotEmpty
        ? urlC.text.trim()
        : await _uploadImage();
    await products.add({
      'title': titleC.text,
      'price': double.tryParse(priceC.text) ?? 0.0,
      'description': descC.text,
      'imageUrl': img ?? '',
      'createdAt': Timestamp.now(),
    });
    titleC.clear();
    priceC.clear();
    descC.clear();
    urlC.clear();
    setState(() => _picked = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('products'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SColors.glassFill,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: titleC,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: priceC,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descC,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: urlC,
                            decoration: const InputDecoration(
                              labelText: 'Image URL (optional)',
                            ),
                          ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pick,
                                icon: const Icon(Icons.photo),
                                label: const Text('Pick'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _add,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Product'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SColors.accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (_picked != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_picked!, height: 56),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: products
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final p = docs[i];
                    return ProductCardLarge(product: p);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCardLarge extends StatelessWidget {
  final QueryDocumentSnapshot product;
  const ProductCardLarge({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final id = product.id;
    final img = (product['imageUrl'] ?? '') as String;
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(_fadePageRoute(ProductDetailPage(product: product))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: SColors.softCard,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: 'product-$id',
                  child: img.isNotEmpty
                      ? Image.network(
                          img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Icon(Icons.menu_book),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\\${product['price']}'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(product.id)
                                  .delete(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Product detail page with hero animation
class ProductDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot product;
  const ProductDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final id = product.id;
    final img = (product['imageUrl'] ?? '') as String;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 800,
              height: 600,
              decoration: BoxDecoration(
                color: SColors.glassFill,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'product-$id',
                      child: img.isNotEmpty
                          ? Image.network(
                              img,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Icon(Icons.menu_book, size: 80),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\\${product['price']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(product['description'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 3) Categories Page
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = FirebaseFirestore.instance.collection('categories');
    final controller = TextEditingController();

    return Column(
      key: const ValueKey('categories'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'New category'),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  await cats.add({
                    'name': controller.text.trim(),
                    'createdAt': Timestamp.now(),
                  });
                  controller.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: cats.snapshots(),
            builder: (context, snap) {
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());
              final docs = snap.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (c, i) {
                  final d = docs[i];
                  return ListTile(
                    title: Text(d['name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => cats.doc(d.id).delete(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// 4) Orders Page
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = FirebaseFirestore.instance.collection('orders');
    return Column(
      key: const ValueKey('orders'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orders',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: orders.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snap) {
              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());
              final docs = snap.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (c, i) {
                  final d = docs[i];
                  return Card(
                    child: ListTile(
                      title: Text('Order ${d.id}'),
                      subtitle: Text('Total: \$${d['total']}'),
                      trailing: DropdownButton(
                        value: d['status'],
                        items: ['Pending', 'Shipped', 'Delivered']
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            orders.doc(d.id).update({'status': v}),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// 5) Settings Page (placeholder)
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings (Coming soon...)'));
  }
}

// --------------------------- Utilities ---------------------------

PageRouteBuilder _fadePageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, a, b) => page,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, anim, secAnim, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(anim),
          child: child,
        ),
      );
    },
  );
}

// End of file
