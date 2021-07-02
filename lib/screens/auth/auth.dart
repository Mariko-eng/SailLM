import 'package:flutter/material.dart';
import 'package:sail_live_mobile/screens/auth/register.dart';
import 'package:sail_live_mobile/screens/auth/sign_in.dart';

class Auth extends StatefulWidget {
  @override
  AuthState createState() => AuthState();
}

class AuthState extends State<Auth> {
  bool showSignIn = true;

  void toogleSignIn() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toogleView: toogleSignIn)
        : Register(toogleView: toogleSignIn);
  }
}
