// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create storage

class ChildApi {
  final storage = FlutterSecureStorage();

  final String baseUrl =
      'http://10.0.2.2:9090/api/child'; // Replace with your API base URL

  Future<void> createChild(Child child2) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    
    child2.parentId = userId!;
   
    final url =
        Uri.parse('$baseUrl/add'); // Replace with your create child endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(child2);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);

// Write value
        await storage.write(
          key: "crypt:${child2.username}",
          value: responsedata["encrypted"],
          aOptions: _getAndroidOptions(),
        );
        await storage.write(
            key: "iv:${child2.username}",
            value: responsedata["iv"],
            aOptions: _getAndroidOptions());
        String? value = await storage.read(
            key: "crypt:${child2.username}", aOptions: _getAndroidOptions());
        print(
            'Child created successfully his private key crypted is :${value}');
      } else {
        print('Failed to create child: ${response.body}');
      }
    } catch (error) {
      print('Error creating child: $error');
    }
  }

  Future<List<Child>> getChildren() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    
    
    final response =
        await http.get(Uri.parse('$baseUrl/getallchildrenbyparent/$userId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((child) => Child.fromJson(child)).toList();
    } else {
      throw Exception('Failed to load children');
    }
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}
