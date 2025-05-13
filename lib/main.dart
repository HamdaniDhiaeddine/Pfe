import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/employee/providers/contract_provider.dart';
import 'features/employee/providers/department_provider.dart';
import 'features/employee/providers/directory_provider.dart';
import 'features/employee/providers/event_provider.dart';
import 'features/employee/providers/leave_provider.dart';
import 'core/utils/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..loadUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => DepartmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DirectoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContractProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LeaveProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HumanIQ App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}