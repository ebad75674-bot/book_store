// screens/profile_screen.dart
import 'package:book_store/services/auth.dart';
import 'package:book_store/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_store/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  final _fs = FirestoreService();

  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _error = 'Not logged in.';
        return;
      }
      final data = await _fs.getUserData(user.uid);
      if (mounted) {
        setState(() {
          _userData = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _userData == null
                  ? const Center(child: Text('No profile found.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Profile Avatar
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: MyTheme.primaryColor.withOpacity(0.1),
                            child: Text(
                              _userData!['name'].toString().isNotEmpty
                                  ? _userData!['name'][0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Name Card
                          _infoCard(
                            icon: Icons.person,
                            label: 'Full Name',
                            value: _userData!['name'] ?? '—',
                          ),
                          const SizedBox(height: 16),

                          // Email Card
                          _infoCard(
                            icon: Icons.email,
                            label: 'Email',
                            value: _userData!['email'] ?? '—',
                          ),
                          const SizedBox(height: 16),

                          // Phone Card
                          _infoCard(
                            icon: Icons.phone,
                            label: 'Phone',
                            value: _userData!['phone'] ?? '—',
                          ),
                          const SizedBox(height: 16),

                          // Address Card
                          _infoCard(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: _userData!['address'] ?? '—',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 32),

                          // Logout Button
                          ElevatedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, size: 20),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: MyTheme.primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.textColor,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}