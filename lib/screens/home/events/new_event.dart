import 'package:flutter/material.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';
import 'package:swemaybe/view/scale.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewGroupStudy extends StatefulWidget {
  @override
  _NewGroupStudyState createState() => _NewGroupStudyState();
}

class _NewGroupStudyState extends State<NewGroupStudy> {
  DatabaseService _db = DatabaseService();
  AuthService _auth = AuthService();
  String eventName = "";

  String venue = "";
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  String shortDescription = "";
  String error = "";
  @override
  void initState() {
    _eventDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "new public event",
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
                  validator: (val) => val.isEmpty ? "Enter event name" : null,
                  decoration: InputDecoration(hintText: 'Event name'),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 1,
                ),
                TextFormField(
                  onChanged: (val) {
                    venue = val;
                  },
                  validator: (val) =>
                      val.isEmpty ? "Please provide venue" : null,
                  decoration: InputDecoration(hintText: 'Venue'),
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
                      lastDate: DateTime(_eventDate.year + 5),
                    );
                    if (picked != null) {
                      setState(() {
                        _eventDate = picked;
                      });
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 2,
                      horizontal: SizeConfig.safeBlockVertical * 3),
                  child: ElevatedButton(

                    child: Text('Add Event'),
                    onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          EventModel gsEvent = EventModel(
                              eventName: eventName,
                              organiserID: _auth.getCurrentUserID().toString(),
                              venue: venue,
                              shortDescription: shortDescription,
                              date: _eventDate,
                              isPrivate: false);
                          bool a = await _db.addEvent(gsEvent);
                          if (a) {
                            Fluttertoast.showToast(
                                msg: "Event Created",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Color(0xff16344E),
                                textColor: Colors.white);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Event already exists/error",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Color(0xff16344E),
                                textColor: Colors.white);
                          }
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            error =
                                "Couldn't create event, something went wrong.";
                          });
                        }
                      }
                    ,
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
