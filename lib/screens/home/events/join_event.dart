import 'package:flutter/material.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:swemaybe/view/scale.dart';
import 'new_event.dart';
import 'my_public_events.dart';

class JoinEvent extends StatefulWidget {
  // final EventModel event;
  // JoinEvent({@required Key key, @required this.event}) : super(key: key);
  @override
  _JoinEventState createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {
  DatabaseService db = DatabaseService();
  AuthService _auth = AuthService();
  bool checkIfJoined(List<dynamic> list) {
    String uid = _auth.getCurrentUserID();
    int i = 0;
    if (list.length > 0) {
      list.forEach((joinedUser) {
        if (joinedUser.toString() == uid) {
          i = 1;
        }
      });
    }
    return i == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: StreamBuilder<List<EventModel>>(
          stream: db.getEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data[index].eventName),
                      subtitle: Text(
                          "${DateTime.parse(snapshot.data[index].date.toString()).day}/${DateTime.parse(snapshot.data[index].date.toString()).month}/${DateTime.parse(snapshot.data[index].date.toString()).year}"),
                      onTap: () {
                        Widget cancelButton = TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        );
                        Widget continueButton = TextButton(
                          child: Text("Join"),
                          onPressed: () async {
                            Navigator.pop(context, true);
                            EventModel gsEvent = EventModel(
                                eventName: snapshot.data[index].eventName,
                                organiserID: snapshot.data[index].organiserID,
                                venue: snapshot.data[index].venue,
                                shortDescription:
                                    snapshot.data[index].shortDescription,
                                date: snapshot.data[index].date,
                                isPrivate: false,
                                uid: snapshot.data[index].uid);
                            bool a =
                                checkIfJoined(snapshot.data[index].participant);
                            if (!a) {
                              await db.joinEvent(
                                  gsEvent, snapshot.data[index].uid);
                              Fluttertoast.showToast(
                                  msg: "Joined",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor: Color(0xFF16344E),
                                  textColor: Colors.white);
                              // Navigator.pop(context, true);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "You already joined, stop joining again smh",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor: Color(0xFF16344E),
                                  textColor: Colors.white);
                            }
                          },
                        );
                        AlertDialog alert = AlertDialog(
                          content: Text(
                              "Would you like to join ${snapshot.data[index].eventName}? "
                              "\n\nEvent details: ${snapshot.data[index].shortDescription}"
                              "\n\nVenue: ${snapshot.data[index].venue}"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            });
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     backgroundColor: Color(0xff16344E),
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => NewGroupStudy()));
      //     }),
      floatingActionButton: buildSpeedDial(),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      backgroundColor: Colors.white,
      icon: Icons.more_horiz,
      iconTheme: IconThemeData(
        color: Color(0xff16344E),
      ),
      children: [
        SpeedDialChild(
            labelBackgroundColor: Colors.white,
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
            label: 'my public events',
            labelStyle:
                TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.5),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyPublicEvents()));
            }),
        SpeedDialChild(
            labelBackgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Color(0xff16344E),
            ),
            backgroundColor: Colors.white,
            label: 'create new public event',
            labelStyle:
                TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.5),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewGroupStudy()));
            }),
      ],
    );
  }
}
