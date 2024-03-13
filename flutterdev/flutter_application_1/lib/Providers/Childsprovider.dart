// child_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:flutter_application_1/services/ChildsApi.dart'; // Import your ChildService

class ChildProvider extends ChangeNotifier {
  final ChildApi _childService = ChildApi();
  List<Child> _children = [];
  List<Child> get children => _children;

  bool? isLoading;
  Future<void> createChild(Child child) async {
    try {
      await _childService.createChild(child);
      _children.add(child);
      // Notify listeners to update UI if needed
      notifyListeners();
    } catch (error) {
      print('Failed to create child: $error');
    }
  }

  Future<void> fetchChildren() async {
    try {
      isLoading = true;
      _children = await _childService.getChildren();

      isLoading = false;
      print(_children);
      notifyListeners();
    } catch (e) {
      print('Error fetching children: $e');
    }
  }
}
