import 'package:flutter/material.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyPublicEvents extends StatefulWidget {
  @override
  _MyPublicEventsState createState() => _MyPublicEventsState();
}

class _MyPublicEventsState extends State<MyPublicEvents> {
  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my public events"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: StreamBuilder<List<EventModel>>(
          stream: db.getMyEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline_outlined,
                          color: Color(0xff16344E),
                        ),
                        onPressed: () async {
                          await db.deleteEventFromParticipantsProfile(
                              snapshot.data[index].uid,
                              snapshot.data[index].participant);
                          await db.deleteMyEvent(snapshot.data[index].uid);
                          Fluttertoast.showToast(
                              msg: "deleted",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor: Color(0xFF16344E),
                              textColor: Colors.white);
                          // Navigator.pop(context, true);
                        },
                      ),
                      title: Text(snapshot.data[index].eventName),
                      subtitle: Text(
                          "${DateTime.parse(snapshot.data[index].date.toString()).day}/${DateTime.parse(snapshot.data[index].date.toString()).month}/${DateTime.parse(snapshot.data[index].date.toString()).year}"),
                      onTap: () {
                        Widget cancelButton = TextButton(
                          child: Text("ok"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        );

                        AlertDialog alert = AlertDialog(
                          content: Text("EVENT DETAILS"
                              "\n\nName:${snapshot.data[index].eventName}? "
                              "\n\nEvent details: ${snapshot.data[index].shortDescription}"
                              "\n\nVenue: ${snapshot.data[index].venue}"
                          "\n\n No of participants: ${snapshot.data[index].participant.length}"),
                          actions: [cancelButton],
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
    );
  }
}
