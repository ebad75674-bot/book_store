import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SColors {
  static const neon = Color(0xFF7C4DFF);
  static const neonAlt = Color(0xFFFF6B6B);
  static const glassFill = Color(0x18FFFFFF); // Mobile ke liye thoda kam blur
  static const softCard = Color(0xFF0F1724);
  static const background = Color(0xFF071028);
  static const accent = Color(0xFFFFB86B);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
}

// ======================= MOBILE ADMIN DASHBOARD =======================
class MobileAdminDashboard extends StatefulWidget {
  const MobileAdminDashboard({super.key});

  @override
  State<MobileAdminDashboard> createState() => _MobileAdminDashboardState();
}

class _MobileAdminDashboardState extends State<MobileAdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    ProductsTab(),
   
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          ['Dashboard', 'Products', 'Categories', 'Orders', 'Settings'][_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: SColors.textPrimary,
          ),
        ),
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: SColors.background.withOpacity(0.7)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: SColors.neon.withOpacity(0.2),
              child: const Icon(Icons.person, color: SColors.neon),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: SColors.neon,
              elevation: 8,
              child: const Icon(Icons.add, size: 28),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductScreen()),
              ),
            )
          : null,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: SColors.softCard.withOpacity(0.8),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: SColors.neon,
              unselectedItemColor: Colors.white70,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
                BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Cats'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= DASHBOARD TAB =======================
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome back, Admin 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SColors.textPrimary)),
          const SizedBox(height: 20),
          _StatsGrid(),
          const SizedBox(height: 24),
          const Text('Recent Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SColors.textPrimary)),
          const SizedBox(height: 12),
          const RecentBooksList(),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: const [
        _StatCard(title: 'Total Sales', value: '\$24.2k', change: '+12%', color: SColors.neon),
        _StatCard(title: 'Orders', value: '312', change: '+5%', color: SColors.accent),
        _StatCard(title: 'Products', value: '148', change: '+8%', color: Colors.cyan),
        _StatCard(title: 'Users', value: '2.4k', change: '+18%', color: Colors.pinkAccent),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, change;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.change, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SColors.textPrimary)),
          Row(
            children: [
              Icon(change.startsWith('+') ? Icons.trending_up : Icons.trending_down,
                  size: 16, color: change.startsWith('+') ? Colors.greenAccent : Colors.redAccent),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(color: change.startsWith('+') ? Colors.greenAccent : Colors.redAccent)),
            ],
          ),
        ],
      ),
    );
  }
}

class RecentBooksList extends StatelessWidget {
  const RecentBooksList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: SColors.neon));
        final docs = snapshot.data!.docs;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
          itemBuilder: (context, i) {
            final p = docs[i];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: p['imageUrl'] != null && p['imageUrl'].toString().isNotEmpty
                    ? Image.network(p['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                    : Container(color: SColors.neon.withOpacity(0.3), child: const Icon(Icons.book, color: Colors.white)),
              ),
              title: Text(p['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('\$${p['price']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailMobile(product: p))),
            );
          },
        );
      },
    );
  }
}

// ======================= ADD PRODUCT SCREEN =======================
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final priceC = TextEditingController();
  final descC = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl;
    if (_image != null) {
      final ref = FirebaseStorage.instance.ref().child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('products').add({
      'title': titleC.text,
      'price': double.parse(priceC.text),
      'description': descC.text,
      'imageUrl': imageUrl ?? '',
      'createdAt': Timestamp.now(),
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book Added Successfully!'), backgroundColor: SColors.neon));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Book'), backgroundColor: SColors.softCard),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: SColors.softCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: SColors.neon.withOpacity(0.5), width: 2),
                  ),
                  child: _image != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(_image!, fit: BoxFit.cover))
                      : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.add_a_photo, size: 48, color: SColors.neon),
                          SizedBox(height: 8),
                          Text('Tap to add cover', style: TextStyle(color: SColors.neon)),
                        ]),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(controller: titleC, decoration: _inputDec('Book Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: priceC, decoration: _inputDec('Price'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: descC, decoration: _inputDec('Description'), maxLines: 4),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save Book'),
                style: ElevatedButton.styleFrom(backgroundColor: SColors.neon, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: SColors.softCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: SColors.neon, width: 2)),
      );
}

// ======================= OTHER TABS (Products, Categories, etc.) =======================
class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});
  @override
  Widget build(BuildContext context) => const BookListScreen();
}

 
 

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings Coming Soon', style: TextStyle(fontSize: 18)));
}

// Bonus: Clean Book List Screen
class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: SColors.neon));
        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final p = docs[i];
            return Card(
              color: SColors.softCard,
              child: ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(p['imageUrl'] ?? '', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.book))),
                title: Text(p['title']),
                subtitle: Text('\$${p['price']}'),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => p.reference.delete()),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductDetailMobile extends StatelessWidget {
  final QueryDocumentSnapshot product;
  const ProductDetailMobile({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: SColors.softCard, title: Text(product['title'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (product['imageUrl'] != null && product['imageUrl'].toString().isNotEmpty)
              Image.network(product['imageUrl'], height: 300, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('\$${product['price']}', style: const TextStyle(fontSize: 20, color: SColors.neon)),
                  const SizedBox(height: 16),
                  Text(product['description'] ?? 'No description', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}