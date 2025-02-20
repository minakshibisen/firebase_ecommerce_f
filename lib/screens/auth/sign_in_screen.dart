import 'package:animate_do/animate_do.dart';
import 'package:firebase_ecommerce_f/screens/auth/sign_up_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: AppConstant.appTextColor),
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

                FadeInRight(
                  child: InputFieldWidget(
                    hintText: 'Email',
                    icon: Icons.email,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    obscureText: false,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                FadeInLeft(
                  child: InputFieldWidget(
                    hintText: 'Password',
                    icon: Icons.lock,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

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
                        'SignIn',
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));

                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
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
