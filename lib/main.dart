// // import 'package:flutter/material.dart';
// // import 'package:percent_indicator/percent_indicator.dart';
// // import 'package:provider/provider.dart';
// // import 'workout_history.dart';
// // import 'statistics_page.dart';
// // import 'profile_page.dart';
// // import 'workout_provider.dart';

// // void main() {
// //   runApp(
// //     ChangeNotifierProvider(
// //       create: (context) => WorkoutProvider(),
// //       child: WorkoutTrackerApp(),
// //     ),
// //   );
// // }

// // class WorkoutTrackerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         brightness: Brightness.dark,
// //         primaryColor: Colors.blueAccent,
// //       ),
// //       home: WorkoutHomePage(),
// //     );
// //   }
// // }

// // class WorkoutHomePage extends StatefulWidget {
// //   @override
// //   _WorkoutHomePageState createState() => _WorkoutHomePageState();
// // }

// // class _WorkoutHomePageState extends State<WorkoutHomePage> {
// //   int _selectedIndex = 0;
// //   final List<Widget> _pages = [
// //     WorkoutGridPage(),
// //     WorkoutHistoryPage(),
// //     StatisticsPage(),
// //     ProfilePage(),
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Workout Tracker"),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: _pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
// //           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
// //           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         selectedItemColor: Colors.blueAccent,
// //         unselectedItemColor: Colors.grey,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }

// // class WorkoutGridPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final workouts = Provider.of<WorkoutProvider>(context).workouts;
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: GridView.builder(
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           childAspectRatio: 1,
// //           crossAxisSpacing: 10,
// //           mainAxisSpacing: 10,
// //         ),
// //         itemCount: workouts.length,
// //         itemBuilder: (context, index) {
// //           return GestureDetector(
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => WorkoutDetailPage(workout: workouts[index]),
// //                 ),
// //               );
// //             },
// //             child: Card(
// //               color: Colors.grey[900],
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12.0),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       workouts[index]['name'],
// //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                     SizedBox(height: 10),
// //                     CircularPercentIndicator(
// //                       radius: 50.0,
// //                       lineWidth: 8.0,
// //                       percent: workouts[index]['progress'],
// //                       center: Text("${(workouts[index]['progress'] * 100).toInt()}%"),
// //                       progressColor: Colors.blueAccent,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class WorkoutDetailPage extends StatelessWidget {
// //   final Map<String, dynamic> workout;
  
// //   WorkoutDetailPage({required this.workout});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(workout['name']),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: Center(
// //         child: Text("Detailed tracking coming soon!", style: TextStyle(fontSize: 20)),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:percent_indicator/percent_indicator.dart';
// // import 'package:provider/provider.dart';
// // import 'workout_history.dart';
// // import 'statistics_page.dart';
// // import 'profile_page.dart';
// // import 'workout_provider.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:your_project/screens/login_screen.dart'; // Import login screen

// // void main() async {
// //    WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(); // Initialize Firebase
// //   runApp(
// //     ChangeNotifierProvider(
// //       create: (context) => WorkoutProvider(),
// //       child: WorkoutTrackerApp(),
// //     ),
// //   );
// // }

// // class WorkoutTrackerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         brightness: Brightness.dark,
// //         primaryColor: Colors.blueAccent,
// //       ),
// //       home: WorkoutHomePage(),
// //     );
// //   }
// // }

// // class WorkoutHomePage extends StatefulWidget {
// //   @override
// //   _WorkoutHomePageState createState() => _WorkoutHomePageState();
// // }

// // class _WorkoutHomePageState extends State<WorkoutHomePage> {
// //   int _selectedIndex = 0;
// //   final List<Widget> _pages = [
// //     WorkoutGridPage(),
// //     WorkoutHistoryPage(),
// //     StatisticsPage(),
// //     ProfilePage(),
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Workout Tracker"),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: _pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
// //           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
// //           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         selectedItemColor: Colors.blueAccent,
// //         unselectedItemColor: Colors.grey,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }

// // class WorkoutGridPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final workouts = Provider.of<WorkoutProvider>(context).workouts;
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: GridView.builder(
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 2,
// //           childAspectRatio: 1,
// //           crossAxisSpacing: 10,
// //           mainAxisSpacing: 10,
// //         ),
// //         itemCount: workouts.length,
// //         itemBuilder: (context, index) {
// //           return GestureDetector(
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => WorkoutDetailPage(workoutName: workouts[index]['name']),
// //                 ),
// //               );
// //             },
// //             child: Card(
// //               color: Colors.grey[900],
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12.0),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       workouts[index]['name'],
// //                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                     SizedBox(height: 10),
// //                     CircularPercentIndicator(
// //                       radius: 50.0,
// //                       lineWidth: 8.0,
// //                       percent: workouts[index]['progress'],
// //                       center: Text("${(workouts[index]['progress'] * 100).toInt()}%"),
// //                       progressColor: Colors.blueAccent,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class WorkoutDetailPage extends StatefulWidget {
// //   final String workoutName;
  
