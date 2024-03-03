import 'package:flutter/material.dart';

class RegistrationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Successful"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Congratulations! Your registration was successful.",
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
