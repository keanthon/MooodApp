import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:moood/responsive/responsive_layout.dart';
import 'package:moood/utils/input_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors_styles.dart';
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
  Uint8List? _image;
  bool _readTerms = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setImage();
  }

  Future<void> setImage() async {
    _image = (await rootBundle.load('assets/images/blankProfile.jpg')).buffer.asUint8List();
  }

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
          username: _userName.text,
          file: _image!
      );


      // print(res);

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

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
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
      backgroundColor: Color(0xFFF1F0F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.white,
                      )
                          : const CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage(
                            'assets/images/blankProfile.jpg'),
                        backgroundColor: Colors.red,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
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
                  Row(
                      children: [
                        SizedBox(width: 30,),
                        Checkbox(
                            value: _readTerms,
                            onChanged: (val) {
                            setState(() {
                              _readTerms = val!;
                            });
                        },
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "I have read and agree to the ",
                              ),
                              InkWell(
                                child: Text("End-User License Agreement",
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                                onTap: () async {
                                  const url = 'https://keanthon.github.io/EndUserLicenseAgreement/';
                                  if(await canLaunch(url)){
                                    await launch(url);
                                  }else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),

                            ]
                        ),
                      ],

                      ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: michiganBlue,
                        fixedSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: () async {
                        if(_readTerms) {
                          signUpUser(context);
                        }
                        else {
                          showSnackBar('Please read and accept the End-User License Agreement.', context);
                        }

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