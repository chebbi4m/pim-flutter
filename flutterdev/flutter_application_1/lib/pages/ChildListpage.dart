// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/Childsprovider.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/pages/AddChildpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChildListWidget extends StatefulWidget {
  const ChildListWidget({super.key});

  @override
  State<ChildListWidget> createState() => _ChildListWidgetState();
}

class _ChildListWidgetState extends State<ChildListWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
/*
  final animationsMap = {
    'rowOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1190.ms,
          begin: Offset(0, -34),
          end: Offset(0, 0),
        ),
      ],
    ),
    'iconOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1190.ms,
          begin: Offset(0, -34),
          end: Offset(0, 0),
        ),
      ],
    ),
    'iconOnActionTriggerAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        RotateEffect(
          curve: Curves.easeOut,
          delay: 1.ms,
          duration: 860.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
    'iconOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        RotateEffect(
          curve: Curves.easeOut,
          delay: 1.ms,
          duration: 860.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
    'iconOnActionTriggerAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        RotateEffect(
          curve: Curves.easeOut,
          delay: 1.ms,
          duration: 860.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
    'iconOnActionTriggerAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        RotateEffect(
          curve: Curves.easeOut,
          delay: 1.ms,
          duration: 860.ms,
          begin: 1,
          end: 0,
        ),
      ],
    ),
  };*/

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Consumer<ChildProvider>(builder: (context, childProvider, _) {
       if ((childProvider.isLoading==null) && (childProvider.isLoading!=true) && childProvider.children.isEmpty) {
          // Fetch children if they are not already loading and the list is empty
          childProvider.fetchChildren();
        }

        // Display loading indicator while loading
        if ((childProvider.isLoading!=null) && (childProvider.isLoading==true)) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }  else {
          return NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                expandedHeight: 70,
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                shadowColor: const Color(0xFF17233D),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 13,
                        color: Color.fromARGB(26, 0, 0, 0),
                        offset: Offset(10, 10),
                        spreadRadius: 0.5,
                      )
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(top: 40),
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Kidscoin',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17233D),
                        ),
                      ),
                    ),
                  ),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: const Icon(
                    Icons.menu,
                    color: Color(0xFF17233D),
                    size: 30,
                  ),
                ),
                actions: [
                  Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                            child: FaIcon(
                              FontAwesomeIcons.solidMoon,
                              color: Color(0xFF17233D),
                              size: 22,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/Asset 1-8.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                centerTitle: true,
                elevation: 28,
              )
            ],
            body: Consumer<ChildProvider>(
              builder: (context, childProvider, _) {
                // Use data from ChildProvider to build UI
                // For example:
                // Text('${childProvider.childData.username}')
                return SafeArea(
                  top: false,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 2.2),
                        child: Container(
                          width: screenWidth, // Set width to screen width
                          height: screenHeight * 0.5,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE27D),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(300),
                              topRight: Radius.circular(300),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.03, -0.92),
                        child: Text(
                          'Your Childrens',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                          topLeft: Radius.circular(35),
                                          topRight: Radius.circular(35),
                                        ),
                                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                        print('IconButton pressed ...');
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
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                              print('IconButton pressed ...');
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
                                        print('IconButton pressed ...');
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
                                        print('IconButton pressed ...');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, -0.3),
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              initialPage: 2,
                              viewportFraction: 0.40,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.65,
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.horizontal,
                              autoPlay: false,
                            ),
                            items: childProvider.children.map((child) {
                              return Builder(builder: (BuildContext context) {
                                return Align(
                                  alignment: AlignmentDirectional(-0.65, -0.65),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 217,
                                      height: 324,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF8CD1D9),
                                            Color(0xFFF9FEFF)
                                          ],
                                          stops: [0, 1],
                                          begin: AlignmentDirectional(0.34, -1),
                                          end: AlignmentDirectional(-0.34, 1),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 5, 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .remove_circle_outline_sharp,
                                                  color: Color(0xFFAD0101),
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment:
                                                  AlignmentDirectional(0, -1),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 14, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Container(
                                                          width: 140,
                                                          height: 150,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Image.asset(
                                                            'assets/images/${child.image}',
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 5, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5, 0, 5, 0),
                                                        child: Text(
                                                          child.username,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Readex Pro',
                                                            color: Color(
                                                                0xFF17233D),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 25, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.history_sharp,
                                                    color: Color(0xFF17233D),
                                                    size: 45,
                                                  ).animate(),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            1, 0),
                                                    child: Icon(
                                                      Icons.payments_outlined,
                                                      color: Color(0xFF17233D),
                                                      size: 45,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }).toList(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.03, 0.71),
                        child: Text(
                          'add a new child to the family ',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Align(
                          alignment: AlignmentDirectional(-0.01, 0.57),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddChildWidget()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                // Make button transparent
                                // Remove elevation
                                padding: EdgeInsets.zero, // Remove padding
                                // Make button circular
                              ),
                              child: Icon(
                                Icons.add,
                                color: Color(0xFF17233D),
                                size: 50,
                              ),
                            ),
                          )),
                      Container(),
                    ],
                  ),
                );
              },
            ),
          );
        }
        ;
      }),
    ));
  }
}
