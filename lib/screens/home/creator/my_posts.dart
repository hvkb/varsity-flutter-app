import 'package:flutter/material.dart';
import 'package:swemaybe/models/post_model.dart';
import 'package:swemaybe/screens/home/creator/upload.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  DatabaseService _db = DatabaseService();

  AuthService _auth = AuthService();

  bool loading = false;

  bool checkIfLiked(List<dynamic> list) {
    String uid = _auth.getCurrentUserID();
    int i = 0;
    if (list.length > 0) {
      list.forEach((likedUser) {
        if (likedUser.toString() == uid) {
          i = 1;
        }
      });
    }

    return i == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your posts only'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Upload()));
              })
        ],
      ),
      body: loading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color(0xff16344E),
              )),
              color: Colors.white,
            )
          : StreamBuilder<List<PostModel>>(
              stream: _db.myposts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length == 0
                      ? Center(
                          child: Text("Your posts will appear here"),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(children: [
                                ListTile(
                                  title: Text(snapshot.data[index].username),
                                  subtitle: Text(
                                      "${DateTime.parse(snapshot.data[index].uploadDate.toString()).day}/${DateTime.parse(snapshot.data[index].uploadDate.toString()).month}/${DateTime.parse(snapshot.data[index].uploadDate.toString()).year}"),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        await _db.deleteMyPost(
                                            snapshot.data[index].postID);
                                        setState(() {
                                          loading = false;
                                        });
                                      }),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: AlertDialog(
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.network(snapshot
                                                        .data[index].imageURL),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(snapshot
                                                        .data[index].caption+
                                                    "\n\n Liked By: ${snapshot.data[index].likedBy.length}")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            alignment:
                                                FractionalOffset.topCenter,
                                            image: NetworkImage(
                                                snapshot.data[index].imageURL),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.thumb_up_alt_outlined,
                                      color: checkIfLiked(
                                              snapshot.data[index].likedBy)
                                          ? Color(0xff16344E)
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      if (checkIfLiked(
                                          snapshot.data[index].likedBy)) {
                                        await _db.dislike(
                                            snapshot.data[index].postID);
                                      } else {
                                        await _db
                                            .like(snapshot.data[index].postID);
                                      }
                                    },
                                  ),
                                  title: Text(snapshot.data[index].caption),
                                ),
                              ]),
                            );
                          },
                        );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
