import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword(BuildContext context) {
    // Dummy logic, replace with real logic
    print("Reset link sent to: ${_emailController.text}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset link sent!")));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter your email to reset password", style: TextStyle(fontSize: 16)),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _resetPassword(context), child: Text("Send Reset Link")),
          ],
        ),
      ),
    );
  }
}
