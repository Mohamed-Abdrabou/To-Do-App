import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/firestore/model/User.dart';
import 'package:todoapp/style/FirebaseAuthCode.dart';
import 'package:todoapp/style/reusable_components/CustomButton.dart';
import 'package:todoapp/style/reusable_components/CustomErrorDialog.dart';
import 'package:todoapp/style/reusable_components/CustomFormField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/style/reusable_components/CustomLoadingDialog.dart';
import 'package:todoapp/ui/HomeScreen/HomeScreen.dart';
import 'firebase_options.dart';
import '../../style/constants.dart';
import 'package:todoapp/firestore/model/User.dart' as myUser;

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passconController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            "Create Account",
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
                      label: "Full Name",
                      keybord: TextInputType.name,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Plase entre your name";
                        }
                        return null;
                      },
                      controller: nameController,
                    ),
                    SizedBox(
                      height: 0.01 * height,
                    ),
                    Customformfield(
                      label: "Email Address",
                      keybord: TextInputType.emailAddress,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!Constants.isValidEmail(value!)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 0.01 * height,
                    ),
                    Customformfield(
                      label: "Age",
                      keybord: TextInputType.number,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your age";
                        }
                        return null;
                      },
                      controller: ageController,
                    ),
                    SizedBox(
                      height: 0.01 * height,
                    ),
                    Customformfield(
                      label: "phone number",
                      maxLength: 11,
                      keybord: TextInputType.phone,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone";
                        }
                        if (value.length < 11) {
                          return "Plase enter  vaild phone number 11 ";
                        }
                      },
                      controller: phoneController,
                    ),
                    SizedBox(
                      height: 0.01 * height,
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
                      height: 0.01 * height,
                    ),
                    Customformfield(
                      label: "Password Confirmation",
                      keybord: TextInputType.visiblePassword,
                      isPassword: true,
                      validate: (value) {
                        if (value != passwordController.text) {
                          return "Should be same as password";
                        }
                        return null;
                      },
                      controller: passconController,
                    ),
                    SizedBox(
                      height: 0.05 * height,
                    ),
                    Custombutton(
                        lable: "Create Account",
                        btnClick: () {
                          createAccount();
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createAccount() async {
    if (formKey.currentState!.validate()) {
      try {
        showDialog(
            context: context, builder: (context) => CustomLoadingDialog());
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await FirestoreHandler.creatUser(myUser.User(
            id: credential.user!.uid,
            name: nameController.text,
            email: emailController.text,
            age: int.parse(ageController.text),
            phoneNumber: phoneController.text
        ));
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == FirebaseAuthCode.weakPassword) {
          showDialog(
            context: context,
            builder: (context) => CustomErrorDialog(
                message: "The password provided is too weak.",
                postiveBtnPress: () {}),
          );
          Navigator.pop(context);
        } else if (e.code == FirebaseAuthCode.emailAlreadyInUse) {
          showDialog(
            context: context,
            builder: (context) => CustomErrorDialog(
                message: "The account already exists for that email.",
                postiveBtnPress: () {
                  Navigator.pop(context);
                }),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CustomErrorDialog(
              message: e.toString(),
              postiveBtnPress: () {
                Navigator.pop(context);
              }),
        );
      }
    }
  }
}
