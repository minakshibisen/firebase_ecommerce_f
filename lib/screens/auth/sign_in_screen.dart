import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/controllers/get_user_data_controller.dart';
import 'package:firebase_ecommerce_f/controllers/sign_in_controller.dart';
import 'package:firebase_ecommerce_f/screens/admin-panel/admin_dashboard_screen.dart';
import 'package:firebase_ecommerce_f/screens/auth/sign_up_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/input_field.dart';
import '../user-panel/main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.08),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Lottie.asset('assets/images/splash.json'),
                ),
                SizedBox(height: size.height * 0.05),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appTextColor),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please login or sign up to continue our app',
                    style: TextStyle(
                        fontSize: 14, color: AppConstant.appTextColor),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                FadeInRight(
                  child: InputFieldWidget(
                    hintText: 'Email',
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                FadeInLeft(
                  child: InputFieldWidget(
                    hintText: 'Password',
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                FadeInUpBig(
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar("Error!!", "please enter all detail!!!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appSecondaryColor);
                        } else {
                          UserCredential? userCredential =
                          await signInController.signInMethod(
                            email,
                            password,
                          );
                          var userData = await getUserDataController
                              .getUserData(userCredential!.user!.uid);

                          if (userCredential.user!.emailVerified) {
                            if (userData[0]['isAdmin'] == true) {
                              Get.snackbar(
                                  "Success ", "Admin Login SuccessFull",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appMainColor,
                                  colorText: AppConstant.appSecondaryColor);
                              Get.offAll(() => AdminDashboardScreen());
                            } else {
                              Get.offAll(() => MainScreen());
                            }
                          } else {
                            Get.snackbar("Error",
                                "please verify your email before login",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appMainColor,
                                colorText: AppConstant.appSecondaryColor);
                          }

                          FirebaseAuth.instance.signOut();
                          Get.offAll(() => MainScreen());
                        }
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                      },
                      child: Text(
                        'SignIn',
                        style: TextStyle(color: AppConstant.appMainColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Sign Up Link
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppConstant.appTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
