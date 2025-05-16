// import 'package:go_router/go_router.dart';
// import 'package:humaniq/features/employee/screens/chat_screen.dart';
// import 'package:humaniq/features/employee/screens/contracts_screen.dart';
// import 'package:humaniq/features/employee/screens/dashboard_screen.dart';
// import 'package:humaniq/features/employee/screens/department_screen.dart';
// import 'package:humaniq/features/employee/screens/directory_screen.dart';
// import 'package:humaniq/features/employee/screens/events_screen.dart';
// import 'package:humaniq/features/employee/screens/leave_request_screen.dart';
// import 'package:humaniq/features/auth/screens/login_screen.dart';
// import 'package:humaniq/features/employee/screens/notifications_screens.dart';
// import 'package:humaniq/features/employee/screens/payroll_screen.dart';
// import 'package:humaniq/features/employee/screens/profile_screen.dart';
// import 'package:humaniq/features/employee/screens/settings_screen.dart';
// import 'package:humaniq/shared/widgets/app_shell.dart';

// final router = GoRouter(
//   initialLocation: '/login',
//   routes: [
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//     ),
//     ShellRoute(
//       builder: (context, state, child) => AppShell(child: child),
//       routes: [
//         GoRoute(
//           path: '/dashboard',
//           builder: (context, state) => const DashboardScreen(),
//           routes: [
//             GoRoute(
//               path: 'profile',
//               builder: (context, state) => const ProfileScreen(),
//             ),
//             GoRoute(
//               path: 'departments',
//               builder: (context, state) => const DepartmentScreen(),
//             ),
//             GoRoute(
//               path: 'contracts',
//               builder: (context, state) => const ContractsScreen(),
//             ),
//             GoRoute(
//               path: 'events',
//               builder: (context, state) => const EventsScreen(),
//             ),
//             GoRoute(
//               path: 'leave-requests',
//               builder: (context, state) => const LeaveRequestScreen(),
//             ),
//             GoRoute(
//               path: 'payroll',
//               builder: (context, state) => const PayrollScreen(),
//             ),
//             GoRoute(
//               path: 'chat',
//               builder: (context, state) => const ChatScreen(),
//             ),
//             GoRoute(
//               path: 'directory',
//               builder: (context, state) => const DirectoryScreen(),
//             ),
//             GoRoute(
//               path: 'notifications',
//               builder: (context, state) => const NotificationsScreen(),
//             ),
//             GoRoute(
//               path: 'settings',
//               builder: (context, state) => const SettingsScreen(),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// );

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/employee/screens/chat_screen.dart';
import '../../features/employee/screens/department_screen.dart';
import '../../features/employee/screens/directory_screen.dart';
import '../../features/employee/screens/events_screen.dart';
import '../../features/employee/screens/payroll_screen.dart';
import '../../features/employee/screens/profile_screen.dart';
import '../../features/employee/screens/settings_screen.dart';
import '../../shared/widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/login',
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
          routes: [
            GoRoute(
              path: 'directory',
              builder: (context, state) => const DirectoryScreen(),
            ),
            GoRoute(
              path: 'departments',
              builder: (context, state) => const DepartmentScreen(),
            ),
            GoRoute(
              path: 'events',
              builder: (context, state) => const EventsScreen(),
            ),
            GoRoute(
              path: 'chat',
              builder: (context, state) => const ChatScreen(),
            ),
            GoRoute(
              path: 'payroll',
              builder: (context, state) => const PayrollScreen(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);