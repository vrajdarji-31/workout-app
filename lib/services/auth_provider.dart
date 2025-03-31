import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  final AuthService _authService = AuthService();

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;

  // Initialize auth state from SharedPreferences
  Future<void> initAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  // Sign in user
  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        _isLoggedIn = true;
        _userId = user.uid;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user.uid);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  // Sign up user
  Future<dynamic> signUp(String email, String password) async {
    try {
      final result = await _authService.signUp(email, password);
      if (result is! String) {
        // If not an error message string
        _isLoggedIn = true;
        _userId = result.uid;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', result.uid);

        notifyListeners();
      }
      return result;
    } catch (e) {
      print('Sign up error: $e');
      return e.toString();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _authService.signOut();
    _isLoggedIn = false;
    _userId = null;

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');

    notifyListeners();
  }

  // Password reset method
  Future<bool> resetPassword(String email) async {
    return await _authService.resetPassword(email);
  }
}
