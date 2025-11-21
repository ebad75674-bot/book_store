import 'package:book_store/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:book_store/Auth/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// 👈 import your custom theme

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Wait for 5 seconds, then navigate to Login
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.backgroundColor, // 🌼 Light cream background
      body: Stack(
        children: [
          // 🌤️ Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF8E1), // Light cream
                  Color(0xFFD7CCC8), // Warm beige
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🪶 Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🧡 App logo
                Hero(
                  tag: 'appLogo',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Added border radius for rounded corners
                      border: Border.all(
                        color: MyTheme.primaryColor, // Border color (you can change this)
                        width: 3, // Border width
                      ),
                      color: MyTheme.accentColor.withOpacity(0.4),
                      boxShadow: [
                        BoxShadow(
                          color: MyTheme.primaryColor.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Clip the image to match the container's border radius
                      child: Image.asset(
                        'lib/assets/logo.png',
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover, // Ensure the image fits nicely within the rounded container
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 🏷️ App name
                const Text(
                  'BOOK STORE',
                  style: TextStyle(
                    color: MyTheme.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),

                // ✨ Animated loading widget (uses theme color)
                LoadingAnimationWidget.inkDrop(
                  color: MyTheme.primaryColor,
                  size: 60,
                ),
                const SizedBox(height: 20),

                // 📖 Loading text
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: MyTheme.textColor.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}