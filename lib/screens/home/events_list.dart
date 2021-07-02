import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/screens/home/event_tile.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<SailLiveEvent>>(context) ?? [];

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 0.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventTile(
          event: events[index],
        );
      },
    );
  }
}
