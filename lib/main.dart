import 'package:flutter/material.dart';
import './pages/WishProducts.dart';
import './pages/ParentProduct.dart';

void main() {
  runApp(WishProducts());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        // Your app's theme
      ),
      home: ParentProduct(), // Your ParentProduct widget as the home
    );
  }
}
