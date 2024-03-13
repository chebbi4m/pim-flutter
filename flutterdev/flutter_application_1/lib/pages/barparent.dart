import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/paymentProvider.dart';
import 'package:flutter_application_1/controller/updateProfileProvider.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/pages/header_widget.dart';
import 'package:flutter_application_1/pages/web_view_widget.dart';
import 'package:flutter_application_1/theme/theme_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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

class WalletPage extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wallet"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Recharge"),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
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
                        onPressed: () async {
                          int amount =
                              int.tryParse(_amountController.text) ?? 0;
                          // Call the makePayment method from PaymentNotifier
                          final paymentNotifier = Provider.of<PaymentNotifier>(
                              context,
                              listen: false);
                          await paymentNotifier.makePayment(amount);
                          // Navigate to WebViewPage if payment is successful
                          final paymentResult =
                              await paymentNotifier.paymentResult;
                          if (paymentResult.result.success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: paymentResult.result.link,
                                ),
                              ),
                            );
                          } else {
                            // Handle payment failure
                          }
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
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

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  String? username;
  String? phone;
  String? newImage;
  String? address;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? imageUrl;
  File? image;
  var uuid = const Uuid();
  int? storedPhoneNumber;
  String? storedUsername,
      storedEmail,
      number; // Define a variable to store the retrieved username

  @override
  void initState() {
    super.initState();
    getStoredUsername();
    // Call the method to retrieve the stored username
  }

  Future<void> getStoredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedUsername = prefs.getString('username');
      username =
          storedUsername; // Set the username variable with storedUsername
      storedEmail = prefs.getString('Email');
      storedPhoneNumber = prefs.getInt('number');
      number = storedPhoneNumber.toString();
      fullNameController = TextEditingController(text: storedUsername);
      addressController = TextEditingController(text: storedEmail);
      mobileNumberController = TextEditingController(text: number);
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UpdateProfileNotifier>(
        builder: (context, updateProfileNotifier, child) {
          if (updateProfileNotifier.solde.isEmpty) {
            updateProfileNotifier.getsolde(fullNameController.text);
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                const SizedBox(
                  height: 150,
                  child: HeaderWidget(
                    150,
                    false,
                    AssetImage("assets/images/logo.png"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 5,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: CircleAvatar(
                                    radius: 50,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    foregroundImage: image != null
                                        ? FileImage(image!)
                                            as ImageProvider<Object>
                                        : AssetImage(
                                            "assets/images/avatar_kids.png"),
                                  ),
                                ),
                              ),
                              if (image != null)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      radius: 50,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      foregroundImage: FileImage(image!),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    90,
                                    90,
                                    0,
                                    0,
                                  ),
                                  child: const Icon(
                                    Icons.add_circle,
                                    color: Color.fromARGB(255, 255, 227, 125),
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Assuming storedUsername is a String variable

                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            enabled: false,
                            controller: fullNameController,
                            onChanged: (value) {
                              username = value;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                              'Username',
                              'Please enter your user name',
                              GestureDetector(
                                child: const Icon(Icons.person),
                              ),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your user name";
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: mobileNumberController,
                            maxLength: 8,
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                              'Phone number',
                              "Enter your mobile number",
                              GestureDetector(
                                child: const Icon(Icons.phone),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: addressController,
                            onChanged: (value) {
                              address = value;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                              "Email",
                              "Enter your email",
                              GestureDetector(
                                child: const Icon(Icons.mail),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            onPressed: () async {
                              int number =
                                  int.tryParse(mobileNumberController.text) ??
                                      0;
                              mobileNumberController.text;

                              // Call the updateProfile method
                              bool updateSuccess =
                                  await updateProfileNotifier.updateProfile(
                                fullNameController.value.text,
                                addressController.text,
                                number,
                                imageUrl ?? "2",
                              );

                              Get.back(); // Close bottom sheet

                              // Show success dialog if the update was successful
                              if (updateSuccess) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Success'),
                                      content:
                                          Text('Profile updated successfully!'),
                                      actions: [
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "update".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Text(
                            'Your balance:${updateProfileNotifier.solde} SPT',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 20,
                              color: Color(0xFF17233D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WalletPage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Icon(
                                  Icons.payments_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future pickImage() async {
    try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 1);

      if (image == null) return;
      final imageTemp = File(image.path);
      // Reference ref = FirebaseStorage.instance.ref().child(uuid.v1());
      // await ref.putFile(imageTemp);
      // ref.getDownloadURL().then((value) {
      //   setState(() {
      //     image = imageTemp as XFile?;
      //     imageUrl = value;
      //   });
      //   if (kDebugMode) {
      //     print(value);
      //   }
      // });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }
}
