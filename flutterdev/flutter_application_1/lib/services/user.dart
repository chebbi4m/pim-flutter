import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Import the user model

class AuthService {
  static Future<User> signIn(String identifier, String password) async {
    try {
      var url = Uri.parse('http://10.0.2.2:9090/signin');
      var response = await http.post(url, body: {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        // Password reset email sent successfully
        final jsonResponse = json.decode(response.body);
        final username = jsonResponse['Username'];
        final email = jsonResponse['Email'];
        final number = jsonResponse['PhoneNumber'];

        print(username);
        // Store the reset code in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('Email', email);
        prefs.setInt('number', number);

        print('Reset code: $username');
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to sign in: $error');
    }
  }

  static Future<String> sendPasswordResetEmail(String email) async {
    final Uri uri = Uri.parse('http://10.0.2.2:9090/forgot-password');
    final Map<String, String> requestBody = {'email': email};

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Password reset email sent successfully
        final jsonResponse = json.decode(response.body);
        final resetCode = jsonResponse['resetCode'];

        // Store the reset code in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('resetCode', resetCode);
        prefs.setString('email', email);
        print('Reset code: $resetCode');

        return 'Password reset email sent successfully';
      } else if (response.statusCode == 404) {
        return 'User not found';
      } else if (response.statusCode == 401) {
        return 'Your email is not verified yet, please verify your email first';
      } else {
        return 'Failed to send password reset email';
      }
    } catch (e) {
      print('Error sending password reset email: $e');
      return 'Internal server error';
    }
  }

  static Future<String> resetPassword(String email, String newPassword) async {
    final Uri uri = Uri.parse('http://10.0.2.2:9090/update-password');
    final Map<String, String> requestBody = {
      'email': email,
      'newPassword': newPassword,
    };

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return 'Password reset successfully';
      } else {
        return 'Failed to reset password';
      }
    } catch (e) {
      print('Error resetting password: $e');
      return 'Internal server error';
    }
  }
}
