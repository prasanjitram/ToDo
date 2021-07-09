import 'package:flutter/material.dart';
import 'package:todo_app_final/constants.dart';

import 'SignInScreen/signInScreen.dart';
import 'SignUpScreen/SignUpScreen.dart';

class GettingStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: size.width,
                height: size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                        height: size.height * 0.5,
                        width: size.width,
                        child: Image(
                            image: AssetImage('assets/images/onboard3.png'))),
                    Text(
                      'Welcome to a new way to keep track of your tasks',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: ()=>Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen())),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                       ),
                  height: 50,
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                      ),
                  height: 50,
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
