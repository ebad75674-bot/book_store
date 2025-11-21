// screens/login_screen.dart
import 'package:book_store/Auth/forget.dart';
import 'package:book_store/Auth/signup.dart';
import 'package:book_store/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:book_store/screens/homescreen.dart';
import 'package:book_store/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscurePass = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── LOGIN LOGIC (ONE-LINE) ─────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    _showSnack('Logging in...');

    try {
      await _auth.login(_emailCtrl.text, _passCtrl.text);

      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 300));

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(position: anim.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      if (mounted) _showSnack(e.toString(), error: true);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : MyTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: MyTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: MyTheme.accentColor.withOpacity(0.3), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.menu_book, size: 64, color: MyTheme.primaryColor),
                        const SizedBox(height: 16),
                        const Text('Welcome Back', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: MyTheme.textColor, letterSpacing: 0.5)),
                        const SizedBox(height: 8),
                        Text('Sign in to your account', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: MyTheme.textColor.withOpacity(0.7))),
                        const SizedBox(height: 32),

                        // EMAIL
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration('Email Address', 'Enter your email', Icons.email_outlined),
                          validator: (v) => v!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)
                              ? 'Enter a valid email' : null,
                        ),
                        const SizedBox(height: 20),

                        // PASSWORD
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscurePass,
                          decoration: _inputDecoration('Password', 'Enter your password', Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: MyTheme.primaryColor),
                              onPressed: () => setState(() => _obscurePass = !_obscurePass),
                            ),
                          ),
                          validator: (v) => v!.length < 6 ? 'Password must be 6+ chars' : null,
                        ),
                        const SizedBox(height: 16),

                        // FORGOT PASSWORD
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                            child: const Text('Forgot Password?', style: TextStyle(fontSize: 14, color: MyTheme.primaryColor)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // LOGIN BUTTON
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        const SizedBox(height: 20),

                        // SIGN UP LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don’t have an account? ', style: TextStyle(fontSize: 14, color: MyTheme.textColor)),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                              child: const Text('Sign Up', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MyTheme.primaryColor)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Input Decoration
  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: MyTheme.primaryColor),
      filled: true,
      fillColor: MyTheme.backgroundColor.withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: MyTheme.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }
}