import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  List<Map<String, dynamic>> cartItems = [];

  void addToCart(Map<String, dynamic> book) {
    cartItems.add(book);
    notifyListeners();
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += double.parse(item['price'].replaceAll('\$', '').trim());
    }
    return total;
  }
}
