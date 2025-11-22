// screens/books_screen.dart

import 'package:book_store/admin/update_book_screen.dart';
import 'package:book_store/services/admin_service.dart';
import 'package:book_store/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _fs = FirestoreServiceAdmin();
  String _selectedGenre = 'All';

  final List<String> genres = [
    'All', 'Fiction', 'Romance', 'Sci-Fi', 'Fantasy', 'Mystery',
    'Biography', 'Self-Help', 'History', 'Thriller', 'Poetry'
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Genre Filter
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: genres.length,
              itemBuilder: (ctx, i) {
                final genre = genres[i];
                final isSelected = _selectedGenre == genre;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(genre, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.white : MyTheme.primaryColor)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedGenre = genre),
                    selectedColor: MyTheme.primaryColor,
                    backgroundColor: MyTheme.accentColor.withOpacity(0.15),
                    shape: StadiumBorder(side: BorderSide(color: isSelected ? MyTheme.primaryColor : Colors.transparent, width: 2)),
                  ),
                );
              },
            ),
          ),

          // Books Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedGenre == 'All'
                  ? _fs.getBooks()
                  : _fs.getBooksByGenre(_selectedGenre),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final books = snapshot.data!.docs;

                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_outlined, size: 80, color: MyTheme.dividerColor),
                        const SizedBox(height: 16),
                        Text(
                          _selectedGenre == 'All'
                              ? 'No books added yet'
                              : 'No books in "$_selectedGenre"',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: MyTheme.textColor.withOpacity(0.7)),
                        ),
                        const SizedBox(height: 8),
                        Text('Tap + to add new books', style: TextStyle(color: MyTheme.textColor.withOpacity(0.6))),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: books.length,
                  itemBuilder: (ctx, i) {
                    final doc = books[i];
                    final data = doc.data() as Map<String, dynamic>;

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateBookScreen(bookId: doc.id, bookData: data),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cover Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: CachedNetworkImage(
                                imageUrl: data['coverImage'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(color: MyTheme.backgroundColor, child: const Center(child: CircularProgressIndicator())),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['title'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(data['author'], style: TextStyle(color: MyTheme.textColor.withOpacity(0.7)), maxLines: 1),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Rs. ${data['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyTheme.primaryColor)),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 16),
                                          Text(' ${data['rating'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    );
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