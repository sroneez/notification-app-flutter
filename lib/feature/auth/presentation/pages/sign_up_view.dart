import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView( // Add this so the keyboard doesn't overflow!
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Push it down a bit
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),

            // Connect to our existing AuthController
            GetBuilder<AuthController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  return ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final pass = _passwordController.text.trim();
                      final confirmPass = _confirmPasswordController.text.trim();

                      // Basic Validation
                      if (email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
                        Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      if (pass != confirmPass) {
                        Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      if (pass.length < 6) {
                        Get.snackbar('Error', 'Password must be at least 6 characters', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      // Call the method we already wrote!
                      controller.signUp(email, pass);
                    },
                    child: const Text('Sign Up'),
                  );
                }
            ),

            const SizedBox(height: 24),

            // A button to go back to the Login screen
            TextButton(
              onPressed: () {
                // Get.back() works perfectly here to pop this screen off the stack
                Get.back();
              },
              child: const Text('Already have an account? Login here.'),
            )
          ],
        ),
      ),
    );
  }
}