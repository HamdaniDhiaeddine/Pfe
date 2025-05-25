import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/employee/screens/profile_screen.dart';
import '../../shared/widgets/app_shell.dart';
// ... other imports

final router = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true, // Enable debug logging
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/profile', // Add dedicated profile route
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);