// screens/add_book_screen.dart

import 'package:book_store/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:book_store/theme/theme.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fs = FirestoreServiceAdmin();

  String? _title, _author, _genre, _description, _coverImageUrl;
  double? _price;
  bool _loading = false;

  final List<String> genres = [
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Fantasy',
    'Biography',
    'Self-Help',
    'History',
    'Poetry',
    'Thriller',
    'Other'
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if ((_coverImageUrl ?? '').isEmpty || !_coverImageUrl!.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid image URL (http/https)'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _fs.addBook(
        title: _title!,
        author: _author!,
        genre: _genre!,
        description: _description!,
        price: _price!,
        coverImageUrl: _coverImageUrl!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState!.reset();
      setState(() => _coverImageUrl = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IMAGE URL PREVIEW
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MyTheme.accentColor, width: 2),
                  color: MyTheme.backgroundColor,
                ),
                child:
                    _coverImageUrl != null && _coverImageUrl!.startsWith('http')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          _coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.link,
                            size: 50,
                            color: MyTheme.primaryColor,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Paste image URL below',
                            style: TextStyle(color: MyTheme.textColor),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              // IMAGE URL FIELD
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cover Image URL',
                  hintText: 'https://example.com/book-cover.jpg',
                ),
                keyboardType: TextInputType.url,
                onSaved: (v) => _coverImageUrl = v,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Image URL required';
                  if (!v.startsWith('http')) return 'Must be a valid URL';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (v) => _title = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                onSaved: (v) => _author = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Genre'),
                items: genres
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => _genre = v,
                validator: (v) => v == null ? 'Select genre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                onSaved: (v) => _description = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price (PKR)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _price = double.tryParse(v ?? '0'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Add Book to Store',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
