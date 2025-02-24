import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ecommerce_f/screens/auth/splash_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: CardTheme(
          color: AppConstant.appTextColor,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            foregroundColor: WidgetStatePropertyAll(AppConstant.appMainColor),
            side: WidgetStatePropertyAll(
              const BorderSide(color: AppConstant.appMainColor, width: 1),
            ),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            )),
          ),
        ),
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
