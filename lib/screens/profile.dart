import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moood/components/post_card.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import 'my_posts.dart';

class Profile extends StatelessWidget {

  Profile({Key? key});



  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser;
    Provider.of<UserProvider>(context).refreshLastPost();
    return (user==null) ? Center(child: CircularProgressIndicator()) : Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Your profile",
                style: TextStyle(

                  color: Colors.black,
                  fontSize: 24,

                )
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                Text(
                    "Hi ${user.firstName} ${user.lastName}!\n#${getShortUID(user.uid)}",
                    style: TextStyle(
                      fontSize: 24,
                      color: secondaryColor,
                    )
                ),
                Container(
                  width: 450,
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(
                          "Your status",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          )
                      ),

                      if (Provider.of<UserProvider>(context).getLastPost!.length != 0)
                        PostCard(snap: Provider.of<UserProvider>(context).getLastPost),

                      IconButton(
                          onPressed: () { goToPage( MyPosts(), 2, context);},
                          icon: Icon(Icons.arrow_forward)
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text("Sign Out"),
                  onPressed: () async {
                    AuthMethods().signOut();
                    goToPage(LoginScreen(), 3, context);
                  },
                ),
              ]
          ),
        ),
      ),

    );
  }
}