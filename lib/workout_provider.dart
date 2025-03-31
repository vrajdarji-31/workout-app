import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutProvider extends ChangeNotifier {
  List<Map<String, dynamic>> workouts = [
    {
      'name': 'Push-Ups', 
      'progress': 0.3, 
      'completed': 0, 
      'sets': 3, 
      'reps': 10,
      'description': 'Push-ups work the chest, shoulders, triceps, and core. Keep your body straight and lower until your chest nearly touches the floor.',
    },
    {
      'name': 'Squats', 
      'progress': 0.5, 
      'completed': 0, 
      'sets': 3, 
      'reps': 15,
      'description': 'Squats primarily target the quadriceps, hamstrings, and glutes. Keep your back straight and knees over your toes.',
    },
    {
      'name': 'Jump Rope', 
      'progress': 0.2, 
      'completed': 0, 
      'sets': 5, 
      'reps': 30,
      'description': 'Jump rope is a great cardiovascular exercise that improves coordination and burns calories quickly.',
    },
    {
      'name': 'Lunges', 
      'progress': 0.4, 
      'completed': 0, 
      'sets': 3, 
      'reps': 12,
      'description': 'Lunges work your quadriceps, hamstrings, glutes, and calves. Keep your front knee above your ankle and back knee off the ground.',
    },
    {
      'name': 'Plank', 
      'progress': 0.6, 
      'completed': 0, 
      'sets': 3, 
      'reps': 60, // 60 seconds
      'description': 'Planks strengthen your core, shoulders, arms, and glutes. Keep your body in a straight line from head to heels.',
    },
  ];

  List<Map<String, String>> workoutHistory = [];

  WorkoutProvider() {
    _loadData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load workouts
      String? workoutsJson = prefs.getString('workouts');
      if (workoutsJson != null) {
        List<dynamic> decoded = jsonDecode(workoutsJson);
        workouts = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      
      // Load history
      String? historyJson = prefs.getString('workoutHistory');
      if (historyJson != null) {
        List<dynamic> decoded = jsonDecode(historyJson);
        workoutHistory = decoded.map((item) => Map<String, String>.from(item)).toList();
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save workouts
      String workoutsJson = jsonEncode(workouts);
      await prefs.setString('workouts', workoutsJson);
      
      // Save history
      String historyJson = jsonEncode(workoutHistory);
      await prefs.setString('workoutHistory', historyJson);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Get workout details by name
  Map<String, dynamic> getWorkoutByName(String name) {
    return workouts.firstWhere(
      (workout) => workout['name'] == name, 
      orElse: () => Map<String, dynamic>()
    );
  }

  // Log a completed workout
  void logWorkout(String name) {
    for (var workout in workouts) {
      if (workout['name'] == name) {
        workout['completed'] += 1;
        
        // Calculate new progress (cap at 1.0)
        double newProgress = workout['progress'] + 0.1;
        workout['progress'] = newProgress > 1.0 ? 1.0 : newProgress;
        
        // Add to history with current date and time
        DateTime now = DateTime.now();
        String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        
        workoutHistory.add({
          'name': name,
          'date': formattedDate,
        });

        _saveData();
        notifyListeners();
        break;
      }
    }
  }

  // Delete a workout entry from history
  void deleteWorkoutFromHistory(int index) {
    if (index >= 0 && index < workoutHistory.length) {
      workoutHistory.removeAt(index);
      _saveData();
      notifyListeners();
    }
  }

  // Update workout progress manually
  void updateWorkoutProgress(String name, double progress) {
    for (var workout in workouts) {
      if (workout['name'] == name) {
        workout['progress'] = progress > 1.0 ? 1.0 : (progress < 0.0 ? 0.0 : progress);
        _saveData();
        notifyListeners();
        break;
      }
    }
  }
  
  // Add a new workout
  void addWorkout(Map<String, dynamic> newWorkout) {
    workouts.add(newWorkout);
    _saveData();
    notifyListeners();
  }
  
  // Update an existing workout
  void updateWorkout(String name, Map<String, dynamic> updatedWorkout) {
    int index = workouts.indexWhere((workout) => workout['name'] == name);
    if (index != -1) {
      workouts[index] = updatedWorkout;
      _saveData();
      notifyListeners();
    }
  }
  
  // Delete a workout
  void deleteWorkout(String name) {
    workouts.removeWhere((workout) => workout['name'] == name);
    _saveData();
    notifyListeners();
  }
  
  // Clear all history
  void clearHistory() {
    workoutHistory.clear();
    _saveData();
    notifyListeners();
  }
  
  // Reset all progress
  void resetAllProgress() {
    for (var workout in workouts) {
      workout['progress'] = 0.0;
      workout['completed'] = 0;
    }
    workoutHistory.clear();
    _saveData();
    notifyListeners();
  }
}