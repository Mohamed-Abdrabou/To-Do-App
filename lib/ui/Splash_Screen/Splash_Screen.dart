import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/ui/Login_Screen/login_Screen.dart';

import '../HomeScreen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "splash";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      navigateToInitialScreeen();
    });
    super.initState();
  }

  navigateToInitialScreeen() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: Image.asset(
              "assets/images/logo.png",
               height: 0.2*height,
               width: 0.37*width,
               fit: BoxFit.fill ,
          ).animate().scale(
            curve: Curves.fastOutSlowIn,
            duration: Duration(
              seconds: 2
            )
          )),
    );
  }
}
