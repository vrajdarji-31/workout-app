import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("LoginScreen Loaded"); // ✅ Debug log
  }

  void signIn() async {
    print("Sign In Button Pressed"); // ✅ Debug log
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    var user = await AuthService().signIn(email, password);
    if (user != null) {
      print("Login Successful! Navigating to HomeScreen...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("Login Failed!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Center( // ✅ Add a visible widget to debug blank screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Workout Tracker!", style: TextStyle(fontSize: 18)), // ✅ Ensure something is displayed
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
