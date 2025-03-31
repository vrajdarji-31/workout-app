import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    int totalCompleted = workouts.fold(0, (sum, workout) => sum + (workout['completed'] as int));


    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Workouts Completed: $totalCompleted",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
