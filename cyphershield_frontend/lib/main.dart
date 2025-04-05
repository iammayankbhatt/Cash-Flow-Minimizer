import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/result_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/dashboard', builder: (context, state) => DashboardScreen()),
      GoRoute(
        path: '/results',
        builder: (context, state) {
          final results = (state.extra as List?)?.cast<String>() ?? [];
          return ResultScreen(results: results);
        },
      ),
      GoRoute(path: '/transactions', builder: (context, state) => AddTransactionScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}
