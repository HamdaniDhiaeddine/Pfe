import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/dashboard_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isLargeScreen = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications),
            ),
            onPressed: () => context.go('/dashboard/notifications'),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: CircleAvatar(backgroundImage: user?.profileImagePath != null 
                ? NetworkImage(user!.profileImagePath!)
                : const AssetImage('assets/img/anonyme.jpg') as ImageProvider,
            ),
            onPressed: () => context.go('/profile'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Welcome back, ${user?.fullName ?? "Admin"}!',
            //   style: Theme.of(context).textTheme.headlineSmall,
            // ),
            // const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: _getGridCount(context),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                // System Management
                _buildDashboardCard(
                  title: 'Users Management',
                  icon: Icons.people,
                  onTap: () => context.go('/dashboard/users'),
                  backgroundColor: Colors.blue.shade50,
                  iconColor: Colors.blue,
                ),
                _buildDashboardCard(
                  title: 'Departments',
                  icon: Icons.business,
                  onTap: () => context.go('/dashboard/departments'),
                  backgroundColor: Colors.green.shade50,
                  iconColor: Colors.green,
                ),
                _buildDashboardCard(
                  title: 'Roles & Permissions',
                  icon: Icons.security,
                  onTap: () => context.go('/dashboard/roles'),
                  backgroundColor: Colors.purple.shade50,
                  iconColor: Colors.purple,
                ),
                _buildDashboardCard(
                  title: 'System Settings',
                  icon: Icons.settings,
                  onTap: () => context.go('/dashboard/settings'),
                  backgroundColor: Colors.grey.shade100,
                  iconColor: Colors.grey.shade700,
                ),

                // HR Management
                _buildDashboardCard(
                  title: 'Leave Requests',
                  icon: Icons.beach_access,
                  onTap: () => context.go('/dashboard/leave-requests'),
                  backgroundColor: Colors.orange.shade50,
                  iconColor: Colors.orange,
                  badge: '5',
                ),
                _buildDashboardCard(
                  title: 'Attendance',
                  icon: Icons.access_time,
                  onTap: () => context.go('/dashboard/attendance'),
                  backgroundColor: Colors.teal.shade50,
                  iconColor: Colors.teal,
                ),
                _buildDashboardCard(
                  title: 'Payroll',
                  icon: Icons.payment,
                  onTap: () => context.go('/dashboard/payroll'),
                  backgroundColor: Colors.indigo.shade50,
                  iconColor: Colors.indigo,
                ),
                _buildDashboardCard(
                  title: 'Contracts',
                  icon: Icons.description,
                  onTap: () => context.go('/dashboard/contracts'),
                  backgroundColor: Colors.brown.shade50,
                  iconColor: Colors.brown,
                ),

                // Communication
                _buildDashboardCard(
                  title: 'Announcements',
                  icon: Icons.campaign,
                  onTap: () => context.go('/dashboard/announcements'),
                  backgroundColor: Colors.red.shade50,
                  iconColor: Colors.red,
                  badge: '2',
                ),
                _buildDashboardCard(
                  title: 'Chat',
                  icon: Icons.chat,
                  onTap: () => context.go('/dashboard/chat'),
                  backgroundColor: Colors.pink.shade50,
                  iconColor: Colors.pink,
                  badge: '3',
                ),
                _buildDashboardCard(
                  title: 'Calendar',
                  icon: Icons.calendar_today,
                  onTap: () => context.go('/dashboard/calendar'),
                  backgroundColor: Colors.cyan.shade50,
                  iconColor: Colors.cyan,
                ),
                _buildDashboardCard(
                  title: 'Reports',
                  icon: Icons.bar_chart,
                  onTap: () => context.go('/dashboard/reports'),
                  backgroundColor: Colors.amber.shade50,
                  iconColor: Colors.amber.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1500) return 4;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 2;
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
    String? badge,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: iconColor,
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}