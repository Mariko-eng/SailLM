import 'package:flutter/material.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';
import 'package:sail_live_mobile/services/api_requests.dart';
import 'package:sail_live_mobile/shared/payment.dart';
import 'package:url_launcher/url_launcher.dart';

Future launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Failed to launch URL');
  }
}

Widget eventButton(
    SailLiveEvent event, SailLiveUser user, BuildContext context) {
  // If the event has started and the user created it
  if (event.broadcasting && event.createdBy == user.uid) {
    return RaisedButton(
      child: Text(
        'JOIN EVENT',
        style: TextStyle(color: Colors.white, fontSize: 23.0),
      ),
      color: Colors.green,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () async {
        await launch(event.broadcastURL);
        print('My Event has started');
      },
    );
  }

  // If the user created an event but it hasn't started
  if (!event.broadcasting && event.createdBy == user.uid) {
    return FlatButton(
      child: Text(
        'START EVENT',
        style: TextStyle(color: Colors.white, fontSize: 23.0),
      ),
      color: Colors.red[800],
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () async {
        final response = await startEvent(event.eventId);
        if (!response['isValid']) {
          print('FAILED TO START EVENT');
          return;
        }
        await launchUrl(response['body']['url']);
        print('STARTED MY EVENT');
      },
    );
  }

  // If the user didn't create event and it has not started
  if (!event.broadcasting && event.createdBy != user.uid) {
    return Text(
      'EVENT HAS NOT STARTED',
      style: TextStyle(color: Colors.red[800], fontSize: 23.0),
    );
  }

  // If the user didn't create the event and it has started
  if (event.broadcasting && event.createdBy != user.uid) {
    if (event.eventType == 'meeting' && event.emails.contains(user.email)) {
      return FlatButton(
        child: Text(
          'JOIN MEETING',
          style: TextStyle(color: Colors.white, fontSize: 23.0),
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          await launchUrl(event.broadcastURL);
          print('JOIN MEETING');
        },
      );
    }

    if (event.eventType == 'meeting' && !event.emails.contains(user.email)) {
      return Text(
        'THIS IS AN INVITE ONLY EVENT',
        style: TextStyle(color: Colors.white, fontSize: 23.0),
      );
    }

    if ((event.eventType == 'concert' || event.eventType == 'conference') &&
        event.emails.contains(user.uid)) {
      return FlatButton(
        child: Text(
          'CONTINUE EVENT',
          style: TextStyle(color: Colors.white, fontSize: 23.0),
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          await launchUrl(event.broadcastURL);
          print('CONTINUE EVENT');
        },
      );
    }

    return FlatButton(
      child: Text(
        'WATCH NOW',
        style: TextStyle(color: Colors.white, fontSize: 23.0),
      ),
      color: Colors.green,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWidget(event: event, user: user),
          ),
        );
        print('WATCH NOW');
      },
    );
  }

  return Text(
    'JUST WOW',
    style: TextStyle(color: Colors.white, fontSize: 23.0),
  );
}
