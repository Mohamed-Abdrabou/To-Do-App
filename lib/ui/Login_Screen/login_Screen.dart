import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/style/FirebaseAuthCode.dart';
import 'package:todoapp/style/reusable_components/CustomErrorDialog.dart';
import 'package:todoapp/ui/HomeScreen/HomeScreen.dart';
import 'package:todoapp/ui/register/register_screen.dart';
import '../../style/constants.dart';
import '../../style/reusable_components/CustomButton.dart';
import '../../style/reusable_components/CustomFormField.dart';
import '../../style/reusable_components/CustomLoadingDialog.dart';
import 'package:todoapp/firestore/model/User.dart' as myUser;
class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Customformfield(
                      label: "Email Address",
                      keybord: TextInputType.emailAddress,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!Constants.isValidEmail(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 0.03 * height,
                    ),
                    Customformfield(
                      label: "Password",
                      keybord: TextInputType.visiblePassword,
                      isPassword: true,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password should be at least 6 ";
                        }
                      },
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 0.03 * height,
                    ),
                    Custombutton(
                        lable: "Login",
                        btnClick: () {
                          login();
                        }),
                    SizedBox(
                      height: 0.02 * height,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: Text("or create a new account")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState?.validate() == true) {
      try {
        showDialog(
            context: context, builder: (context) => CustomLoadingDialog());
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text);
        print(credential.user!.email);
        print(credential.user!.uid);
        myUser.User? user= await FirestoreHandler.readUser(credential.user!.uid);
        print("Age:${user?.age}");
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == FirebaseAuthCode.usrsNotFound) {
          showDialog(
              context: context,
              builder: (context) => CustomErrorDialog(
                    message: 'No user found for that email.',
                    postiveBtnPress: () {
                      Navigator.pop(context);
                    },
                  ));
        } else if (e.code == FirebaseAuthCode.wrongPassword) {
          showDialog(
              context: context,
              builder: (context) => CustomErrorDialog(
                    message: 'Wrong password provided for that user.',
                    postiveBtnPress: () {
                      Navigator.pop(context);
                    },
                  ));
        }
      }
    }
  }
}
