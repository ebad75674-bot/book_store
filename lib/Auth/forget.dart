// screens/forgot_password_screen.dart
import 'package:book_store/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:book_store/theme/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await _auth.sendPasswordResetEmail(_emailCtrl.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent! Check your inbox.'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyTheme.backgroundColor, MyTheme.accentColor.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: MyTheme.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: MyTheme.accentColor.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.lock_reset, size: 64, color: MyTheme.primaryColor),
                      const SizedBox(height: 16),
                      const Text('Reset Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: MyTheme.textColor)),
                      const SizedBox(height: 8),
                      Text('Enter your email to receive a reset link', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: MyTheme.textColor.withOpacity(0.7))),
                      const SizedBox(height: 32),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined, color: MyTheme.primaryColor),
                          filled: true,
                          fillColor: MyTheme.backgroundColor.withOpacity(0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
                          ),
                        ),
                        validator: (v) => !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!) ? 'Enter valid email' : null,
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: _loading ? null : _sendReset,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _loading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Send Reset Link', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}