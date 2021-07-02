import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/shared/date_converter.dart';
import 'package:sail_live_mobile/shared/event_button.dart';

class EventScreen extends StatelessWidget {
  final SailLiveEvent event;

  EventScreen({this.event});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SailLiveUser>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(
                event.image,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      event.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      dateToString(event.date),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      dateToTime(event.date),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      'UGX ${event.price}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: eventButton(event, user, context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
