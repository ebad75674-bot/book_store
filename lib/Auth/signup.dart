// screens/signup_screen.dart
import 'package:book_store/services/auth.dart';
import 'package:book_store/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_store/screens/homescreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final _fs = FirestoreService();

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _hidePass = true;
  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    _showMsg('Creating account...');

    try {
      final user = await _auth.createUser(_email.text, _password.text);

      // Save with UID as doc ID
      await _fs.saveUserProfile(
        uid: user.uid,
        name: _name.text,
        phone: _phone.text,
        address: _address.text,
        email: user.email!,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) _showMsg(e.toString(), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMsg(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          if (!error) const CircularProgressIndicator(color: Colors.white),
          if (!error) const SizedBox(width: 12),
          Expanded(child: Text(msg)),
        ]),
        backgroundColor: error ? Colors.red : null,
      ));
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 12, offset: const Offset(0, 10))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  const Text('Create Account', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 32),

                  _field(_name, 'Full Name', Icons.person_outline),
                  const SizedBox(height: 20),
                  _field(_phone, 'Phone', Icons.phone_outlined, keyboard: TextInputType.phone,
                      validator: (v) => v!.length < 10 ? 'Invalid phone' : null),
                  const SizedBox(height: 20),
                  _field(_address, 'Address', Icons.location_on_outlined, maxLines: 2),
                  const SizedBox(height: 20),
                  _field(_email, 'Email', Icons.email_outlined, keyboard: TextInputType.emailAddress,
                      validator: (v) => !v!.contains('@') ? 'Invalid email' : null),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: _password,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _hidePass = !_hidePass),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _loading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: validator ?? (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}