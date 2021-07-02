class SailLiveEvent {
  final String eventId;
  final DateTime date;
  final String description;
  final String name;
  final String image;
  final String price;
  final String broadcastURL;
  final bool broadcasting;
  final String eventType;
  final List<dynamic> emails;
  final String createdBy;

  SailLiveEvent({
    this.eventId,
    this.date,
    this.description,
    this.name,
    this.image,
    this.price,
    this.broadcasting,
    this.broadcastURL,
    this.eventType,
    this.emails,
    this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventDateTime': this.date,
      'eventDescription': this.description,
      'eventName': this.name,
      'eventImage': this.image,
      'eventPrice': this.price,
      'createdBy': this.createdBy,
      'emails': this.emails,
      'eventType': this.eventType,
      'broadcasting': false,
    };
  }
}
