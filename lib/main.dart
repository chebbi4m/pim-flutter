import 'package:flutter/material.dart';
import 'package:wishlist/pages/TaskDetailsPage.dart';
import './pages/WishProducts.dart';
import './pages/ParentProduct.dart';
import './pages/ChildTasks.dart';

void main() {
  runApp(ParentTask());
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
