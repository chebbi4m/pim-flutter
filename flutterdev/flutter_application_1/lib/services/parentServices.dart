import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerParent(
    String username, String email, String password, String phoneNumber) async {
  try {
    final url = Uri.parse('http://127.0.0.1:9090/parent/register');
    final Map<String, String> body = {
      'Username': username,
      'Email': email,
      'Password': password,
      'PhoneNumber': phoneNumber,
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
      final String responseUsername = responseData['parent']['Username'];
      final String responseEmail = responseData['parent']['Email'];
      final bool verified = responseData['parent']['Verified'];

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
