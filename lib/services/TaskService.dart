import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Task.dart';

class TaskService {
 static const String baseUrl = 'http://10.0.2.2:9090';

 static Future<List<Task>> getTasksByUsername(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/task/alltaskschild/$username'));

    if (response.statusCode == 200) {
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
      // If the server returns a 200 OK response, parse the JSON
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load tasks');
    }
  }
  static Future<List<Task>> getTasksByParentName(String Parentname) async {
    final response = await http.get(Uri.parse('$baseUrl/task/alltasksparent/$Parentname'));

    if (response.statusCode == 200) {
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
      // If the server returns a 200 OK response, parse the JSON
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load tasks');
    }
  }
static Future<void> updateTaskStatus(String taskId) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/task/updatestat/$taskId'), // Replace with your server URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        // If you need to pass additional data in the request body, add it here
      }),
    );

    if (response.statusCode == 200) {
      print('Task status updated successfully');
    } else {
      print('Failed to update task status: ${response.reasonPhrase}');
      // Handle error response
    }
  } catch (error) {
    print('Error updating task status: $error');
    // Handle error
  }
}
static Future<void> updateTaskAnswer(String taskId, String answer) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/task/addAnswer/$taskId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'answer': answer,
      }),
    );

    if (response.statusCode == 200) {
      print('Task answer updated successfully');
    } else {
      print('Failed to update task answer: ${response.reasonPhrase}');
      // Handle error response
    }
  } catch (error) {
    print('Error updating task answer: $error');
    // Handle error
  }
}

static Future<void> updateTaskPhoto(String taskId, String photoUrl) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/task/addPhoto/$taskId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'photoUrl': photoUrl,
        }),
      );

      if (response.statusCode == 200) {
        print('Task photo updated successfully');
      } else {
        print('Failed to update task photo: ${response.reasonPhrase}');
        // Handle error response
      }
    } catch (error) {
      print('Error updating task photo: $error');
      // Handle error
    }
  }
  static Future<void> updateTaskScore(String id, int score) async {

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/task/updateScore/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'score': score,
      }),
    );

    if (response.statusCode == 200) {
      print('Task score updated successfully');
    } else {
      print('Failed to update task score: ${response.reasonPhrase}');
      // Handle error response
    }
  } catch (error) {
    print('Error updating task score: $error');
    // Handle error
  }
}
}