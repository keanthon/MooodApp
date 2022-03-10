import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:moood/responsive/responsive_layout.dart';
import 'package:moood/screens/stream_interface.dart';
import 'package:moood/utils/input_decoration.dart';

import '../utils/helper_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void signUpUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthMethods().signUpUser(
          email: _emailCont.text,
          password: _passwordCont.text,
          firstName: _firstName.text,
          lastName: _lastName.text,
          username: _userName.text
      );

      print(res);

      setState(() {
        _isLoading = false;
      });

      if(res=='success') {
        goToPage(ResponsiveLayout(), 1, context);
      }
      else {
        showSnackBar(res, context);
      }

    }

  }

  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont.dispose();
    _confirmPass.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    notMatchFunc(val){
      if(val==null || val.isEmpty)
        return 'Required';
      if(val != _passwordCont.text)
        return 'Passwords Do Not Match';
      return null;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [


                  TextFormField(
                    validator: requireFunc,
                    controller: _firstName,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: TextInputDecoration(
                        'First Name',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: requireFunc,
                    controller: _lastName,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: TextInputDecoration(
                        'Last Name',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: requireFunc,
                    controller: _userName,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: TextInputDecoration(
                        'Username',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: requireFunc,
                    controller: _emailCont,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: TextInputDecoration(
                        'Email',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: requireFunc,
                    controller: _passwordCont,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: TextInputDecoration(
                        'Password',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: notMatchFunc,
                    controller: _confirmPass,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: TextInputDecoration(
                        'Confirm Password',
                        Colors.redAccent[100]).decorate(),
                  ),
                  const SizedBox(height: 10,),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurpleAccent[100],
                        fixedSize: Size(300, 50),
                      ),
                      onPressed: () async {
                        signUpUser(context);

                      },
                      child: _isLoading? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                      : const Text('Create Account')
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          'Have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context) ,
                        child: Container(
                          child: const Text(
                            ' Login.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}