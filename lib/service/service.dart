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
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat.dart';

FirebaseFirestore app = FirebaseFirestore.instance;

CollectionReference _chatRef = app.collection("chats");
CollectionReference _messageRef = app.collection("messages");
CollectionReference _usersRef = app.collection("users");

FirebaseAuth _auth = FirebaseAuth.instance;

class AppService extends ChangeNotifier {
  List<String> _chatRooms = [];
  UnmodifiableListView<String> get chatrooms =>
      UnmodifiableListView(_chatRooms);
  List<Message> _messages = [];
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  ContactModel _user = ContactModel();
  ContactModel get nowUser => _user;

  void newLogin(String email, String password) async {
    var response = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    var _pref = await SharedPreferences.getInstance();
    var buffer =
        await _usersRef.where("uid", isEqualTo: response.user!.uid).get();

    if (response.user != null) {
      _pref.setString("uid", response.user!.uid);
    }
    _user = ContactModel()..uid = response.user!.uid;

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
      };
      await app.collection("users").doc(response.user!.uid).set(data);
      await _pref.setString("uid", response.user!.uid);
    }
    _user = ContactModel()..uid = response.user!.uid;
    notifyListeners();
  }

  void regularLogin() async {
    var _pref = await SharedPreferences.getInstance();
    String uid = _pref.getString("uid") ?? "";
    var buffer = await _usersRef.where("uid", isEqualTo: uid).get();
    _user = ContactModel()..uid = uid;

    notifyListeners();
  }

  static Stream<QuerySnapshot> getMessages() {
    return app.collection("messages").orderBy("time").snapshots();
  }

  static void writeMessages(String from, String to, String message) async {
    int hash =
        "${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}"
            .hashCode;
    Map<String, dynamic> data = {
      "from": from,
      "to": to,
      "text": message,
      "time": int.parse(
          "${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}"),
      "id": hash
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

  void uploadImage() async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    var instance = ImagePicker();
    XFile? file = await instance.pickImage(source: ImageSource.gallery);

    File image = File(file!.path);
    var ref = _storage.ref().child("images/${image.hashCode}");
    try {
      var buffer = ref.putFile(image);
      await buffer.whenComplete(() async {
        var url = await ref.getDownloadURL();
        _user = ContactModel()..profileImage = url.toString();
      });
    } catch (e) {
      log("Profile photo not added up " + e.toString());
    }
    notifyListeners();
  }
}
