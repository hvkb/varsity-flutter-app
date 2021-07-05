import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swemaybe/models/event_model.dart';
import 'package:swemaybe/models/post_model.dart';
import 'package:swemaybe/models/user_model.dart';
import 'package:swemaybe/services/authenticate.dart';

class DatabaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<void> createUserData(
      String uid, String username, String email, String reg_no) async {
    return await _firebaseFirestore.collection("users").doc(uid).set(
        {'uid': uid, 'username': username, 'email': email, 'reg_no': reg_no});
  }

  Future<bool> addEvent(EventModel gsEvent) async {
    final snapShot1 = await FirebaseFirestore.instance
        .collection("events")
        .where('eventName', isEqualTo: gsEvent.eventName)
        .get();
    if (snapShot1.size == 0) {
      //if event doesnt exist already
      DocumentReference documentReference = await _firebaseFirestore
          .collection("events")
          .add(_convertGSEventToMap(gsEvent));
      final snapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(_authService.getCurrentUserID())
          .collection("events")
          .where('eventName', isEqualTo: gsEvent.eventName)
          .get();
      if (snapShot != null) {
        await _firebaseFirestore
            .collection('events')
            .doc(documentReference.id)
            .update({'eventID': documentReference.id});

        await _firebaseFirestore
            .collection("users")
            .doc(_authService.getCurrentUserID())
            .collection("events")
            .doc(documentReference.id)
            .set(_convertGSEventToMap(gsEvent));

        await _firebaseFirestore
            .collection("users")
            .doc(_authService.getCurrentUserID())
            .collection("events")
            .doc(documentReference.id)
            .update({'eventID': documentReference.id});
        await _firebaseFirestore
            .collection("events")
            .doc(documentReference.id)
            .update({
          'participant':
              FieldValue.arrayUnion([_authService.getCurrentUserID()])
        });
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future addPrivateEvent(EventModel gsEvent) async {
    DocumentReference documentReference = await _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .collection("events")
        .add(_convertGSEventToMap(gsEvent));
  }

  Future<String> getCurrentUserEmail(String id) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .get();
    print(snapShot);
    return "hi";

  }

  Future joinEvent(EventModel gsEvent, String docID) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .collection("events")
        .doc(docID)
        .set(_convertGSEventToMap(gsEvent));

    await _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .collection("events")
        .doc(docID)
        .update({'eventID': gsEvent.uid});

    await _firebaseFirestore.collection("events").doc(docID).update({
      'participant': FieldValue.arrayUnion([_authService.getCurrentUserID()])
    });
  }

  Map<String, dynamic> _convertGSEventToMap(EventModel gsEvent) {
    Map<String, dynamic> map = {};
    map['organizerID'] = gsEvent.organiserID;
    map['venue'] = gsEvent.venue;
    map['shortDescription'] = gsEvent.shortDescription;
    map['eventName'] = gsEvent.eventName;
    map['date'] = gsEvent.date;
    map['isPrivate'] = gsEvent.isPrivate;
    return map;
  }

  Map<String, dynamic> _addParticipant(EventModel gsEvent) {
    Map<String, dynamic> map = {};
    map['userID'] = _authService.getCurrentUserID().toString();
    return map;
  }

  Stream<List<EventModel>> get eventslist {
    Stream<List<EventModel>> list = _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .collection("events")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => EventModel(
                eventName: documentSnapshot.data()['eventName'],
                shortDescription: documentSnapshot.data()['shortDescription'],
                date: documentSnapshot.data()['date'].toDate(),
                organiserID: documentSnapshot.data()['organizerID'],
                venue: documentSnapshot.data()['venue'],
                uid: documentSnapshot.data()['eventID'],
                isPrivate: documentSnapshot.data()['isPrivate'],
              ),
            )
            .toList());

    return _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID())
        .collection("events")
        .snapshots()
        .map(
          (QuerySnapshot querySnapshot) => querySnapshot.docs
              .map(
                (DocumentSnapshot documentSnapshot) => EventModel(
                  eventName: documentSnapshot.data()['eventName'],
                  shortDescription: documentSnapshot.data()['shortDescription'],
                  date: documentSnapshot.data()['date'].toDate(),
                  organiserID: documentSnapshot.data()['organizerID'],
                  venue: documentSnapshot.data()['venue'],
                  uid: documentSnapshot.data()['eventID'],
                  isPrivate: documentSnapshot.data()['isPrivate'],
                ),
              )
              .toList(),
        );
  }

  Future<void> deleteEntireEvent(String docID) {
    _firebaseFirestore
        .collection("events")
        .doc(docID)
        .collection("Participants")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    _firebaseFirestore.collection("events").doc(docID).delete();
  }

  Future<void> deleteCurrentUserFromEvent(String docID, bool isPrivate) {
    if (!isPrivate) {
      // _firebaseFirestore
      //     .collection("events")
      //     .doc(docID)
      //     .collection('Participants')
      //     .where("userID", isEqualTo: _authService.getCurrentUserID())
      //     .get()
      //     .then((value) {
      //   value.docs.forEach((element) {
      //     FirebaseFirestore.instance
      //         .collection("events")
      //         .doc(docID)
      //         .collection('Participants')
      //         .doc(element.id)
      //         .delete()
      //         .then((value) {
      //       print("Success!");
      //     });
      //   });
      // });
          // delete from list of participants in events collection.
         _firebaseFirestore.collection("events").doc(docID).update({
          'participant': FieldValue.arrayRemove([_authService.getCurrentUserID()])
        });

      // delete from user's events
      _firebaseFirestore
        .collection("users")
            .doc(_authService.getCurrentUserID())
            .collection("events")
            .doc(docID)
            .delete();
    } else {
      //delete entire private event
      _firebaseFirestore
          .collection("users")
          .doc(_authService.getCurrentUserID())
          .collection("events")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      _firebaseFirestore
          .collection("users")
          .doc(_authService.getCurrentUserID())
          .collection("events")
          .doc(docID)
          .delete();
    }
  }

  Stream<List<EventModel>> get getEvents {
    return _firebaseFirestore
        .collection("events")
        .orderBy('date', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => EventModel(
                uid: doc.data()['eventID'],
                eventName: doc.data()['eventName'],
                venue: doc.data()['venue'],
                participant: doc.data()['participant'] ?? [],
                date: doc.data()['date'].toDate(),
                shortDescription: doc.data()['shortDescription']))
            .toList());
  }

  Stream<List<EventModel>> get getMyEvents {
    return _firebaseFirestore
        .collection("events")
        .where('organizerID', isEqualTo: _authService.getCurrentUserID())
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => EventModel(
                uid: doc.data()['eventID'],
                eventName: doc.data()['eventName'],
                venue: doc.data()['venue'],
                participant: doc.data()['participant'] ?? [],
                date: doc.data()['date'].toDate(),
                shortDescription: doc.data()['shortDescription']))
            .toList());
  }

  deleteMyEvent(String eventID) async {
    await _firebaseFirestore.collection("events").doc(eventID).delete();
  }

  deleteEventFromParticipantsProfile(String eventID, List<dynamic> list) async {
    String uid = _authService.getCurrentUserID();
    if (list.length > 0) {
      list.forEach((joinedUser) async {
        _firebaseFirestore
            .collection("users")
            .doc(uid)
            .collection("events")
            .doc(eventID)
            .delete();
      });
    }
  }

  // add a new post
  Future<void> addPost(PostModel post) async {
    UserModel user = await getCurrentUserModel();
    DocumentReference documentReference =
        await _firebaseFirestore.collection("posts").add({
      'caption': post.caption,
      'url': post.imageURL,
      'uid': _authService.getCurrentUserID(),
      'username': user.username,
      'uploadDate': post.uploadDate,
    });
    _firebaseFirestore
        .collection("posts")
        .doc(documentReference.id)
        .update({'likedBy': FieldValue.arrayUnion([])});
  }

  //get all posts
  Stream<List<PostModel>> get posts {
    return _firebaseFirestore
        .collection("posts")
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => PostModel(
                postID: doc.id,
                likedBy: doc.data()['likedBy'] ?? [],
                imageURL: doc.data()['url'],
                caption: doc.data()['caption'],
                uid: doc.data()['uid'],
                username: doc.data()['username'],
                uploadDate: doc.data()['uploadDate'].toDate()))
            .toList());
  }

  //get current user's posts
  Stream<List<PostModel>> get myposts {
    return _firebaseFirestore
        .collection("posts")
        .where('uid', isEqualTo: _authService.getCurrentUserID())
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => PostModel(
                postID: doc.id,
                likedBy: doc.data()['likedBy'] ?? [],
                imageURL: doc.data()['url'],
                caption: doc.data()['caption'],
                uid: doc.data()['uid'],
                username: doc.data()['username'],
                uploadDate: doc.data()['uploadDate'].toDate()))
            .toList());
  }

//posts-like
  like(String postID) async {
    await _firebaseFirestore.collection("posts").doc(postID).update({
      'likedBy': FieldValue.arrayUnion([_authService.getCurrentUserID()])
    });
  }

  //posts-dislike
  dislike(String postID) async {
    await _firebaseFirestore.collection("posts").doc(postID).update({
      'likedBy': FieldValue.arrayRemove([_authService.getCurrentUserID()])
    });
  }

  //posts-delete
  deleteMyPost(String postID) async {
    await _firebaseFirestore.collection("posts").doc(postID).delete();
  }

  Future<UserModel> getCurrentUserModel() async {
    DocumentSnapshot documentSnapshot = await _firebaseFirestore
        .collection("users")
        .doc(_authService.getCurrentUserID().toString())
        .get();
    return UserModel(
      username: documentSnapshot.get('username').toString(),
      uid: documentSnapshot.id,
      reg_no: documentSnapshot.get('reg_no'),
      email: documentSnapshot.get('email'),
    );
  }
}
