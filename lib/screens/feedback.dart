import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:book_store/theme/theme.dart';

class Feedbackpage extends StatefulWidget {
  const Feedbackpage({super.key});

  @override
  State<Feedbackpage> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<Feedbackpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;
  bool _isSubmitting = false;

  // Firebase Firestore reference
  final CollectionReference feedbackCollection = FirebaseFirestore.instance.collection('feedback');

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        // Save to Firestore
        await feedbackCollection.add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'feedback': _feedbackController.text.trim(),
          'rating': _rating,
          'timestamp': Timestamp.now(), // For sorting latest feedback
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Thank you for your feedback! 💌"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        setState(() => _rating = 0);
      } catch (e) {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error submitting feedback: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the code remains the same as your original
    return Scaffold(
      backgroundColor: MyTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Feedback"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: MyTheme.accentColor.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "We value your feedback ❤️",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🧑 Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 16),

                    // 📧 Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 💬 Feedback Field
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Your Feedback',
                        prefixIcon: const Icon(Icons.message_outlined),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your feedback'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // ⭐ Rating Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          icon: Icon(
                            starIndex <= _rating ? Icons.star : Icons.star_border,
                            color: MyTheme.primaryColor,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = starIndex.toDouble();
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // 🚀 Submit Button (Animated)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _isSubmitting
                            ? Colors.grey
                            : MyTheme.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: MyTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                "Submit Feedback",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}