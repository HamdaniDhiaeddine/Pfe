import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/dashboard_drawer.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/anonyme.jpg'),
              radius: 15,
            ),
            onPressed: () {
              context.go('/dashboard/profile');
            },
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            title: 'My Profile',
            icon: Icons.person,
            onTap: () => context.go('/dashboard/profile'),
          ),
          _buildDashboardCard(
            title: 'Leave Requests',
            icon: Icons.beach_access,
            onTap: () => context.go('/dashboard/leave-requests'),
          ),
          _buildDashboardCard(
            title: 'Contracts',
            icon: Icons.description,
            onTap: () => context.go('/dashboard/contracts'),
          ),
          _buildDashboardCard(
            title: 'Attendance',
            icon: Icons.access_time,
            onTap: () => context.go('/dashboard/attendance'),
          ),
          if (user?.roles.contains('ROLE_ADMIN') ?? false) ...[
            _buildDashboardCard(
              title: 'Departments',
              icon: Icons.business,
              onTap: () => context.go('/dashboard/departments'),
            ),
            _buildDashboardCard(
              title: 'Employees',
              icon: Icons.people,
              onTap: () => context.go('/dashboard/employees'),
            ),
          ],
          _buildDashboardCard(
            title: 'Payslips',
            icon: Icons.receipt,
            onTap: () => context.go('/dashboard/payslips'),
          ),
          _buildDashboardCard(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () => context.go('/dashboard/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}