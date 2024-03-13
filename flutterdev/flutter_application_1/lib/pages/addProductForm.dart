import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

// Define the _AddProductScreenState
class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'), // Title for the form
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              TextFormField(
                controller: productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Price is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Type is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String userId = prefs.getString('userId') ??
                          ''; // Retrieve userId from SharedPreferences
                      print('User ID: $userId');
                      // Call the function to get products for the current seller

                      // Create product object from form data
                      final Product product = Product(
                        id: "",
                        productName: productNameController.text,
                        description: descriptionController.text,
                        price: double.parse(priceController.text),
                        type: typeController.text,
                        sellerId: userId, 
                        
                      );

                      // Add product using ProductService
                      final addedProduct =
                          await ProductService.addProduct(context, product);

                      // Handle success
                      print('Product added successfully: $addedProduct');

                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Text('Product added successfully.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Dismiss dialog
                                  Navigator.of(context).pop();
                                  // Dismiss form
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (error) {
                      // Handle error
                      print('Failed to add product: $error');
                    }
                  }
                },
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 56, 169, 194),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
