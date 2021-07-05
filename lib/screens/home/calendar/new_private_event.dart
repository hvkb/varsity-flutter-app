import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';
import 'package:swemaybe/view/scale.dart';

class NewPrivateEvent extends StatefulWidget {
  @override
  _NewPrivateEventState createState() => _NewPrivateEventState();
}

class _NewPrivateEventState extends State<NewPrivateEvent> {
  DatabaseService _db = DatabaseService();
  AuthService _auth = AuthService();
  String eventName = "";
  String venue = "NA";
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  String shortDescription = "";
  String error = "";

  bool isLoading = true;

  @override
  void initState() {
    _eventDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "new private event",
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 5,
                horizontal: SizeConfig.safeBlockVertical * 4),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  onChanged: (val) {
                    eventName = val;
                  },
                  validator: (val) => val.isEmpty ? "Enter event title" : null,
                  decoration: InputDecoration(hintText: 'Event title'),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),

                TextFormField(
                  onChanged: (val) {
                    shortDescription = val;
                  },
                  validator: (val) => val.isEmpty
                      ? "Please provide short description of event"
                      : null,
                  decoration:
                      InputDecoration(hintText: 'Short description of event'),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                ListTile(
                  title: Text("Date (YYYY-MM-DD)"),
                  subtitle: Text(
                      "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                  onTap: () async {
                    DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: _eventDate,
                        firstDate: DateTime(_eventDate.year - 5),
                        lastDate: DateTime(_eventDate.year + 5));
                    if (picked != null) {
                      setState(() {
                        _eventDate = picked;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 2,
                        horizontal: SizeConfig.safeBlockVertical * 3),
                  ),
                  child: Text('Create Event'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      EventModel gsEvent = EventModel(
                          eventName: eventName,
                          organiserID: _auth.getCurrentUserID().toString(),
                          venue: venue,
                          shortDescription: shortDescription,
                          date: _eventDate,
                          isPrivate: true);
                      await _db.addPrivateEvent(gsEvent);
                      Navigator.pop(context);
                    }
                  },
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
