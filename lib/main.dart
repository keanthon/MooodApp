import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moood/providers/user_provider.dart';
import 'package:moood/responsive/responsive_layout.dart';
import 'package:moood/screens/login_screen.dart';
import 'package:moood/screens/stream_interface.dart';
import 'package:moood/utils/colors_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  TextStyle boldText() {
    return TextStyle(
        fontWeight: FontWeight.bold
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Moood',
        // theme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: mobileBackgroundColor,
        // ),
        theme: ThemeData(
            scaffoldBackgroundColor: mobileBackgroundColor,
            fontFamily: "Montserrat",
            appBarTheme: AppBarTheme(
              toolbarHeight: 75,
              backgroundColor: appBarColor,
              iconTheme: IconThemeData(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),

            textTheme: TextTheme(
              bodyText2: boldText(),
              bodyText1: boldText(),
              button: boldText(),

            ),

        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
