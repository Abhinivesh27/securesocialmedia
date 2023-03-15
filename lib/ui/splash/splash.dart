import 'dart:developer';

import 'package:at_splash/at_splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/ui/chat/chat.dart';
import 'package:securesocialmedia/ui/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  String uid = "";
  void checkLogin() async {
    var _pref = await SharedPreferences.getInstance();
    String data = _pref.getString("uid") ?? "";
    log(data.toString());
    if (data != "") {
      log(data + " UID BLASTED");
      setState(() {
        isLoggedIn = true;
        uid = data;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return ATsplash(
        splashDuration: 3,
        textIcon: "Secure Social Media",
        backgroundColors: [Colors.blue, Colors.blue],
        afterSplash: () => {
              isLoggedIn
                  ? {
                      Provider.of<AppService>(context, listen: false)
                          .regularLogin(),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(),
                        ),
                      )
                    }
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
            });
  }
}
