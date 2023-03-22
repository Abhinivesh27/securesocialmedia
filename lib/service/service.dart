import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:securesocialmedia/model/contact.dart';
import 'package:securesocialmedia/model/message.dart';
import 'package:securesocialmedia/model/user.dart';
import 'package:securesocialmedia/ui/messaging/messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';

import '../model/chat.dart';

FirebaseFirestore app = FirebaseFirestore.instance;

CollectionReference _chatRef = app.collection("chats");
CollectionReference _messageRef = app.collection("messages");
CollectionReference _usersRef = app.collection("users");

FirebaseAuth _auth = FirebaseAuth.instance;

class AppService extends ChangeNotifier {
  bool _isHarmfull = false;
  bool get isHarmfull => _isHarmfull;

  bool _isPhoto = false;
  bool get isPhoto => true;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  List<String> _chatRooms = [];
  UnmodifiableListView<String> get chatrooms =>
      UnmodifiableListView(_chatRooms);
  List<Message> _messages = [];
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  ContactModel _user = ContactModel();
  ContactModel get nowUser => _user;

  void updateTabIndex(int indexValue) {
    _tabIndex = indexValue;
    notifyListeners();
  }

  void newLogin(String email, String password) async {
    var response = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    var _pref = await SharedPreferences.getInstance();
    var buffer =
        await _usersRef.where("uid", isEqualTo: response.user!.uid).get();

    if (response.user != null) {
      _pref.setString("uid", response.user!.uid);
      var temp = await app.collection("users").doc(response.user!.uid).get();
      _user = ContactModel()
        ..uid = response.user!.uid
        ..email = email
        ..profileImage = temp['url']
        ..username = temp['name'];
    }

    notifyListeners();
  }

  void createUser(String name, String password, String email) async {
    var response = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    var _pref = await SharedPreferences.getInstance();
    if (response.user != null) {
      Map<String, String> data = {
        "name": name,
        "uid": response.user!.uid,
        "email": email,
        "url":
            "http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTUHhgvrnnW7o1YI99qPkrB5g5HJ31yW4NUBRn1clO9X2d3GbCpvyO65DefpJuH89w8qf-LUI_R0gOtjuI"
      };
      await app.collection("users").doc(response.user!.uid).set(data);
      await _pref.setString("uid", response.user!.uid);
    }
    _user = ContactModel()
      ..uid = response.user!.uid
      ..email = email
      ..username = name;
    notifyListeners();
  }

  void regularLogin() async {
    var _pref = await SharedPreferences.getInstance();
    String uid = _pref.getString("uid") ?? "";
    var buffer = await _usersRef.where("uid", isEqualTo: uid).get();
    var box = await app.collection("users").doc(uid).get();
    _user = ContactModel()
      ..uid = uid
      ..email = box['email']
      ..username = box['name']
      ..profileImage = box['url'];

    notifyListeners();
  }

  static Stream<QuerySnapshot> getMessages() {
    return app
        .collection("messages")
        .where("users", arrayContains: auth.currentUser!.uid)
        .orderBy("time")
        .snapshots();
  }

  static Stream<QuerySnapshot> getUsers() {
    return app
        .collection("users")
        .where("uid", isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static void writeMessages(
      String from, String to, String message, bool type) async {
    int hash =
        "${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}"
            .hashCode;
    Map<String, dynamic> data = {
      "from": from,
      "to": to,
      "text": message,
      "type": type,
      "time": int.parse(
          "${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}"),
      "id": hash,
      "users": [from, to],
    };

    await app.collection("messages").doc(hash.toString()).set(data);
  }

  static void deleteMessage(String id) async {
    await app.collection("messages").doc(id).delete();
  }

  static void newChatRoom(String to) async {
    var _pref = await SharedPreferences.getInstance();
    String uid = _pref.getString("uid") ?? "";
    String chatRoomId = uid + to;
    Map<String, String> data = {
      "id": chatRoomId,
      "user1": uid,
      "user2": to,
    };
    app.collection("chatrooms").doc(chatRoomId).set(data);
  }

  void uploadImage(String? to) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    var instance = ImagePicker();
    XFile? file = await instance.pickImage(source: ImageSource.gallery);

    File image = File(file!.path);
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');

    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    if (output != null && output.isNotEmpty) {
      output[0]['label'].toString() == "0 Harmfull"
          ? _isHarmfull = true
          : _isHarmfull = false;
    }

    if (isHarmfull != true) {
      var ref = _storage.ref().child("images/${image.hashCode}");
      try {
        var _pref = await SharedPreferences.getInstance();
        String uidData = _pref.getString("uid") ?? "";
        var buffer = ref.putFile(image);
        await buffer.whenComplete(() async {
          var url = await ref.getDownloadURL();
          Future.delayed(Duration(seconds: 10));

          if (_isPhoto) {
            writeMessages(auth.currentUser!.uid, to ?? "", url, true);
          } else {
            Map<String, String> data = {"url": url.toString()};
            await app.collection("users").doc(uidData).update(data);
          }
        });
      } catch (e) {
        log("Profile photo not added up " + e.toString());
      }
    }
    notifyListeners();
  }

  void logoutUser() async {
    _auth.signOut();
    var _pref = await SharedPreferences.getInstance();
    _pref.clear();
    _user = ContactModel();
    _chatRooms = [];

    notifyListeners();
  }

  void updateMessageType(bool isPhoto) {
    _isPhoto = true;
    notifyListeners();
  }
}
