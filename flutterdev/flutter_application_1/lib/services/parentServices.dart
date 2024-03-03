import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerParent(
    String username, String email, String password, String phoneNumber) async {
  try {
    final url = Uri.parse('http://10.0.2.2:9090/parent/register');
    final Map<String, String> body = {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body), // Encode body to JSON string
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Extracting data from the response
      final String encrypted = responseData['encrypted'];
      final String iv = responseData['iv'];
      final String responseUsername = responseData['parent']['username'];
      final String responseEmail = responseData['parent']['email'];
      final bool verified = responseData['parent']['verified'];

      // Save data to shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('encrypted', encrypted);
      await prefs.setString('iv', iv);
      await prefs.setString('username', responseUsername);
      await prefs.setString('email', responseEmail);
      await prefs.setBool('verified', verified);

      print('Registration successful');
    } else {
      print('Registration failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error registering user: $error');
  }
}
