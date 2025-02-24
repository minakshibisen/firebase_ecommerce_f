import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/controllers/get_user_data_controller.dart';
import 'package:firebase_ecommerce_f/screens/admin-panel/admin_dashboard_screen.dart';
import 'package:firebase_ecommerce_f/screens/auth/welcome_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/main_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => WelcomeScreen());
      } else {
        checkUserRole(user);
      }
    });
  }

  Future<void> checkUserRole(User user) async {
    try {
      final GetUserDataController getUserDataController = Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user.uid);

      if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminDashboardScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      navigateToWelcomeScreen(); // Fallback
    }
  }

  void navigateToWelcomeScreen() {
    Get.offAll(() => WelcomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Lottie.asset('assets/images/splash.json'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              AppConstant.appPoweredBy,
              style: TextStyle(
                fontSize: 12,
                color: AppConstant.appTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
