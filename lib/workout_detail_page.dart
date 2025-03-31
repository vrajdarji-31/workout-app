import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../workout_provider.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutName;

  WorkoutDetailPage({required this.workoutName});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _logWorkout(Map<String, dynamic> workout, WorkoutProvider provider) async {
    setState(() {
      _isAnimating = true;
    });

    double oldProgress = workout['progress'];
    double newProgress = (oldProgress + 0.1).clamp(0.0, 1.0);

    _progressAnimation = Tween<double>(
      begin: oldProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0.0);

    // First log the workout
    provider.logWorkout(workout['name']);

    // Then update progress after animation completes
    await Future.delayed(Duration(milliseconds: 800));
    provider.updateWorkoutProgress(workout['name'], newProgress);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Workout logged successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkoutProvider>(context);
    var workout = provider.getWorkoutByName(widget.workoutName);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom app bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                workout['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Hero(
                      tag: 'workout-icon-${workout['name']}',
                      child: Icon(
                        getWorkoutIcon(workout['name']),
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Add edit workout functionality
                },
              ),
            ],
          ),
          
          // Workout details
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout metadata
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWorkoutMetadata(
                              "Sets",
                              "${workout['sets']}",
                              Icons.repeat,
                            ),
                            VerticalDivider(thickness: 1),
                            _buildWorkoutMetadata(
                              "Reps",
                              "${workout['reps']}",
                              Icons.fitness_center,
                            ),
                            VerticalDivider(thickness: 1),
                            _buildWorkoutMetadata(
                              "Completed",
                              "${workout['completed']}",
                              Icons.check_circle_outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 25),
                    
                    // Progress section
                    Text(
                      "Your Progress",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 15.0,
                            percent: _isAnimating ? _progressAnimation.value : workout['progress'],
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(_isAnimating ? _progressAnimation.value * 100 : workout['progress'] * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Completed",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            progressColor: Colors.blue[400],
                            backgroundColor: Color(0xFF2C2C2C),
                            animation: true,
                            animationDuration: 500,
                            circularStrokeCap: CircularStrokeCap.round,
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Description section
                    Text(
                      "Workout Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      getWorkoutDescription(workout['name']),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Log workout button
                    ElevatedButton(
                      onPressed: _isAnimating 
                        ? null 
                        : () => _logWorkout(workout, provider),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_task),
                          SizedBox(width: 10),
                          Text(
                            "LOG WORKOUT",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWorkoutMetadata(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[300], size: 30),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  // Helper methods
  IconData getWorkoutIcon(String workoutName) {
    switch (workoutName.toLowerCase()) {
      case 'push-ups':
        return Icons.fitness_center;
      case 'squats':
        return Icons.sports_gymnastics;
      case 'jump rope':
        return Icons.timer;
      case 'lunges':
        return Icons.directions_walk;
      case 'plank':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
    }
  }
  
  String getWorkoutDescription(String workoutName) {
    switch (workoutName.toLowerCase()) {
      case 'push-ups':
        return "Push-ups work the chest, shoulders, triceps, and core muscles. Start in a plank position with hands shoulder-width apart, lower your body until your chest nearly touches the floor, then push back up.";
      case 'squats':
        return "Squats primarily target the quadriceps, hamstrings, and glutes. Stand with feet shoulder-width apart, bend your knees and lower your hips as if sitting in a chair, keeping your back straight and knees over (not past) your toes.";
      case 'jump rope':
        return "Jump rope is an excellent cardiovascular exercise that works your legs, arms, and core while improving coordination. Keep your elbows close to your body, use your wrists to turn the rope, and jump just high enough for the rope to pass under your feet.";
      case 'lunges':
        return "Lunges work your quadriceps, hamstrings, glutes, and calves. Take a step forward, lowering your hips until both knees are bent at about 90 degrees. Keep your front knee directly above your ankle and your back knee off the ground.";
      case 'plank':
        return "The plank is a core strengthening exercise that engages multiple muscle groups simultaneously. Hold a push-up position with your body in a straight line from head to heels, engaging your core and keeping your back flat.";
      default:
        return "Complete the specified sets and reps with proper form to maximize results and prevent injury. Focus on controlled movements and proper breathing throughout the exercise.";
    }
  }
}