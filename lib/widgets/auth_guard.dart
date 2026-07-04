import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/routes.dart';
import '../providers/auth_provider.dart';

/// Wraps a screen and redirects to Login if the user isn't authenticated.
///
/// Use this on every route that should never be reachable without a
/// logged-in session — even if the user somehow navigates there directly
/// (deep link, typo'd route, future onGenerateRoute call, etc.).
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      });

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return child;
  }
}
