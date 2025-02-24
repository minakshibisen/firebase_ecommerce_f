import 'package:animate_do/animate_do.dart';
import 'package:firebase_ecommerce_f/controllers/google_sign_in_controller.dart';
import 'package:firebase_ecommerce_f/screens/auth/sign_up_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(seconds: 1),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppConstant.appSecondaryColor,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie.asset(
                      //   'assets/images/splash.json',
                      // ),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 70),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    FadeInLeft(
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            _googleSignInController.signInWithGoogle();
                          },
                          child: Text(
                            'Sign in With google',
                            style: TextStyle(color: AppConstant.appMainColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInRight(
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                          },
                          child: Text(
                            'Sign in With Email',
                            style: TextStyle(color: AppConstant.appMainColor),
                          ),
                        ),
                      ),
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
}
