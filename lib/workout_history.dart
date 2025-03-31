 import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
 import 'workout_provider.dart';

 class WorkoutHistoryPage extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
     final history = workoutProvider.workoutHistory; // Fetch workout history list

     return Scaffold(
       appBar: AppBar(
         title: Text("Workout History"),
         backgroundColor: Colors.blueAccent,
       ),
       body: history.isEmpty
           ? Center(
               child: Text(
                 "No workout history yet!",
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ),
             )
           : ListView.builder(
               itemCount: history.length,
               itemBuilder: (context, index) {
                 final workout = history[index]; // Get workout history entry
                 return Card(
                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   child: ListTile(
                     title: Text(
                       workout['name'] ?? 'Unknown Workout', // Prevents null error
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     subtitle: Text(
                       "Completed on: ${workout['date'] ?? 'Unknown Date'}",
                       style: TextStyle(fontSize: 16),
                     ),
                     trailing: IconButton(
                       icon: Icon(Icons.delete, color: Colors.red),
                       onPressed: () {
                         workoutProvider.deleteWorkoutFromHistory(index);
                       },
                     ),
                   ),
                 );
               },
             ),
     );
   }
 }

