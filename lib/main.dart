import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'core/routes/app_page.dart';
import 'core/routes/app_route.dart';
import 'core/services/push_notification_service.dart';
import 'feature/auth/presentation/bindings/auth_binding.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Ensure the Flutter engine is fully awake
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wake up Firebase using the platform-specific settings
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Face Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      initialBinding: AuthBinding(),
      // GetX Routing Setup
      initialRoute: AppRoutes.login, // Start at login
      getPages: AppPages.pages,      // Give it the map
    );
  }
}