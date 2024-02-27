import 'package:flutter/material.dart';
import '../services/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool _buttonsVisible = true; // Track visibility of both buttons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible:
                  _buttonsVisible, // Show both buttons based on visibility flag
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String userId = prefs.getString('userId') ??
                          ''; // Retrieve userId from SharedPreferences
                      print('User ID: $userId');
                      // Call the function to get products for the current seller
                      String sellerId =
                          userId; // Get the sellerId, possibly from SharedPreferences
                      ProductService.getProducts(context, sellerId)
                          .then((products) {
                        // Handle the products (e.g., navigate to a new page to display them)
                        if (products.isNotEmpty) {
                          setState(() {
                            _buttonsVisible =
                                false; // Hide both buttons after products are loaded
                          });
                        }
                      }).catchError((error) {
                        // Handle any errors
                        print('Error fetching products: $error');
                      });
                    },
                    icon: Icon(Icons.shopping_basket), // Icon for my products
                    label: Text('My Products'), // Text for my products button
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color of button
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0, // Adjust vertical padding
                        horizontal: 30.0, // Adjust horizontal padding
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add space between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle buy a product button tap
                    },
                    icon: Icon(Icons.shopping_cart), // Icon for buy a product
                    label:
                        Text('Buy a Product'), // Text for buy a product button
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Text color of button
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0, // Adjust vertical padding
                        horizontal: 30.0, // Adjust horizontal padding
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
