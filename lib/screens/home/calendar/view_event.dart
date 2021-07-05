import 'package:flutter/material.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;
  EventDetailsPage({Key key, this.event}) : super(key: key);
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Are you sure?",
                      ),
                      content: Text("You will not be able to undo this."),
                      actions: [
                        TextButton(
                          child: Text("Yes, delete."),
                          onPressed: () {
                            _db.deleteCurrentUserFromEvent(
                                widget.event.uid, widget.event.isPrivate);
                            Fluttertoast.showToast(
                              msg: "Event Deleted.",
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Don't delete"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.event.eventName,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20.0),
            Text(
              "Description: " + widget.event.shortDescription,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              "Date: " +
                  widget.event.date.day.toString() +
                  "/" +
                  widget.event.date.month.toString() +
                  "/" +
                  widget.event.date.year.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              "Venue: " + widget.event.venue,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
