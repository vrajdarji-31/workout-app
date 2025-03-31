import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Color> gradientColors = [Color(0xFF2196F3), Color(0xFF42A5F5)];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final history = Provider.of<WorkoutProvider>(context).workoutHistory;

    // Calculate workout counts by date
    Map<String, int> workoutsByDate = {};
    for (var workout in history) {
      String date = workout['date'] ?? '';
      if (workoutsByDate.containsKey(date)) {
        workoutsByDate[date] = workoutsByDate[date]! + 1;
      } else {
        workoutsByDate[date] = 1;
      }
    }

    // Sort dates
    List<String> sortedDates = workoutsByDate.keys.toList()..sort();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A237E).withOpacity(0.1), Color(0xFF121212)],
          stops: [0.0, 0.3],
        ),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF1A237E),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [Tab(text: "Progress"), Tab(text: "Activity")],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Progress tab
                _buildProgressTab(workouts),

                // Activity tab
                _buildActivityTab(sortedDates, workoutsByDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab(List<Map<String, dynamic>> workouts) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Workout Progress",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Track your progress for each workout",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 20),

          // Line chart
          Container(
            height: 220,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 0.2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < workouts.length) {
                          String name = workouts[value.toInt()]['name'];
                          if (name.length > 8) {
                            name = name.substring(0, 8) + '...';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 0.2 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '${(value * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                      reservedSize: 35,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: workouts.length - 1,
                minY: 0,
                maxY: 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(workouts.length, (index) {
                      return FlSpot(
                        index.toDouble(),
                        workouts[index]['progress'],
                      );
                    }),
                    isCurved: true,
                    gradient: LinearGradient(colors: gradientColors),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: gradientColors[0],
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors:
                            gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30),
          Text(
            "Workout Completion",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Number of times each workout was completed",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 20),

          // Bar chart
          Container(
            height: 220,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    workouts.fold(
                      0,
                      (max, workout) =>
                          workout['completed'] > max
                              ? workout['completed']
                              : max,
                    ) +
                    2.0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${workouts[group.x.toInt()]['name']}\n',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '${rod.toY.toInt()} times',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < workouts.length) {
                          String name = workouts[value.toInt()]['name'];
                          if (name.length > 8) {
                            name = name.substring(0, 8) + '...';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          );
                        }
                        return SizedBox();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 1 == 0,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(
                  workouts.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: workouts[index]['completed'].toDouble(),
                        gradient: LinearGradient(
                          colors: [Colors.blue[300]!, Colors.blue[800]!],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(
    List<String> sortedDates,
    Map<String, int> workoutsByDate,
  ) {
    return sortedDates.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 70, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No workout activity yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Complete workouts to see your activity",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        )
        : SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Activity Calendar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Your workout activity over time",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Activity calendar (simplified)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          "Workouts Completed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20),
                    ...sortedDates.reversed
                        .take(10)
                        .map(
                          (date) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(date, style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ...List.generate(
                                      workoutsByDate[date]!,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4.0,
                                        ),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: Colors.blue[400],
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "${workoutsByDate[date]}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),

              SizedBox(height: 30),
              Text(
                "Activity Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Total Days",
                      sortedDates.length.toString(),
                      Icons.calendar_today,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Total Workouts",
                      workoutsByDate.values
                          .fold(0, (sum, count) => sum + count)
                          .toString(),
                      Icons.fitness_center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Avg per Day",
                      (workoutsByDate.values.fold(
                                0,
                                (sum, count) => sum + count,
                              ) /
                              sortedDates.length)
                          .toStringAsFixed(1),
                      Icons.trending_up,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Streak",
                      _calculateStreak(sortedDates).toString(),
                      Icons.local_fire_department,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[400], size: 30),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        ],
      ),
    );
  }

  int _calculateStreak(List<String> dates) {
    if (dates.isEmpty) return 0;

    // This is a simplified streak calculation
    // In a real app, you'd need to handle continuous days properly
    return 1;
  }
}
