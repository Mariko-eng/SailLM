import 'package:flutter/material.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/screens/home/event_screen.dart';
import 'package:sail_live_mobile/shared/date_converter.dart';

class EventTile extends StatelessWidget {
  final SailLiveEvent event;
  final Function onTap;

  EventTile({this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        height: 100,
        child: Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventScreen(event: event)),
              );
            },
            leading: Image.network(
              event.image,
            ),
            title: Text(
              event.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dateToString(event.date),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  dateToTime(event.date),
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'UGX. ${event.price}',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
