// Built by Kengo Louis Wada
// Designed by Agume Alvin

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/screens/wrapper.dart';
import 'package:sail_live_mobile/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SailLive());
}

class SailLive extends StatefulWidget {
  @override
  _SailLiveState createState() => _SailLiveState();
}

class _SailLiveState extends State<SailLive> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<SailLiveUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
