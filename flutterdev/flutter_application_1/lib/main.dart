// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:flutter_application_1/controller/updateProfileProvider.dart';
import 'package:flutter_application_1/pages/WishProducts.dart';
import 'package:flutter_application_1/pages/mainskeleton.dart';
import 'package:flutter_application_1/pages/mainskeletonchild.dart';
import 'package:flutter_application_1/pages/widget1.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/user.dart';
import '../models/user.dart';
import 'pages/parenttoolbar.dart';
import 'pages/ChildListpage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/Childsprovider.dart';
import 'package:flutter_application_1/pages/parentRegister.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChildProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavigationIndexProvider()),
                ChangeNotifierProvider(create: (_) => BottomNavigationIndexProvider2()),
        ChangeNotifierProvider(create: (context) => PaymentNotifier()),
        ChangeNotifierProvider(create: (context) => UpdateProfileNotifier()),
      ],
      child: LoginApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Your App Title',
        home: LoginApp() // Replace with your desired URL
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParentRegistrationPage()),
                        );
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
    final GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Define a GlobalKey<FormState> for the form

    return Form(
      key: _formKey, // Assign the _formKey to the Form widget
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: widget.usernameController,
            decoration: InputDecoration(
              labelText: 'Username/Email',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Username/Email is required'; // Return an error message if the field is empty
              }
              return null; // Return null if the validation succeeds
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required'; // Return an error message if the field is empty
              }
              return null; // Return null if the validation succeeds
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Check if the form is valid
                String username = widget.usernameController.text;
                String password = widget.passwordController.text;

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
                          content: Text(
                              'You are not authorized to access this app.'),
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
                  if (user.role == "parent") {
                    // Store user data in shared preferences
                    await storeUserDataInSharedPreferences(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Mainskeleton()), // Navigate to the new page
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
                  } else if (user.role == "child") {
                      await storeUserDataInSharedPreferences(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Mainskeletonchild()), // Navigate to the new page
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
                  }
                } catch (error) {
                  // Handle login error
                  print('Login error: $error');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Login Failed'),
                        content:
                            Text('Failed to login. Please try again later.'),
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
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 253, 224, 116), // Background color
              fixedSize: Size(72.0, 36.0), // Adjust width and height
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18.0), // Adjust border radius
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Nerko One',
                  fontSize: 18.0,
                  color: Color(0xFF17233D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> storeUserDataInSharedPreferences(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email?? '');
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
/*
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/success.dart';
import 'package:provider/provider.dart';

void main() {
   runApp(
    ChangeNotifierProvider(
      create: (_) => MyState(),
      child: MaterialApp(
        title: 'Sliding Drawer Example',
        home: MyHomePage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding Drawer Example',
      home: MyHomePage(),
    );
  }
}
class MyState extends ChangeNotifier {
  late AnimationController _controller;

  MyState() {
    _controller = AnimationController(
      vsync: NavigatorState(),
      duration: Duration(milliseconds: 250),
    );
  }

  AnimationController get controller => _controller;

  void toggleController() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    notifyListeners();
  }
}
class MyHomePage extends StatefulWidget {
  final Widget child =  RegistrationSuccessPage();
  final bool isOpen;
  final Duration animationDuration;
    MyHomePage({
    Key? key,
 
    this.isOpen = false,
    this.animationDuration = const Duration(milliseconds: 250),
  }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage>     
 with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
   final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_controller)
          ..addListener(() => setState(() {}));
    if (widget.isOpen) {
      _controller.forward();
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }






  @override
Widget build(BuildContext context) {
  // Calculate the horizontal offset based on the animation value
  double xOffset = _slideAnimation.value * MediaQuery.of(context).size.width / 2;

  return GestureDetector(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack( 
    
    children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Color.fromARGB(255, 174, 20, 20),
           // Optional background color for tap area
        ),
      // The content that slides
      AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        // Apply translation transformation to slide content horizontally
        transform: Matrix4.translationValues(xOffset, 0.0, 0.0),
        child: widget.child,
        
      ),
      // (Optional) Add a GestureDetector for user interaction
 
    
    ],
  )));
}
}
*//*
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CustomBackButtonExample(),
  ));
}

class CustomBackButtonExample extends StatefulWidget {
  @override
  _CustomBackButtonExampleState createState() =>
      _CustomBackButtonExampleState();
}

class _CustomBackButtonExampleState extends State<CustomBackButtonExample> {
  // Array to store selected indexes
  List<int> selectedIndexes = [0, 1, 2]; // Example initial selection

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (selectedIndexes.isNotEmpty) {
          // Remove the last selected index
          selectedIndexes.removeLast();
          // Perform navigation
          // Replace this logic with your own navigation
          // For example, push to a new screen using Navigator
          print("iiinnnnnnn");
          // Prevent default system back button behavior
          return false;
        }
        // If there are no selected indexes left, allow the back navigation
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Custom Back Button Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selected Index: ${selectedIndexes.last}'),
              ElevatedButton(
                onPressed: () {
                  // Example: Add a new selected index and navigate
                  selectedIndexes.add(selectedIndexes.last + 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectedScreen(index: selectedIndexes.last),
                    ),
                  );
                },
                child: Text('Push New Index'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedScreen extends StatelessWidget {
  final int index;

  const SelectedScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Screen'),
      ),
      body: Center(
        child: Text('Selected Index: $index'),
      ),
    );
  }
}
*/