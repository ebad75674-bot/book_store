// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceAdmin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ADD BOOK WITH IMAGE URL (FREE & FAST)
  Future<void> addBook({
    required String title,
    required String author,
    required String genre,
    required String description,
    required double price,
    required String coverImageUrl, // ← Now takes URL string
  }) async {
    try {
      final bookRef = _db.collection('books').doc();
      final bookId = bookRef.id;

      await bookRef.set({
        'bookId': bookId,
        'title': title.trim(),
        'author': author.trim(),
        'genre': genre.trim(),
        'description': description.trim(),
        'price': price,
        'coverImage': coverImageUrl.trim(), // ← Direct URL saved
        'rating': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw 'Firestore Error: ${e.message}';
    } catch (e) {
      throw 'Failed to add book: $e';
    }
  }

  // REST OF METHODS UNCHANGED
  Stream<QuerySnapshot> getBooks() {
    return _db.collection('books').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getBooksByGenre(String genre) {
    return _db.collection('books')
        .where('genre', isEqualTo: genre)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  Future<void> updateBook({
  required String bookId,
  required String title,
  required String author,
  required String genre,
  required String description,
  required double price,
  required String coverImageUrl,
}) async {
  await _db.collection('books').doc(bookId).update({
    'title': title,
    'author': author,
    'genre': genre,
    'description': description,
    'price': price,
    'coverImage': coverImageUrl,
  });
}

Future<void> deleteBook(String bookId) async {
  await _db.collection('books').doc(bookId).delete();
}
}