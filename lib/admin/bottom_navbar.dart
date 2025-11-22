// widgets/bottom_navbar.dart
import 'package:book_store/admin/add_book_screen.dart';
import 'package:book_store/admin/books_screen.dart';
import 'package:book_store/admin/orders.dart';
import 'package:book_store/admin/users_screen.dart';
import 'package:book_store/theme/theme.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BooksScreen(),
    AddBookScreen(),
    UsersScreen(),
    AdminOrders(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: MyTheme.primaryColor,
        unselectedItemColor: MyTheme.dividerColor,
        backgroundColor: MyTheme.surfaceColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Book',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
