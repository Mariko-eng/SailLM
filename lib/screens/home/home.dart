import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/screens/home/create_event.dart';
import 'package:sail_live_mobile/screens/home/events_list.dart';
import 'package:sail_live_mobile/services/auth.dart';
import 'package:sail_live_mobile/services/database.dart';
import 'package:sail_live_mobile/shared/drawer.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: Database().events,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            height: 100,
            child: Image.asset('assets/logo.png'),
          ),
        ),
        drawer: MyDrawer(signOut: _auth.signOut),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: EventsList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEvent()));
          },
          backgroundColor: Colors.red[700],
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
        ),
      ),
    );
  }
}
