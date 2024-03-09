import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:noti_test/notification_controller.dart';

late String fcmToken;

@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage message) async {
  // NotificationService.show(title: message.notification!.title!, body: message.notification!.body!, payload: Map<String,String>.from(message.data));
  NotificationService.show(
      title: message.data['title'], body: message.data['body']);
}

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final token = await getToken();

    fcmToken = token ?? '';

    debugPrint('Token : $token');

    FirebaseMessaging.onBackgroundMessage(handleMessage);

    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
