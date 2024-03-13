// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/models/Notificationsmodel.dart';
import 'package:flutter_application_1/pages/AddChildpage.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/bottomBarWidget.dart';
import 'package:flutter_application_1/pages/notificationpage.dart';
import 'package:flutter_application_1/pages/silverappBarwidget.dart';
import 'package:provider/provider.dart';
import './barparent.dart';
import './marketproductsparent.dart';

class Mainskeletonchild extends StatefulWidget {
  @override
  _MainskeletonState createState() => _MainskeletonState();
}

class _MainskeletonState extends State<Mainskeletonchild> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    WalletPage(),
    
    ReelsPage(),
    MarketPage(),
   
  ];
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double menuWidth = screenWidth * 0.35;
    return Scaffold(
      appBar: sliverAppBarWidget(),
      body: Consumer<BottomNavigationIndexProvider2>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Consumer<NotificationProvider>(
                  builder: (context, notificationprovider, _) {
                if ((notificationprovider.isLoading == null) &&
                    (notificationprovider.isLoading != true) && notificationprovider.notifs.isEmpty ) {
                  // Fetch children if they are not already loading and the list is empty
                   notificationprovider.fetchnotifications();
                }

                // Display loading indicator while loading
                if ((notificationprovider.isLoading != null) &&
                    (notificationprovider.isLoading == true)) {
                  return Center(
            child: CircularProgressIndicator(),
          );
                } else {
                  return SafeArea(
                    top: false,
                    child: Stack(
                      children: [
                        NotificationWidget(),
                        AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: notificationprovider.isMenuOpen
                                ? 0
                                : screenWidth - menuWidth,
                            child: SizedBox(
                                width: screenWidth,
                                height: screenHeight,
                                child: _pages[provider._selectedIndex])),
                      ],
                    ),
                  );
               }
              }),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Container(
                  width: double.infinity,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Color(0x00EEEEEE),
                  ),
                  child: BottomBarWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomNavigationIndexProvider2 with ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  void onTabTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
