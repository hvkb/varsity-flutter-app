import 'package:flutter/material.dart';
import 'package:swemaybe/models/post_model.dart';
import 'package:swemaybe/screens/home/creator/my_posts.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';
import 'package:swemaybe/view/scale.dart';

class ViewPosts extends StatefulWidget {
  @override
  _ViewPostsState createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 1,
            horizontal: SizeConfig.safeBlockVertical * 1),
        child: StreamBuilder<List<PostModel>>(
          stream: _db.posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                            snapshot.data[index].imageURL),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(snapshot.data[index].caption)
                                      ],
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
                                  alignment: FractionalOffset.topCenter,
                                  image: NetworkImage(
                                      snapshot.data[index].imageURL),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: IconButton(
                          icon: Icon(
                            Icons.thumb_up_alt_outlined,
                            color: checkIfLiked(snapshot.data[index].likedBy)
                                ? Color(0xff16344E)
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            if (checkIfLiked(snapshot.data[index].likedBy)) {
                              await _db.dislike(snapshot.data[index].postID);
                            } else {
                              await _db.like(snapshot.data[index].postID);
                            }
                          },
                        ),
                        title: Text(snapshot.data[index].username +
                            ": " +
                            snapshot.data[index].caption),
                        subtitle: Text(
                            "${DateTime.parse(snapshot.data[index].uploadDate.toString()).day}/${DateTime.parse(snapshot.data[index].uploadDate.toString()).month}/${DateTime.parse(snapshot.data[index].uploadDate.toString()).year}"),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('My Posts'),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyPosts()));
        },
      ),
    );
  }
}
