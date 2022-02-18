import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 125,
                backgroundImage: AssetImage('assets/images/logo.jpg'),
              ),
              const SizedBox(height: 64,),

              //password
              //login
              //signup

            ],
          ),
        ),
      ),
    );
  }
}
