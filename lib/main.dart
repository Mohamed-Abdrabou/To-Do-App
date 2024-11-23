import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/style/AppStyle.dart';
import 'package:todoapp/ui/HomeScreen/HomeScreen.dart';
import 'package:todoapp/ui/HomeScreen/widgets/Edit_Task.dart';
import 'package:todoapp/ui/Login_Screen/login_Screen.dart';
import 'package:todoapp/ui/Splash_Screen/Splash_Screen.dart';
import 'package:todoapp/ui/register/register_screen.dart';
import 'firebase_options.dart';
import 'package:todoapp/ui/Splash_Screen/Splash_Screen.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppStyle.lightTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        SplashScreen.routeName: (_)=> SplashScreen(),
        EditTask.routeName : (_)=> EditTask()
      },
    );
  }
}
