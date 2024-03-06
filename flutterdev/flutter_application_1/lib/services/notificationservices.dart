// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Notificationsmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create storage

class notificationservices {
  // final storage = FlutterSecureStorage();

  final String baseUrl =
      'http://10.0.2.2:9090/api/notifications'; // Replace with your API base URL

  Future<void> createnotification(notification notif) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    notif.recipientId = userId;
    final url =
        Uri.parse('$baseUrl/add'); // Replace with your create child endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(notif);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);

// Write value

        print(
            'notif created successfully his private key crypted is :${responsedata['recipientId']}');
      } else {
        print('Failed to create child: ${response.body}');
      }
    } catch (error) {
      print('Error creating child: $error');
    }
  }

  Future<List<notification>> getnotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(Uri.parse('$baseUrl/$userId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((notif) => notification.fromJson(notif)).toList();
    } else {
      throw Exception('Failed to load children');
    }
  }
}
