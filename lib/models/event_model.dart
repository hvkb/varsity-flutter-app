class EventModel {
  final String uid;
  final String eventName;
  final String organiserID;
  final String venue;
  final String shortDescription;
  final DateTime date;
  final bool isPrivate;
  final int nofparticipants;
  List<dynamic> participant;
  EventModel(
      {this.eventName,
      this.uid,
      this.organiserID,
      this.venue,
      this.shortDescription,
      this.date,
      this.isPrivate,
      this.participant,
      this.nofparticipants});
}
