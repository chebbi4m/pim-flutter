import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/ChildListpage.dart';
import 'package:flutter_application_1/pages/silverappBarwidget.dart';
import './barparent.dart';
import './marketproductsparent.dart';

class Mainskeleton extends StatefulWidget {
  @override
  _MainskeletonState createState() => _MainskeletonState();
}

class _MainskeletonState extends State<Mainskeleton> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    MyHomePage(title: 'Home'),
    WalletPage(),
    ChildListWidget(),
    ReelsPage(),
    MarketPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, _) => [sliverAppBarWidget()],
        body:Stack(
                    children: [ _pages[_selectedIndex],
     Align(
                        alignment: AlignmentDirectional(0, 1),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Color(0x00EEEEEE),
                          ),
                   
                        
                   
                      
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 1),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1FAFD),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x1A57636C),
                              offset: Offset(0, -10),
                              spreadRadius: 0.1,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: IconButton(
                      icon: Icon(
                        Icons.home_rounded,
                        color: Color(0xFF17233D),
                        size: 24,
                      ),
                      onPressed: () {
                        print('homebutton preeeeeeeeessed ...');
                        _onItemTapped(0);
                      },
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: IconButton(
                      icon: Icon(
                        Icons.task_alt,
                        color: Color(0xFF17233D),
                        size: 24,
                      ),
                      onPressed: () {
                        print('taskbutton pressed ...');
                        _onItemTapped(1);
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            color: Color(0xFFFFE27D),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.family_restroom,
                              color: Color(0xFF17233D),
                              size: 30,
                            ),
                            onPressed: () {
                              print('familybutton pressed ...');
                              _onItemTapped(2);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: IconButton(
                      icon: Icon(
                        Icons.movie_outlined,
                        color: Color(0xFF17233D),
                        size: 24,
                      ),
                      onPressed: () {
                        print('reelsbutton pressed ...');
                        _onItemTapped(3);
                      },
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: IconButton(
                      icon: Icon(
                        Icons.museum_sharp,
                        color: Color(0xFF17233D),
                        size: 24,
                      ),
                      onPressed: () {
                        print('marketbutton pressed ...');
                       _onItemTapped(4);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
                        ),
     ),
                    ],
        ),
      ),  
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
