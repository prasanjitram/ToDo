import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_final/Screens/HomePage/home.dart';
import 'package:todo_app_final/Screens/SignUpScreen/SignUpScreen.dart';

import '../../Authentication.dart';
import '../../constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(),
      passController = TextEditingController();
  late String email, name, password, userId;
  Authentication auth = Authentication();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    FocusNode emailFocus = FocusNode(), passFocus = FocusNode();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 10,
                ),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 47,
                              fontFamily: 'Calder',
                              color: secondaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        width: size.width,
                        height: size.height*0.85,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, -10),
                                  blurRadius: 30,
                                  color: secondaryColor.withOpacity(0.5))
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: size.width,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: textColor.withOpacity(0.3)),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextFormField(
                                controller: emailController,
                                focusNode: emailFocus,
                                onFieldSubmitted: (val) =>
                                    passFocus.requestFocus(),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "Please enter an email ID";
                                  else if (!(RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)))
                                    return "Enter a valid email ID";
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email ID',
                                    errorStyle: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 13),
                                    hintStyle: TextStyle(
                                        color: textColor, fontSize: 16),
                                    border: InputBorder.none),
                                style:
                                    TextStyle(color: textColor, fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: size.width,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: textColor.withOpacity(0.3)),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextFormField(
                                controller: passController,
                                focusNode: passFocus,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 8)
                                    return "Please enter a password";
                                },
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    errorStyle: TextStyle(
                                        color: Colors.yellowAccent,
                                        fontSize: 13),
                                    hintStyle: TextStyle(
                                        color: textColor, fontSize: 16),
                                    border: InputBorder.none),
                                style:
                                    TextStyle(color: textColor, fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate())
                                  setState(() {
                                    allot();
                                    isLoading = true;
                                  });
                                auth.signIn(email, password).then((value) {
                                  if (value != null) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage(userId: userId,)));
                                    isLoading = false;
                                    userId = value.uid;
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      auth.message,
                                      style: TextStyle(
                                          color: Colors.yellowAccent,
                                          fontSize: 16),
                                    )));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 120, right: 120, top: 20, bottom: 20),
                                height: 60,
                                decoration: BoxDecoration(
                                    color: textColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: textColor,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen())),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                alignment: Alignment.center,
                                child: Text(
                                  "Don't have an account? Sign up",
                                  style:
                                      TextStyle(fontSize: 18, color: textColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  allot() {
    email = emailController.text.trim();
    password = passController.text.trim();
  }
}
