import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart'; // Needed for Colors and Icons
import 'package:get/get.dart';

import '../../feature/navigation/presentation/controllers/nav_controller.dart';

// 1. Initialize the local notifications plugin globally
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Background message: ${message.messageId}");
}

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  // --- THE ROUTING BRAIN ---
  void _handleNotificationClick(Map<String, dynamic> data) {
    print("🔥 Notification Clicked! Payload Data: $data");

    // Let's say we send a key called "target_tab" from Firebase
    if (data.containsKey('target_tab')) {
      int tabIndex = int.parse(data['target_tab'].toString());

      // 1. Ensure the user is actually on the Main Navigation screen
      if (Get.currentRoute != '/main') {
        Get.offAllNamed('/main');
      }

      // 2. We use a tiny delay to ensure the NavController is loaded in memory
      // after the screen transition, then we swap the tab!
      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.isRegistered<NavController>()) {
          Get.find<NavController>().changePage(tabIndex);
        }
      });
    }
  }

  Future<void> initialize() async {
    // Request Permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Get Token
    try {
      final fcmToken = await _messaging.getToken();
      print('🔥 FCM Device Token: $fcmToken');
    } catch (e) {
      print('❌ Error: $e');
    }

    // 2. Setup the Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    // 3. Initialize Local Notifications
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    // 🚨 FIX 1: Only pass the named parameter, nothing else!
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // 4. Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Foreground Handler (The "Teams Style" In-App Toast)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        Get.snackbar(
          notification.title ?? 'New Alert',
          notification.body ?? '',
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          colorText: Colors.black87,
          icon: const Icon(Icons.notifications_active, color: Colors.amber),

          // 🚨 ADD THIS: When the user taps the GetX Snackbar!
          onTap: (snack) {
            _handleNotificationClick(message.data);
          },
        );
      }
    });

    // ==========================================
    // STATE 2: BACKGROUND (App is minimized)
    // ==========================================
    // This fires when the user taps the native Android system tray banner
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });

    // ==========================================
    // STATE 3: TERMINATED (App is completely killed)
    // ==========================================
    // This fires when the app cold-boots from a notification tap.
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // 🚨 Since the app just cold-booted, GetX needs a second to draw the UI
      // before we force a navigation route. We delay it by 1.5 seconds.
      Future.delayed(const Duration(milliseconds: 1500), () {
        _handleNotificationClick(initialMessage.data);
      });
    }

    // Register Background Handler (Keep this at the bottom)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }
}