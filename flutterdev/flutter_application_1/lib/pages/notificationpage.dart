import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/Providers/Notificationprovider.dart';
import 'package:flutter_application_1/models/Notificationsmodel.dart'; // import your NotificationProvider class

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when the widget is initialized
    Provider.of<NotificationProvider>(context, listen: false).fetchnotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        // Display loading indicator while loading
        if (notificationProvider.isLoading != null && notificationProvider.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            top: false,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Color(0xFFFFE27D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    for (int index = 0; index < notificationProvider.notifs.length; index++)
                      GestureDetector(
                        onTap: () {
                          // Handle tap on notification
                        },
                        child: Text(
                          notificationProvider.notifs[index].content,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF17233D),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
