import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:workoutapp/screens/home_screen.dart';
import 'package:workoutapp/screens/login_screen.dart';
import 'package:workoutapp/services/auth_provider.dart';
import '../services/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Check login status after animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkLoginStatus();
      }
    });

    _animationController.forward();
  }

  void _checkLoginStatus() async {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    await authProvider.initAuthState();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => authProvider.isLoggedIn ? WorkoutHomePage() : LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF01579B)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo
              Lottie.asset(
                'assets/animations/splash.json',
                width: 200,
                height: 200,
                controller: _animationController,
              ),
              SizedBox(height: 30),
              // Animated text
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'FITNESS TRACKER PRO',
                    textStyle: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              SizedBox(height: 20),
              Text(
                'Your personal fitness journey starts here',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
