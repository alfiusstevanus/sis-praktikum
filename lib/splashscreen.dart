import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tubes_prak_app/login.dart';
import 'package:tubes_prak_app/nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<Offset> _logoOffsetAnimation;
  late AnimationController _textAnimationController;
  late Animation<Offset> _textSlideOutAnimation;

  @override
  void initState() {
    super.initState();

    //* Logo Slide-in Animation
    _logoAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _logoOffsetAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));
    _logoAnimationController.forward();

    //* Text Slide-out Animation
    _textAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _textSlideOutAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));
    _textAnimationController.forward();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoOffsetAnimation,
              child: SizedBox(
                width: 172,
                height: 262.6,
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _textSlideOutAnimation,
              child: const Text(
                'Si Bulu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SlideTransition(
              position: _textSlideOutAnimation,
              child: const Text(
                'Online booking Badminton field',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }
}
