import 'package:flutter/material.dart';
import 'package:sail_live_mobile/screens/auth/auth.dart';
import 'package:sail_live_mobile/screens/home/home.dart';
import 'package:sail_live_mobile/screens/home/my_events.dart';

class MyDrawer extends StatelessWidget {
  final Function onTap;
  final Function signOut;

  MyDrawer({this.onTap, this.signOut});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200'),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Color(0xffe73924),
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white),
              ListTile(
                leading: Icon(Icons.home_outlined, color: Colors.white),
                title: Text(
                  'HOME',
                  style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
              ListTile(
                leading: Icon(Icons.event_outlined, color: Colors.white),
                title: Text(
                  'MY EVENTS',
                  style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyEvents()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'LOGOUT',
                  style: TextStyle(fontSize: 19.0, color: Colors.white),
                ),
                onTap: () async {
                  await signOut();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Auth()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
