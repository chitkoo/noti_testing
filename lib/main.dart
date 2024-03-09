import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noti_test/firebase_messaging_service.dart';
import 'package:noti_test/firebase_options.dart';
import 'package:noti_test/notification_controller.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessagingService().initNotifications();
  await NotificationService.initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              postSendNotification();
            },
            child: const Text('Send Push Noti'),
          ),
        ),
      ),
    );
  }
}

var key = 'YOUR_SERVER_KEY';

Future<void> postSendNotification() async {
  await Future.delayed(const Duration(seconds: 5));
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$key'
      },
      body: jsonEncode(<String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'body': 'body',
          'title': 'titleLarge',
          'navigate': 'true'
        },
        'notification': <String, dynamic>{},
        'to': fcmToken
      }),
    );
  } on Exception catch (e) {
    print("Error with sending push notification - $e");
  }
}
