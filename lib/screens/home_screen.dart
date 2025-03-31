import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Relative import for auth_service.dart
import 'login_screen.dart';            // Relative import for login_screen.dart (same directory)

class HomeScreen extends StatelessWidget {
  void logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Center(child: Text("Welcome to Workout Tracker!")),
    );
  }
}
