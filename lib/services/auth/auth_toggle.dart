import 'package:flutter/material.dart';

import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';

class AuthToggle extends StatefulWidget {
  const AuthToggle({super.key});

  @override
  State<AuthToggle> createState() => _AuthToggleState();
}

class _AuthToggleState extends State<AuthToggle> {
  bool showLoginScreen = true;

  void togglePages() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: showLoginScreen ? LoginScreen(onPressed: togglePages) : RegisterScreen(onPressed: togglePages),
      ),
    );
  }
}
