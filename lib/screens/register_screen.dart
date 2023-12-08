// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final Function()? onPressed;
  const RegisterScreen({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // MARK: - Controllers.
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    void signUp() async {
      debugPrint('Email: ${emailController.text}');
      debugPrint('Password: ${passwordController.text}');
      debugPrint('Confirm Password: ${confirmPasswordController.text}');
      // MARK: - Get the AuthService instance.
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 1),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            // MARK: - Logo.
            const SizedBox(height: 20),
            Icon(
              Icons.message,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            // MARK: - Welcome Message.
            Text(
              'Welcome to Chat App',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // MARK: - Email TextField.
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // MARK: - Password TextField.
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // MARK: - Confirm Password TextField.
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // MARK: - Login Button.
            MyButton(
              title: 'Sign Up',
              onPressed: () {
                // MARK: - Dismiss the keyboard.
                FocusScope.of(context).unfocus();
                // MARK: - Validate the email and password.
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please fill in all fields.'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                } else if (passwordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Passwords do not match.'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
                // MARK: - Load the indicator.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Loading...'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                // MARK: - Call the signUp method.
                signUp();
              },
            ),
            // MARK: - Not Remember.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
