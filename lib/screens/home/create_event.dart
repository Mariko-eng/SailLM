import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/screens/home/create_events/create_concert.dart';
import 'package:sail_live_mobile/screens/home/create_events/create_conference.dart';
import 'package:sail_live_mobile/screens/home/create_events/create_meeting.dart';
import 'package:sail_live_mobile/services/auth.dart';

class CreateEvent extends StatelessWidget {
  final String eventType = '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: AuthService().user,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Container(
                height: 100,
                child: Image.asset('assets/logo.png'),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            body: Container(
              color: Colors.black,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonTheme(
                          height: 50.0,
                          child: FlatButton(
                            child: Text(
                              'Meeting',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.0,
                              ),
                            ),
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateMeeting()),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonTheme(
                          height: 50.0,
                          child: FlatButton(
                            child: Text(
                              'Conference',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.0,
                              ),
                            ),
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateConference()),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonTheme(
                          height: 50.0,
                          child: FlatButton(
                            child: Text(
                              'Concert',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.0,
                              ),
                            ),
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateConcert()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
