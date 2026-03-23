import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_route.dart';
import '../../data/repositories/firebase_auth_repo_impl.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome Back')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 32),

            GetBuilder<AuthController>(
                // init: AuthController(FirebaseAuthRepoImpl()),
                builder: (controller) {
                  // If the controller says it's loading, show the spinner
                  if (controller.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  // Otherwise, show the login button
                  return ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final pass = _passwordController.text.trim();
                      if (email.isNotEmpty && pass.isNotEmpty) {
                        controller.login(email, pass);
                      } else {
                        Get.snackbar('Error', 'Please fill in all fields');
                      }
                    },
                    child: const Text('Login'),
                  );
                }
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.signup);
              },
              child: const Text('Don\'t have an account? Sign up.'),
            )
          ],
        ),
      ),
    );
  }
}