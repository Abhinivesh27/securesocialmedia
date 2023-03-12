import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/main.dart';
import 'package:securesocialmedia/service/service.dart';

import '../chat/chat.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedLogin(
      initialMode: AuthMode.login,
      passwordValidator: ValidatorModel(),
      onLogin: (data) async {
        var a = await "Abhi";

        try {
          Provider.of<AppService>(context, listen: false)
              .newLogin(data.email, data.password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(),
            ),
          );
        } catch (e) {}
        return a;
      },
      onSignup: (data) async {
        var a = await "Abhi";
        return a;
      },
      loginMobileTheme:
          LoginViewTheme(textFormStyle: TextStyle(color: Colors.white)),
    );
  }
}
