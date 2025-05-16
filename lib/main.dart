import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
//import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
// import 'features/hr/screens/hr_dashboard_screen.dart';
// import 'features/manager/screens/manager_dashboard_screen.dart';
// import 'features/employee/screens/employee_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'Your App Name',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/login',
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    
    // case '/dashboard':
    //   return MaterialPageRoute(builder: (_) => const DashboardScreen());
    
    case '/admin/dashboard':
      return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
    
    // case '/hr/dashboard':
    //   return MaterialPageRoute(builder: (_) => const HRDashboardScreen());
    
    // case '/manager/dashboard':
    //   return MaterialPageRoute(builder: (_) => const ManagerDashboardScreen());
    
    // case '/employee/dashboard':
    //   return MaterialPageRoute(builder: (_) => const EmployeeDashboardScreen());
    
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}