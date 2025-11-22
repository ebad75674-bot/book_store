// screens/users_screen.dart
import 'package:book_store/services/admin_service.dart';
import 'package:book_store/theme/theme.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  final _fs = FirestoreServiceAdmin();

   UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder(
        stream: _fs.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;
          if (users.isEmpty) return const Center(child: Text('No users registered yet.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (ctx, i) {
              final data = users[i].data() as Map<String, dynamic>;
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: MyTheme.primaryColor, child: Text(data['name'][0].toUpperCase(), style: const TextStyle(color: Colors.white))),
                  title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(data['email']),
                  trailing: Text(data['phone'] ?? 'No phone'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}