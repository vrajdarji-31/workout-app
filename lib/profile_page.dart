import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../workout_provider.dart';
import 'services/auth_provider.dart';
import 'screens/login_screen.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final authProvider = Provider.of<UserAuthProvider>(context);

    // Calculate statistics
    int totalCompleted = workouts.fold(
      0,
      (sum, workout) => sum + (workout['completed'] as int),
    );
    int totalWorkouts = workouts.length;
    double avgProgress =
        workouts.fold(0.0, (sum, workout) => sum + workout['progress']) /
        totalWorkouts;

    // Get user email
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'User';
    String userName = userEmail.split('@')[0]; // Use part before @ as name

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A237E).withOpacity(0.1), Color(0xFF121212)],
          stops: [0.0, 0.3],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue[800],
                child: Text(
                  userName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                userEmail,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              SizedBox(height: 30),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      "Total Workouts",
                      totalWorkouts.toString(),
                      Icons.fitness_center,
                      Colors.indigo,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      "Completed",
                      totalCompleted.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Progress circle
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Overall Progress",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 15.0,
                        percent: avgProgress,
                        center: Text(
                          "${(avgProgress * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        progressColor: Colors.blue[400],
                        backgroundColor: Color(0xFF2C2C2C),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Keep up the good work!",
                        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Settings section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        "Edit Profile",
                        Icons.edit,
                        () {
                          // Edit profile function
                        },
                      ),
                      Divider(height: 0),
                      _buildSettingsItem(
                        context,
                        "Notifications",
                        Icons.notifications,
                        () {
                          // Notifications settings
                        },
                      ),
                      Divider(height: 0),
                      _buildSettingsItem(
                        context,
                        "App Settings",
                        Icons.settings,
                        () {
                          // App settings
                        },
                      ),
                      Divider(height: 0),
                      _buildSettingsItem(
                        context,
                        "Help & Support",
                        Icons.help,
                        () {
                          // Help and support
                        },
                      ),
                      Divider(height: 0),
                      _buildSettingsItem(
                        context,
                        "Logout",
                        Icons.logout,
                        () async {
                          // Confirm logout
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: Text('CANCEL'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await authProvider.signOut();
                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text('LOGOUT'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // App version
              Text(
                "App Version: 1.0.0",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color ?? Colors.blue[400]),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color ?? Colors.white),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
