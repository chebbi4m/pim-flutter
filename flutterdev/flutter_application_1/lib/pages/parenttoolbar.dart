import 'package:flutter/material.dart';
import './barparent.dart';
import './marketproductsparent.dart';

class MyParentMarket extends StatefulWidget {
  @override
  _MyParentMarketState createState() => _MyParentMarketState();
}

class _MyParentMarketState extends State<MyParentMarket> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    MarketPage(),
    ReelsPage(),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Color.fromARGB(255, 255, 227, 125),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, 
        selectedItemColor: Colors.black,
        unselectedItemColor: Color.fromARGB(
            255, 56, 169, 194),
        onTap: _onItemTapped, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar_kids.png'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
