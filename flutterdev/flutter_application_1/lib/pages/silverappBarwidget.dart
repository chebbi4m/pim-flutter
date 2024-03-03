import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class sliverAppBarWidget extends StatefulWidget {
  const sliverAppBarWidget({super.key});

  @override
  State<sliverAppBarWidget> createState() => _sliverAppBarWidgetState();
}

class _sliverAppBarWidgetState extends State<sliverAppBarWidget>
{
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
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
    );
  }
}