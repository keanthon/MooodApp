import 'package:flutter/material.dart';
import 'package:moood/resources/auth_methods.dart';
import 'package:moood/screens/login_screen.dart';
import 'package:moood/utils/colors_styles.dart';
import 'package:moood/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../models/user_class.dart';
import '../providers/user_provider.dart';
import 'blocked_screen.dart';

class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);

  final List<String> entries = <String>[
    'Blocked Users 🚫',
    'End-User License Agreement 🔔',
    'Delete Account 😔',
  ];

  @override
  Widget build(BuildContext context) {
    UserClass? user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              "Settings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              height: 50,
              child: Center(child: Text('${entries[index]}', style: TextStyle(fontSize: 18),)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
            onTap: () async {
              if(index==0) {
                goToPage(Blocked(), 2, context);
              }
              if(index==1) {
                launchEULA();
              }
              if(index==2) {
                bool res = await showAreYouSureDialog(context, "deleteAcc");
                if(res) {
                  bool res2 = await confirmDialog(context);
                  if(res2) {
                    Provider.of<UserProvider>(context, listen: false).refreshUser();
                    AuthMethods().deleteAccount(user.friends);
                    goToPage(LoginScreen(), 3, context);
                  }
                }
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
