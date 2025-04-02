import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      
      // Log the login attempt
      if (user != null) {
        await logLoginAttempt(user.uid, email);
      }
      
      return user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Log the login attempt to Firestore
  Future<void> logLoginAttempt(String userId, String email) async {
    try {
      // Get IP address
      String ipAddress = await _getIpAddress();
      
      // Create log entry
      await _firestore.collection('login_logs').add({
        'userId': userId,
        'email': email,
        'ipAddress': ipAddress,
        'loginTime': FieldValue.serverTimestamp(),
        'device': _getDeviceInfo(),
      });
      
      print('Login logged successfully');
    } catch (e) {
      print('Error logging login: $e');
    }
  }

  // Get the IP address using a public API
  Future<String> _getIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
      return 'Unknown';
    } catch (e) {
      print('Error getting IP: $e');
      return 'Unknown';
    }
  }

  // Get basic device information
  String _getDeviceInfo() {
    return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
  }

  // Sign up with email and password
  Future<dynamic> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Sign up failed';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }
}