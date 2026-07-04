import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // Run the auth check and the minimum splash delay together,
    // so loading shared_preferences doesn't add extra wait time.
    final authProvider = context.read<AuthProvider>();

    final results = await Future.wait([
      authProvider.loadLoginState(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    if (!mounted) return;

    final isLoggedIn = authProvider.isLoggedIn;

    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "MediStock",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
