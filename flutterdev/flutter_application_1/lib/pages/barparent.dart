import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the $title page.'),
      ),
    );
  }
}

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController _amountController = TextEditingController();
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wallet"),
      ),
      body: Consumer<PaymentNotifier>(
        builder: (context, paymentNotifier, child) {
          return Center(
            child: TextButton(
              child: Text("Recharger"),
              onPressed: () {
                // Show bottom sheet for recharging
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Enter Recharge Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Amount",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Parse the amount from the TextField
                            int amount =
                                int.tryParse(_amountController.text) ?? 0;
                            paymentNotifier.makePayment(amount);
                            print("Recharge Amount: ${_amountController.text}");

                            Get.back(); // Close bottom sheet
                          },
                          child: Text("Confirm"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ReelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Reels');
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Profile');
  }
}
