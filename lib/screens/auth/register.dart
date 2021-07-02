import 'package:flutter/material.dart';
import 'package:sail_live_mobile/services/auth.dart';
import 'package:sail_live_mobile/shared/constants.dart';
import 'package:sail_live_mobile/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          onChanged: (value) => email = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid email';
                            }

                            RegExp regex = RegExp(emailPattern);
                            if (!(regex.hasMatch(value))) {
                              return 'Invalid email';
                            }

                            return null;
                          },
                          decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          onChanged: (value) => password = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },
                          decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              size: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      error.isEmpty
                          ? SizedBox.shrink()
                          : SizedBox(height: 10.0),
                      error.isEmpty
                          ? SizedBox.shrink()
                          : Text(
                              error,
                              style: TextStyle(
                                color: Colors.red[900],
                              ),
                            ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ButtonTheme(
                              height: 60.0,
                              child: FlatButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      error = '';
                                      loading = true;
                                    });

                                    dynamic result = await _auth
                                        .registerEmailPassword(email, password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = 'Invalid credentials';
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21.0,
                                  ),
                                ),
                                color: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => widget.toogleView(),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
