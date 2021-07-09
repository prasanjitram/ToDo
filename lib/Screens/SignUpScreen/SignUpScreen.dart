import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app_final/Authentication.dart';
import 'package:todo_app_final/Database.dart';
import 'package:todo_app_final/Screens/HomePage/home.dart';
import 'package:todo_app_final/Screens/SignInScreen/signInScreen.dart';
import 'package:todo_app_final/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passController = TextEditingController();
  late String email, name, password, userId;
  Authentication auth = Authentication();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    FocusNode nameFocus = FocusNode(),
        emailFocus = FocusNode(),
        passFocus = FocusNode();

    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SafeArea(
        child:isLoading?Center(child: CircularProgressIndicator(color: primaryColor,strokeWidth: 10,),): Form(
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
                    'Sign Up'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 47,
                        fontFamily: 'Calder',
                        color: primaryColor),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: size.width,
                  height: size.height*0.85,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, -10),
                            blurRadius: 30,
                            color: primaryColor.withOpacity(0.5))
                      ]),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: textColor.withOpacity(0.3)),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 30),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: nameController,
                          focusNode: nameFocus,
                          onFieldSubmitted: (val) => emailFocus.requestFocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Please enter a username";
                          },
                          decoration: InputDecoration(
                              hintText: 'Username',
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 13),
                              hintStyle:
                              TextStyle(color: textColor, fontSize: 16),
                              border: InputBorder.none),
                          style: TextStyle(color: textColor, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: textColor.withOpacity(0.3)),
                        margin:
                        EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: emailController,
                          focusNode: emailFocus,
                          onFieldSubmitted: (val) => passFocus.requestFocus(),
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
                                  color: Colors.yellowAccent, fontSize: 13),
                              hintStyle:
                              TextStyle(color: textColor, fontSize: 16),
                              border: InputBorder.none),
                          style: TextStyle(color: textColor, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: size.width,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: textColor.withOpacity(0.3)),
                        margin:
                        EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          focusNode: passFocus,
                          controller: passController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 8)
                              return "Please enter a password (minimum 8 characters)";
                          },
                          decoration: InputDecoration(
                              hintText: 'Password',
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 13),
                              hintStyle:
                              TextStyle(color: textColor, fontSize: 16),
                              border: InputBorder.none),
                          style: TextStyle(color: textColor, fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              allot();
                              isLoading = true;
                            });
                            auth.signUp(email, password).then((value) {
                              if (value != null) {
                                userId = value.uid;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Homepage(userId: userId,)));
                                DatabaseService service = DatabaseService(userId);
                                Map<String,dynamic> userMap = {"name" : name,"email":email};
                                service.add(userMap);
                                isLoading = false;
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(auth.message,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.yellowAccent),textAlign: TextAlign.start,)));
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          }
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
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen())),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          alignment: Alignment.center,
                          child: Text(
                            'Already have an account? Sign in',
                            style: TextStyle(fontSize: 18, color: textColor),
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
    name = nameController.text.trim();
    password = passController.text.trim();
  }
}
