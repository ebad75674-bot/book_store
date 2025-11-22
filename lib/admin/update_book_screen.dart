// screens/update_book_screen.dart
import 'package:book_store/services/admin_service.dart';
import 'package:book_store/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateBookScreen extends StatefulWidget {
  final String bookId;
  final Map<String, dynamic> bookData;

  const UpdateBookScreen({super.key, required this.bookId, required this.bookData});

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fs = FirestoreServiceAdmin();

  late TextEditingController _titleCtrl;
  late TextEditingController _authorCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imageCtrl;
  String? _selectedGenre;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.bookData['title']);
    _authorCtrl = TextEditingController(text: widget.bookData['author']);
    _priceCtrl = TextEditingController(text: widget.bookData['price'].toString());
    _descCtrl = TextEditingController(text: widget.bookData['description']);
    _imageCtrl = TextEditingController(text: widget.bookData['coverImage']);
    _selectedGenre = widget.bookData['genre'];
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await _fs.updateBook(
        bookId: widget.bookId,
        title: _titleCtrl.text,
        author: _authorCtrl.text,
        genre: _selectedGenre!,
        description: _descCtrl.text,
        price: double.parse(_priceCtrl.text),
        coverImageUrl: _imageCtrl.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book updated!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book?'),
        content: Text('Delete "${widget.bookData['title']}" permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _fs.deleteBook(widget.bookId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Book deleted!'), backgroundColor: Colors.red));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Book'),
        actions: [
          IconButton(icon: const Icon(Icons.delete_forever, color: Colors.red), onPressed: _delete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(imageUrl: _imageCtrl.text, height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              TextFormField(controller: _imageCtrl, decoration: const InputDecoration(labelText: 'Image URL'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _authorCtrl, decoration: const InputDecoration(labelText: 'Author'), validator: (v) => v!.isEmpty ? 'Required' : null),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                items: ['Fiction','Romance','Sci-Fi','Fantasy','Mystery','Biography','Self-Help','History','Thriller','Poetry']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGenre = v),
                decoration: const InputDecoration(labelText: 'Genre'),
              ),
              TextFormField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
              TextFormField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: _loading ? null : _update, child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Update Book')),
            ],
          ),
        ),
      ),
    );
  }
}