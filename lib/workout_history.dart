import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final history = workoutProvider.workoutHistory;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A237E).withOpacity(0.1), Color(0xFF121212)],
          stops: [0.0, 0.3],
        ),
      ),
      child:
          history.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(context, history, workoutProvider),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "No workout history yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Complete workouts to see your history",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<Map<String, String>> history,
    WorkoutProvider workoutProvider,
  ) {
    // Group history items by date
    Map<String, List<Map<String, String>>> groupedHistory = {};

    for (var workout in history) {
      String date = workout['date'] ?? 'Unknown Date';
      if (!groupedHistory.containsKey(date)) {
        groupedHistory[date] = [];
      }
      groupedHistory[date]!.add(workout);
    }

    // Sort dates in descending order (newest first)
    List<String> sortedDates =
        groupedHistory.keys.toList()..sort((a, b) => b.compareTo(a));

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Workout History",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Total: ${history.length}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= sortedDates.length) return null;

            String date = sortedDates[index];
            List<Map<String, String>> dayWorkouts = groupedHistory[date]!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatDate(date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${dayWorkouts.length} workout${dayWorkouts.length > 1 ? 's' : ''}",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...dayWorkouts.asMap().entries.map((entry) {
                    int workoutIndex = entry.key;
                    Map<String, String> workout = entry.value;
                    return _buildWorkoutHistoryItem(
                      context,
                      workout,
                      workoutProvider,
                      date,
                      workoutIndex,
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey[800]),
                ],
              ),
            );
          }, childCount: sortedDates.length),
        ),
      ],
    );
  }

  Widget _buildWorkoutHistoryItem(
    BuildContext context,
    Map<String, String> workout,
    WorkoutProvider provider,
    String date,
    int workoutIndex,
  ) {
    return Dismissible(
      key: Key("${date}-${workout['name']}-$workoutIndex"),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text(
                "Are you sure you want to delete this workout entry?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("DELETE", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Find the global index in the provider's list
        final globalIndex = provider.workoutHistory.indexWhere(
          (item) => item['name'] == workout['name'] && item['date'] == date,
        );

        if (globalIndex != -1) {
          provider.deleteWorkoutFromHistory(globalIndex);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Workout entry deleted"),
              action: SnackBarAction(
                label: "UNDO",
                onPressed: () {
                  // In a real app, you'd implement undo functionality
                },
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getWorkoutColor(workout['name'] ?? ''),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getWorkoutIcon(workout['name'] ?? ''),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout['name'] ?? 'Unknown Workout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          _getTimeFromDate(workout['date'] ?? ''),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.navigate_next, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      // Try to parse the date (assuming format is YYYY-MM-DD)
      final dateParts = date.split('-');
      if (dateParts.length == 3) {
        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);

        // Return in a more readable format
        return "${_getMonthName(month)} $day, $year";
      }
    } catch (e) {
      // If there's any error in parsing, return the original date
    }
    return date;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _getTimeFromDate(String date) {
    // In a real app, you'd extract the time component if available
    // For now, we'll just return a placeholder
    return "Completed";
  }

  IconData _getWorkoutIcon(String workoutName) {
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

  Color _getWorkoutColor(String workoutName) {
    switch (workoutName.toLowerCase()) {
      case 'push-ups':
        return Colors.blue[700]!;
      case 'squats':
        return Colors.purple[700]!;
      case 'jump rope':
        return Colors.green[700]!;
      case 'lunges':
        return Colors.orange[700]!;
      case 'plank':
        return Colors.red[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}
