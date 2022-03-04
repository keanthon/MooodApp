import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/screens/stream_interface.dart';
import 'package:moood/utils/input_decoration.dart';
import '../utils/helper_functions.dart';
import 'signup_screen.dart';

// Form widget
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();


  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    requireFunc(value) {
      if (value == null || value.isEmpty) {
        return 'Required';
      }
      return null;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [

          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/images/logo.jpg'),
          ),
          const SizedBox(height: 64,),

          TextFormField(
            validator: requireFunc,
            controller: _emailCont,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: TextInputDecoration(
                'Enter your email',
                Colors.redAccent[100]).decorate(),
          ),
          const SizedBox(height: 10,),

          TextFormField(
            controller: _passwordCont,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: TextInputDecoration(
                'Password',
                Colors.redAccent[100]).decorate(),
            validator: requireFunc,
          ),
          const SizedBox(height: 10,),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent[100],
                fixedSize: Size(300, 50),
              ),
              onPressed: () async {
                // FIXME cache login status so don't have to re-login
                if (_formKey.currentState!.validate()) {
                  FirebaseAuth _auth;
                  try {
                    _auth = FirebaseAuth.instance;
                    await _auth.signInWithEmailAndPassword(
                        email: _emailCont.text, password: _passwordCont.text);
                  }
                  on FirebaseAuthException catch(e) {
                      Widget okButton = TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pop(context)
                      );

                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("Error"),
                        content: Text(e.toString().split("]")[1].substring(1)), // FIXME make this formatting better
                        actions: [
                          okButton,
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );

                    return;
                  }

                  go_to_stream(context);
                }
              },
              child: const Text('Submit')
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                ) ,
                child: Container(
                  child: const Text(
                    ' Signup.',
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

          //signup


        ],
      ),
    );
  }
}

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
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: const MyCustomForm(),
          ),
        ),
      ),
    );
  }
}


