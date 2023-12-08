// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final Function()? onPressed;
  const LoginScreen({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // MARK: - Controllers.
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void signIn() async {
      debugPrint('Email: ${emailController.text}');
      debugPrint('Password: ${passwordController.text}');
      // MARK: - Get the AuthService instance.
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signInWithEmailAndPassword(
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
            const SizedBox(height: 20),
            // MARK: - Login Button.
            MyButton(
              title: 'Login',
              onPressed: () {
                // MARK: - Dismiss the keyboard.
                FocusScope.of(context).unfocus();
                // MARK: - Validate the email and password.
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please fill all fields.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                  return;
                }
                // MARK: - Load the indicator.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Loading...'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                // MARK: - Call the signIn method.
                signIn();
              },
            ),
            // MARK: - Not Remember.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not Remember?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Text(
                    'Sign Up',
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
