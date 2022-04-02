import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moood/components/post_card.dart';
import 'package:moood/models/user_class.dart';
import 'package:moood/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';
import '../utils/colors_styles.dart';
import '../utils/helper_functions.dart';
import 'my_posts.dart';

class Profile extends StatefulWidget {

  Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

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
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 100,
                      backgroundImage: MemoryImage(_image!),
                      backgroundColor: Colors.white,
                    )
                        : CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () async {
                          await selectImage();
                          await AuthMethods().uploadImageToStorage('profilePics', _image!, false);

                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
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


                      Provider.of<UserProvider>(context).getLastPost!=null ?
                      PostCard(snap: Provider.of<UserProvider>(context, listen: false).getLastPost, postID: Provider.of<UserProvider>(context, listen: false).getLastPID,ownPost: true,) :
                      SizedBox(height: 15,),


                      IconButton(
                          onPressed: () { goToPage( MyPosts(uid:user.uid), 2, context);},
                          icon: Icon(Icons.arrow_forward),
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