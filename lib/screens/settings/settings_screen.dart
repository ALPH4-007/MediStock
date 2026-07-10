import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return ListView(
            padding: const EdgeInsets.all(AppTheme.radius),
            children: [
              // ---------------------------------------------------------
              // Profile summary card
              // ---------------------------------------------------------
              InkWell(
                borderRadius: AppTheme.borderRadius,
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppTheme.borderRadius,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.primary,
                        child: auth.hasProfile
                            ? Text(
                                _initials(auth.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: auth.hasProfile
                              ? [
                                  Text(
                                    auth.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (auth.role.isNotEmpty)
                                    Text(
                                      auth.role,
                                      style: TextStyle(
                                          color: colorScheme.onSurfaceVariant),
                                    ),
                                  if (auth.pharmacy.isNotEmpty)
                                    Text(
                                      auth.pharmacy,
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ]
                              : const [
                                  Text(
                                    'Set up your profile',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text('Tap to add your name and pharmacy'),
                                ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------------------------------------------------------
              // Account section
              // ---------------------------------------------------------
              Text(
                'ACCOUNT',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: AppTheme.borderRadius,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      subtitle: Text(
                        auth.hasProfile ? auth.name : 'Not set up yet',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.local_pharmacy_outlined),
                      title: const Text('Pharmacy Info'),
                      subtitle: Text(
                        auth.pharmacy.isNotEmpty ? auth.pharmacy : 'Not set',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---------------------------------------------------------
              // Preferences section
              // ---------------------------------------------------------
              Text(
                'PREFERENCES',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: AppTheme.borderRadius,
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      subtitle: const Text('Expiry & stock alerts'),
                      value: auth.notificationsEnabled,
                      onChanged: (value) => auth.setNotificationsEnabled(value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Coming soon'),
                      value: false,
                      onChanged: null, // Disabled until ThemeProvider exists
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ---------------------------------------------------------
              // Logout
              // ---------------------------------------------------------
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadius,
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                onPressed: () async {
                  await authProvider.logout();

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
