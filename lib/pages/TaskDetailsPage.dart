import 'package:flutter/material.dart';
import 'package:wishlist/models/Task.dart';
import 'package:wishlist/pages/ChildTasks.dart';
import 'package:wishlist/services/TaskService.dart';


class ParentTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParentTaskPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  TaskDetailsPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Task Title: ${task.title}'),
            // Display other task details as needed
          ],
        ),
      ),
    );
  }
}
class ParentTaskPage extends StatefulWidget {
  @override
  _ParentTasksPageState createState() => _ParentTasksPageState();
}
class _ParentTasksPageState extends State<ParentTaskPage> {
late Future<List<Task>> _tasksFuture;

@override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the widget is initialized
  }

  void _loadTasks() {
    // Fetch tasks asynchronously
    _tasksFuture = TaskService.getTasksByParentName("parentTest");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found'));
          } else {
            final List<Task> tasks = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onTap: () => _showTaskDetailsDialog(context, task), // Navigate to task details
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task), // Pass the task to TaskDetailsPage
      ),
    );
  }
}



void _showTaskDetailsDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildTaskDetailRow('Child Username', task.childUsername),
                _buildTaskDetailRow('Description', task.description ?? 'N/A'),
                _buildTaskDetailRow('Amount', task.amount != null ? task.amount.toString() : 'N/A'),
                _buildTaskDetailRow('Deadline', task.deadline != null ? task.deadline.toString() : 'N/A'),
                _buildTaskDetailRow('Status', task.status != null ? (task.status! ? 'Completed' : 'Pending') : 'N/A'),
                _buildTaskDetailRow('Validation Type', task.validationType ?? 'N/A'),
        if (task.validationType == 'QuestionAnswer') ...[
                  _buildTaskDetailRow('Answer', task.answer ?? 'N/A'),
        ],
                if (task.validationType == 'QCM') ...[
                  SizedBox(height: 16.0),
                  Text(
                    'QCM Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTaskDetailRow('Question', task.qcmQuestion),
                  _buildTaskDetailRow('Options', task.qcmOptions ?? 'N/A'),
                ],
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildTaskDetailRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120.0,
        child: Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: 8.0),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );
}


