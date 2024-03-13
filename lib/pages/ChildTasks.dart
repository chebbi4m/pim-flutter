import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Task.dart';
//import 'package:image_picker/image_picker.dart';
import '../services/TaskService.dart';

// ignore: depend_on_referenced_packages





enum TaskType { QuestionAnswer, Photo, QCM }

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  TaskCard({Key? key, required this.task, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     IconData iconData = Icons.error; // Initialize with a default value
    Color iconColor = Colors.black; // Initialize with a default value
    Color bgColor = Colors.grey; 

    switch (task.validationType) {
      case "QuestionAnswer":
        iconData = Icons.question_answer;
        iconColor = Colors.blue.shade700;
        bgColor = Colors.lightBlueAccent.shade200; // Change to a light blue shade
        break;
      case "Photo":
        iconData = Icons.camera_alt;
        iconColor = Colors.green.shade700;
        bgColor = Colors.lightGreenAccent.shade200; // Change to a light green shade
        break;
      case "QCM":
        iconData = Icons.list;
        iconColor = Colors.orange.shade700;
        bgColor = Colors.orangeAccent.shade200; // Change to an orange shade
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Add rounded corners
            color: bgColor, // Set the background color
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white, // Change the icon background color to white
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 40, // Adjust the size of the icon
                ),
              ),
              SizedBox(height: 8), // Add some space between the icon and the title
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ChildTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TasksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
late Future<List<Task>> _tasksFuture;
  late File imageAnswer ;
  
 @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the widget is initialized
  }

  void _loadTasks() {
    // Fetch tasks asynchronously
    _tasksFuture = TaskService.getTasksByUsername("childTest");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture, // Use the Future to fetch tasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to load, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, show an error message
            return Center(child: Text('Error loading tasks: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data is available or the list is empty, show a message
            return Center(child: Text('No tasks found'));
          } else {
            // If data is available, display the list of tasks
            final List<Task> tasks = snapshot.data!;
            return GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust number of columns
          crossAxisSpacing: 8, // Horizontal space between cards
          mainAxisSpacing: 8, // Vertical space between cards
          childAspectRatio: 1.5, // Adjust card size
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
             onTap: () => _showTaskPopup(context, task),
           );
              },
            );
          }
        },
      ),
    );
  }


  void _showTaskPopup(BuildContext context, Task task) {
  switch (task.validationType) {
    case "QuestionAnswer":
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String userAnswer = ''; // Store the user's answer here
          
          return AlertDialog(
            title: Text(task.title),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200), // Set maximum height
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(task.qcmQuestion),
                    SizedBox(height: 16),
                    Container(
                      height: 100, // Set initial height
                      child: TextField(
                        maxLines: null, // Allow unlimited lines
                        onChanged: (value) {
                          userAnswer = value; // Update the user's answer
                        },
                        decoration: InputDecoration(
                          hintText: 'Your answer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  // Do something with userAnswer, e.g., validate it
                  // You can access the user's answer from here
                  print('User answer: $userAnswer');
                  TaskService.updateTaskAnswer(task.id,userAnswer);
                  TaskService.updateTaskStatus(task.id);
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
      break;
 case "Photo":
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(task.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('This is a photo task. Placeholder content.'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text('Upload Photo'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  // Do something with userAnswer, e.g., validate it
                  // You can access the user's answer from here
                  TaskService.updateTaskPhoto("65edabefed36477a7afd298e",imageAnswer.toString());
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
      break;
     case "QCM":
  // Assuming you have your task and context setup
  Map<String, dynamic> qcmData = task.getQcmOptionsAndCorrectAnswer();
  String? correctAnswer = qcmData['correctAnswer'];
  List<String> options = qcmData['options'];

  // Find the index of the correct answer in the options
  int correctAnswerIndex = options.indexOf(correctAnswer!);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isAnswerChecked = false; // Tracks if answer has been checked
      int selectedValue = -1; // -1 represents no selection

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(task.title),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int idx) {
                  String option = options[idx];

                  bool isCorrectAnswer = idx == correctAnswerIndex;
                  bool isSelected = idx == selectedValue;
                  bool showCorrectness = isAnswerChecked && isSelected;

                  // Determine the color based on the selection correctness
                  Color tileColor = Colors.black; // Default color before answer check
                  if (isAnswerChecked) {
                    if (isSelected && !isCorrectAnswer) {
                      tileColor = Colors.red; // Incorrect selection
                    } else if (isCorrectAnswer) {
                      tileColor = Colors.green; // Correct answer always in green
                    }
                  }

                  return RadioListTile<int>(
                    title: Text(option, style: TextStyle(color: tileColor)),
                    secondary: showCorrectness
                        ? (isCorrectAnswer ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red))
                        : null,
                    value: idx,
                    groupValue: selectedValue,
                    onChanged: (int? value) {
                      if (!isAnswerChecked) { // Allow changing selection only if answer hasn't been checked
                        setState(() {
                          selectedValue = value!;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              if (!isAnswerChecked) // Show check button only if answer hasn't been checked
                TextButton(
                  onPressed: () {
                    setState(() {
                      isAnswerChecked = true; // Mark the answer as checked
                      if (selectedValue == correctAnswerIndex) {
                        print("Correct Answer Selected");
                        TaskService.updateTaskScore(task.id, 1); // Correct answer
                      } else {
                        print("Incorrect Answer Selected");
                        TaskService.updateTaskScore(task.id, 0); // Incorrect answer
                      }
                    });
                  },
                  child: Text('Check Answer'),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );

  break;

  }
}
 Future pickImage() async {
   /* try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 1);

      if (image == null) return;
      final imageTemp = File(image.path);
      // Reference ref = FirebaseStorage.instance.ref().child(uuid.v1());
      // await ref.putFile(imageTemp);
      // ref.getDownloadURL().then((value) {
      //   setState(() {
      //     image = imageTemp as XFile?;
      //     imageUrl = value;
      //   });
      //   if (kDebugMode) {
      //     print(value);
      //   }
      // });

      setState(() {
        this.imageAnswer = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }*/
  }
}

/*
void _pickImage(BuildContext context, Task task) async {
  final picker = ImagePicker();
  final File? pickedFile = await picker.pickImage(); // Use ImageSource.camera for camera access
  
  if (pickedFile != null) {
    // Handle the picked image, for example, you can display it or process it further
    File imageFile = File(pickedFile.path);
    // Process the image file as needed
    print('Picked image path: ${imageFile.path}');
  } else {
    // Handle no image selected
    print('No image selected');
  }
}

ImagePicker() {
}
*/