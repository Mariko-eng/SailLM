import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/screens/home/events_list.dart';
import 'package:sail_live_mobile/services/auth.dart';
import 'package:sail_live_mobile/services/database.dart';
import 'package:sail_live_mobile/shared/drawer.dart';

class MyEvents extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<SailLiveUser>(context, listen: false).uid;

    return StreamProvider.value(
      value: Database(uid: uid).myEvents,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Container(
            height: 100,
            child: Image.asset('assets/logo.png'),
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(signOut: _auth.signOut),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: EventsList(),
        ),
      ),
    );
  }
}
