import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _passwordCont1 = TextEditingController();
  final TextEditingController _passwordCont2 = TextEditingController();

  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont1.dispose();
    _passwordCont2.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                ),
                const SizedBox(height: 32,),

                TextFieldInput(
                  textEditingController: _firstName,
                  textInputType: TextInputType.text,
                  hintText: 'First Name',
                  backgroundColor: Colors.redAccent[100],
                ),
                const SizedBox(height: 10,),

                TextFieldInput(
                  textEditingController: _lastName,
                  textInputType: TextInputType.text,
                  hintText: 'Last Name',
                  backgroundColor: Colors.redAccent[100],
                ),
                const SizedBox(height: 10,),

                TextFieldInput(
                  textEditingController: _emailCont,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  backgroundColor: Colors.redAccent[100],
                ),
                const SizedBox(height: 10,),

                TextFieldInput(
                  textEditingController: _passwordCont1,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Password',
                  backgroundColor: Colors.redAccent[100],
                  isPass: true,
                ),
                const SizedBox(height: 10,),

                TextFieldInput(
                  textEditingController: _passwordCont2,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Re-enter Password',
                  backgroundColor: Colors.redAccent[100],
                  isPass: true,
                ),
                const SizedBox(height: 10,),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent[100],
                      fixedSize: Size(300, 50),
                    ),
                    onPressed: (){},
                    child: const Text('Create Account')
                ),

                //
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
    );
  }
}