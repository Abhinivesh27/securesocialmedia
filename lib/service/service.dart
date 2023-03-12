import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  List<Chat> _chats = [];
  UnmodifiableListView<Chat> get chats => UnmodifiableListView(_chats);
  List<Message> _messages = [];
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  AppUser _user = AppUser();
  AppUser get nowUser => _user;

  void parseChats() async {
    var _pref = await SharedPreferences.getInstance();
    String uid = await _pref.getString("uid") ?? "";
    List<String> id = [];
    log("Current uid is " + uid);
    await _chatRef.where("owner", isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        id.add(element['mid']);
      });
      log("Mesage id " + id.toString());
    });
    id.forEach((messageId) async {
      await _messageRef.where("mid", isEqualTo: messageId).get().then((value) {
        List.generate(
            value.docs.length,
            (index) => _messages.add(
                  Message()
                    ..message = value.docs[index]['message']
                    ..id = value.docs[index]['mid']
                    ..time = value.docs[index]['time'],
                ));
      });
      notifyListeners();
    });
    await _chatRef.where("from", isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) async {
        var buffer =
            await _usersRef.where("uid", isEqualTo: element['to']).get();
        AppUser _Uuser = AppUser()
          ..name = buffer.docs[0]['name']
          ..number = buffer.docs[0]['number']
          ..uid = buffer.docs[0]['uid'];
        _chats.add(
          Chat()
            ..from = _user
            ..messages = _messages
            ..to = _Uuser,
        );
        notifyListeners();
      });
    });
  }

  void newLogin(String email, String password) async {
    var response = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    var _pref = await SharedPreferences.getInstance();
    var buffer =
        await _usersRef.where("uid", isEqualTo: response.user!.uid).get();
    _user = AppUser()
      ..name = buffer.docs[0]['name']
      ..number = buffer.docs[0]['number']
      ..uid = buffer.docs[0]['uid'];

    _pref.setString("uid", _user.uid);

    notifyListeners();
  }

  void regularLogin() async {
    var _pref = await SharedPreferences.getInstance();
    String uid = await _pref.getString("uid") ?? "";
    var buffer = await _usersRef.where("uid", isEqualTo: uid).get();
    _user = AppUser()
      ..name = buffer.docs[0]['name']
      ..number = buffer.docs[0]['number']
      ..uid = buffer.docs[0]['uid'];

    notifyListeners();
  }
}
