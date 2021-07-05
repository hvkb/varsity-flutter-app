import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swemaybe/models/post_model.dart';
import 'package:swemaybe/services/database.dart';
import 'package:path/path.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  DatabaseService _db = DatabaseService();
  String imageURL;
  String caption = "";
  final _formKey = GlobalKey<FormState>();
  File _image;
  bool error = false;
  bool uploadingCloud = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image and Caption'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              _image != null
                  ? Image.file(_image)
                  : Placeholder(
                      fallbackWidth: double.infinity,
                      fallbackHeight: 300,
                    ),
              SizedBox(
                height: 20,
              ),
              Text(error ? 'Please add caption and photo' : ''),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (val) {
                  caption = val;
                },
                validator: (val) => val.isEmpty ? "Enter Caption" : null,
                decoration: InputDecoration(hintText: 'Caption'),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                // TODO: Check validation
                onPressed: () {
                  getImage();
                },
                child: Text('Pick image'),
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await uploadImage(context);
                    if (imageURL != null) {
                      setState(() {
                        error = false;
                      });
                      PostModel post = PostModel(
                          caption: caption,
                          imageURL: imageURL,
                          uploadDate: DateTime.now());
                      await _db.addPost(post);
                      Navigator.pop(context);
                    }
                  } else {
                    setState(() {
                      error = true;
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    await Permission.photos
        .request(); // will do nothing if permission has been granted
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }
  }

  Future uploadImage(BuildContext context) async {
    final _storage = FirebaseStorage.instance;
    String filename = basename(_image.path);
    var snapshot = await _storage.ref().child(filename).putFile(_image);
    var downloadURL = await snapshot.ref.getDownloadURL();
    setState(() {
      imageURL = downloadURL;
    });
  }
}