// //   WorkoutDetailPage({required this.workoutName});

// //   @override
// //   _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
// // // }

// // class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     var provider = Provider.of<WorkoutProvider>(context);
// //     var workout = provider.getWorkoutByName(widget.workoutName);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(workout['name']),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               "Sets: ${workout['sets']}  |  Reps: ${workout['reps']}",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 20),
// //             LinearProgressIndicator(
// //               value: workout['progress'],
// //               minHeight: 10,
// //               backgroundColor: Colors.grey[700],
// //               valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               "Completed: ${workout['completed']} times",
// //               style: TextStyle(fontSize: 16),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 provider.logWorkout(workout['name']);
// //                 provider.updateWorkoutProgress(workout['name'], workout['progress'] + 0.1);
// //                 setState(() {}); // Refresh UI after progress update
// //               },
// //               child: Text("Log Workout"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

 import 'package:flutter/material.dart';
 import 'package:percent_indicator/percent_indicator.dart';
 import 'package:provider/provider.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'screens/login_screen.dart'; // Correct import path
 import 'workout_history.dart';
 import 'statistics_page.dart';
 import 'profile_page.dart';
 import 'workout_provider.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(); // Initialize Firebase
   runApp(
     ChangeNotifierProvider(
       create: (context) => WorkoutProvider(),
       child: WorkoutTrackerApp(),
     ),
   );
 }

 class WorkoutTrackerApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
         brightness: Brightness.dark,
         primaryColor: Colors.blueAccent,
       ),
     home: LoginScreen(), // Set LoginScreen as the first screen
    );
   }
 }

 class WorkoutHomePage extends StatefulWidget {
   @override
   _WorkoutHomePageState createState() => _WorkoutHomePageState();
 }

 class _WorkoutHomePageState extends State<WorkoutHomePage> {
   int _selectedIndex = 0;
   final List<Widget> _pages = [
     WorkoutGridPage(),
     WorkoutHistoryPage(),
     StatisticsPage(),
     ProfilePage(),
   ];

   void _onItemTapped(int index) {
    setState(() {
       _selectedIndex = index;
     });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Workout Tracker"),
        backgroundColor: Colors.blueAccent,
      ),
       body: _pages[_selectedIndex],
       bottomNavigationBar: BottomNavigationBar(
         items: const <BottomNavigationBarItem>[
           BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
         ],
         currentIndex: _selectedIndex,
         selectedItemColor: Colors.blueAccent,
         unselectedItemColor: Colors.grey,
         onTap: _onItemTapped,
       ),
     );
   }
 }

class WorkoutGridPage extends StatelessWidget {
     @override
   Widget build(BuildContext context) {
     final workouts = Provider.of<WorkoutProvider>(context).workouts;
    return Padding(
       padding: const EdgeInsets.all(16.0),
       child: GridView.builder(
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
           mainAxisSpacing: 10,
         ),
         itemCount: workouts.length,
         itemBuilder: (context, index) {
           return GestureDetector(
             onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => WorkoutDetailPage(workoutName: workouts[index]['name']),
                 ),
               );
             },
             child: Card(
               color: Colors.grey[900],
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12.0),
               ),
               child: Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       workouts[index]['name'],
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     SizedBox(height: 10),
                     CircularPercentIndicator(
                       radius: 50.0,
                       lineWidth: 8.0,
                       percent: workouts[index]['progress'],
                       center: Text("${(workouts[index]['progress'] * 100).toInt()}%"),
                       progressColor: Colors.blueAccent,
                     ),
                   ],
                 ),
               ),
             ),
           );
         },
       ),
     );
   }
 }

class WorkoutDetailPage extends StatefulWidget {
   final String workoutName;

   WorkoutDetailPage({required this.workoutName});

  @override
   _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
 }

 class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
   @override
  Widget build(BuildContext context) {
     var provider = Provider.of<WorkoutProvider>(context);
     var workout = provider.getWorkoutByName(widget.workoutName);
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
                setState(() {}); // Refresh UI after progress update            },
               child: Text("Log Workout");}, child: null,
             ),
           ],
         ),
      ),
    );
  }
}


