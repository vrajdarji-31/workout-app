import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_provider.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Map<String, dynamic> workout;

  WorkoutDetailPage({required this.workout});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkoutProvider>(context);
    var workout = provider.workouts.firstWhere((w) => w['name'] == widget.workout['name']);

    return Scaffold(
      appBar: AppBar(
        title: Text(workout['name']),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sets: ${workout['sets']}  |  Reps: ${workout['reps']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: workout['progress'],
              minHeight: 10,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text(
              "Completed: ${workout['completed']} times",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.logWorkout(workout['name']);
                provider.updateWorkoutProgress(workout['name'], workout['progress'] + 0.1);
                setState(() {}); // Refresh UI after progress update
              },
              child: Text("Log Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
