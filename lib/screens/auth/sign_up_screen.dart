import 'package:animate_do/animate_do.dart';
import 'package:firebase_ecommerce_f/screens/auth/sign_in_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  // Controllers for Input Fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
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
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    cityController.dispose();
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
              children: [
                SizedBox(height: size.height * 0.10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppConstant.appTextColor),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please login or sign up to continue our app',
                    style: TextStyle(fontSize: 14, color: AppConstant.appTextColor),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // Input Fields
                FadeInLeft(
                  child: InputFieldWidget(
                    hintText: 'Email',
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    controller: emailController, obscureText: false,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                FadeInRight(
                  child: InputFieldWidget(
                    hintText: 'User Name',
                    icon: Icons.person,
                    textInputAction: TextInputAction.next,
                    controller: usernameController, obscureText: false,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                FadeInLeft(
                  child: InputFieldWidget(
                    hintText: 'Phone',
                    icon: Icons.phone,
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    keyboardType: TextInputType.phone, obscureText: false,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                FadeInRight(
                  child: InputFieldWidget(
                    hintText: 'Password',
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                FadeInLeft(
                  child: InputFieldWidget(
                    hintText: 'City',
                    icon: Icons.location_city,
                    textInputAction: TextInputAction.done,
                    controller: cityController, obscureText: false,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // Sign In Button
              FadeInUpBig(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                    },
                    child: const Text(
                      'SignUp',
                      style: TextStyle(fontSize: 18),
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
                    },
                    child: const Text(
                      "Don't have an account? SignIn",
                      style: TextStyle(fontSize: 14, color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
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
