import 'package:flutter/material.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Map<String, dynamic>> workouts = [
    {'name': 'Push-Ups', 'progress': 0.3, 'completed': 0, 'sets': 3, 'reps': 10},
    {'name': 'Squats', 'progress': 0.5, 'completed': 0, 'sets': 3, 'reps': 15},
    {'name': 'Jump Rope', 'progress': 0.2, 'completed': 0, 'sets': 5, 'reps': 30},
    {'name': 'Lunges', 'progress': 0.4, 'completed': 0, 'sets': 3, 'reps': 12},
    {'name': 'Plank', 'progress': 0.6, 'completed': 0, 'sets': 3, 'reps': 60}, // 60 seconds
  ];

  List<Map<String, String>> workoutHistory = []; // Stores workout logs

  // Get workout details by name
  Map<String, dynamic> getWorkoutByName(String name) {
    return workouts.firstWhere((workout) => workout['name'] == name, orElse: () => {});
  }

  // Log a completed workout
  void logWorkout(String name) {
    for (var workout in workouts) {
      if (workout['name'] == name) {
        workout['completed'] += 1;
        workout['progress'] += 0.1;
        workout['progress'] = workout['progress'].clamp(0.0, 1.0); // Ensure valid progress
        
        // Add workout to history
        workoutHistory.add({
          'name': name,
          'date': DateTime.now().toString().split(' ')[0], // Store only the date
        });

        notifyListeners();
        break;
      }
    }
  }

  // Delete a workout entry from history
  void deleteWorkoutFromHistory(int index) {
    if (index >= 0 && index < workoutHistory.length) {
      workoutHistory.removeAt(index);
      notifyListeners();
    }
  }

  // Update workout progress manually
  void updateWorkoutProgress(String name, double progress) {
    for (var workout in workouts) {
      if (workout['name'] == name) {
        workout['progress'] = progress.clamp(0.0, 1.0); // Ensure progress is valid
        notifyListeners();
        break;
      }
    }
  }
}
