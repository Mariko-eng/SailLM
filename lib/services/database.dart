import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sail_live_mobile/models/events.dart';
import 'package:sail_live_mobile/models/user.dart';

class Database {
  final String uid;
  Database({this.uid});

  final CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future updateUserProfile(
      String username, String email, String profilePhoto) async {
    return await profilesCollection.doc(uid).set({
      'username': username,
      'email': email,
      'profilePhoto': profilePhoto,
    });
  }

  Future startEvent(String eventId, String broadcatingUrl) async {
    return await eventsCollection
        .doc(eventId)
        .update({'broadcasting': true, 'broadcastingURL': broadcatingUrl});
  }

  Future addUserToEmails(String eventId, String uid) async {
    return await eventsCollection.doc(eventId).update({
      'emails': FieldValue.arrayUnion([uid]),
    });
  }

  SailLiveUserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    return SailLiveUserProfile(
      email: snapshot.data()['email'],
      profilePhoto: snapshot.data()['profilePhoto'],
      username: snapshot.data()['username'],
    );
  }

  List<SailLiveEvent> _eventsList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SailLiveEvent(
        eventId: doc.id,
        date: doc.data()['eventDateTime'].toDate(),
        description: doc.data()['eventDescription'],
        name: doc.data()['eventName'],
        image: doc.data()['eventImage'],
        price: doc.data()['eventPrice'],
        broadcasting: doc.data()['broadcasting'],
        broadcastURL: doc.data()['broadcastingURL'],
        createdBy: doc.data()['createdBy'],
        emails: doc.data()['emails'],
        eventType: doc.data()['eventType'],
      );
    }).toList();
  }

  Stream<List<SailLiveEvent>> get events {
    DateTime now = DateTime.now();
    DateTime yesterday =
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute);

    return eventsCollection
        .where('eventDateTime', isGreaterThanOrEqualTo: yesterday)
        .orderBy('eventDateTime')
        .snapshots()
        .map(_eventsList);
  }

  Stream<List<SailLiveEvent>> get myEvents {
    return eventsCollection
        .where('createdBy', isEqualTo: this.uid)
        .orderBy('eventDateTime')
        .snapshots()
        .map(_eventsList);
  }

  Stream<SailLiveUserProfile> get userProfile {
    return profilesCollection
        .doc(uid)
        .snapshots()
        .map(_userProfileFromSnapshot);
  }

  Future<bool> createEvent(SailLiveEvent event) async {
    var eventMap = event.toMap();
    await eventsCollection.add(eventMap);
    return true;
  }
}
