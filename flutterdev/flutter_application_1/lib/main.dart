import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:flutter_application_1/controller/updateProfileProvider.dart';
import 'package:flutter_application_1/pages/web_view_widget.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/user.dart';
import '../models/user.dart';
import '../pages/parentmarket.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PaymentNotifier()),
      ChangeNotifierProvider(create: (context) => UpdateProfileNotifier()),
    ],
    child: LoginApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: WebViewPage(
          url: 'https://example.com'), // Replace with your desired URL
    );
  }
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''), // Empty title
        centerTitle: true, // Center align title
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Start from the top
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.0), // Add space for the title
              Center(
                child: Text(
                  'The Future For Kids Payment',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF38A9C2), // Specified color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Add space between title and image
              Center(
                child: CircleAvatar(
                  radius: 80.0, // Increase the radius to make the image bigger
                  backgroundImage: AssetImage('assets/images/avatar_kids.png'),
                ),
              ),
              SizedBox(height: 30.0), // Add space between image and form fields
              LoginForm(
                usernameController: _usernameController,
                passwordController: _passwordController,
              ),
              SizedBox(
                  height:
                      10.0), // Add space between login form and additional texts
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to sign up screen
                        // Placeholder for future implementation
                      },
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5.0), // Add space between texts
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  LoginForm({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: widget.usernameController,
          decoration: InputDecoration(
            labelText: 'Username/Email',
          ),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          controller: widget.passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () async {
            String username = widget.usernameController.text;
            String password = widget.passwordController.text;

            if (username.isEmpty || password.isEmpty) {
              // Handle validation error
              return;
            }

            try {
              var user = await AuthService.signIn(username, password);
              // Handle successful login
              print('Logged in: $user');

              // Check user role
              if (user.role != "parent" && user.role != "child") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Login Failed'),
                      content:
                          Text('You are not authorized to access this app.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return; // Stop further execution
              }

              // Store user data in shared preferences
              await storeUserDataInSharedPreferences(user);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyParentMarket()), // Navigate to the new page
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Login Successful'),
                    content: Text('Welcome, ${user.username}!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(user.username); // Return username
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } catch (error) {
              // Handle login error
              print('Login error: $error');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Login Failed'),
                    content: Text('Failed to login. Please try again later.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF38A9C2), // Background color
            fixedSize: Size(72.0, 36.0), // Adjust width and height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0), // Adjust border radius
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Nerko One',
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> storeUserDataInSharedPreferences(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
  }
}

class ForgotPasswordPage extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Send password reset email
                  String result = await AuthService.sendPasswordResetEmail(
                      _emailController.text);
                  // Show result message (e.g., using a snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                  // Navigate to EnterResetCodePage only if email sent successfully
                  if (result == 'Password reset email sent successfully') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterResetCodePage()),
                    );
                  }
                } catch (e) {
                  // Handle any errors
                  print('Error sending password reset email: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to send reset email. Please try again later.')),
                  );
                }
              },
              child: Text('Send Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterResetCodePage extends StatelessWidget {
  final _resetCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Reset Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _resetCodeController,
              decoration: InputDecoration(labelText: 'Reset Code'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Retrieve stored reset code from shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? storedResetCode = prefs.getString('resetCode');

                // Compare entered reset code with stored reset code
                String enteredResetCode = _resetCodeController.text;
                if (enteredResetCode == storedResetCode) {
                  // Reset code is correct, navigate to ResetPasswordPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()),
                  );
                } else {
                  // Reset code is incorrect, show an error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid reset code'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Verify Reset Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
            SizedBox(height: 20.0),
            if (!_passwordsMatch)
              Text(
                'Passwords do not match',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email');

                // Check if passwords match
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  setState(() {
                    _passwordsMatch = false;
                  });
                  return; // Exit the function early if passwords don't match
                }

                // If passwords match, proceed with password reset
                final result = await AuthService.resetPassword(
                    email!, _passwordController.text);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result)));

                if (result == 'Password reset successfully') {
                  // Clear all navigation history and go back to login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
