import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/screens/auth/auth.dart';
import 'package:sail_live_mobile/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SailLiveUser>(context);

    if (user == null) {
      return Auth();
    }

    return Home();
  }
}
