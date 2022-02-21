import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/widgets/text_field_input.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                ),
                const SizedBox(height: 64,),
                TextFieldInput(
                  textEditingController: _emailCont,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  backgroundColor: Colors.redAccent[100],
                ),
                const SizedBox(height: 10,),
                TextFieldInput(
                  textEditingController: _passwordCont,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Password',
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
                  child: const Text('Login')
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Dont have an account?',
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
          ),
        ),
      ),
    );
  }
}
