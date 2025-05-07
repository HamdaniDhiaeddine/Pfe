import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humaniq/features/auth/providers/auth_provider.dart';

String? checkAuth(AuthProvider authProvider, GoRouterState state) {
  // Check if the user is authenticated and the token is valid
  if (!authProvider.isAuthenticated || authProvider.token == null) {
    // Redirect to login if the user is not authenticated
    if (state.uri.toString() != '/login') {
      return '/login';
    }
  }

  // Add role-based access control if needed
  if (state.uri.toString().startsWith('/admin') && authProvider.role != 'admin') {
    // Redirect non-admin users trying to access admin routes
    return '/dashboard';
  }

  return null; // Allow access to the route
}