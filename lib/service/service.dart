import 'dart:collection';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:securesocialmedia/model/message.dart';
import 'package:securesocialmedia/model/user.dart';

import '../model/chat.dart';

FirebaseFirestore app = FirebaseFirestore.instance;
CollectionReference _chatRef = app.collection("chats");
CollectionReference _messageRef = app.collection("messages");

class AppService extends ChangeNotifier {
  List<Chat> _chats = [];
  UnmodifiableListView<Chat> get chats => UnmodifiableListView(_chats);
  List<Message> _messages = [];
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  AppUser _user = AppUser()
    ..uid = "ekyaUYfkVdcEr09nGVDquqGwD473"
    ..name = "New User"
    ..number = "98765431";
  void parseChats() async {
    List<String> id = [];
    await _chatRef.where("from", isEqualTo: _user.uid).get().then((value) {
      value.docs.forEach((element) {
        id.add(element['mid']);
      });
    });
    id.forEach((messageId) async {
      await _messageRef.doc(messageId).get().then((value) {
        _messages.add(
          Message()
            ..message = value['message']
            ..id = value['mid']
            ..time = value['time'],
        );
      });
      notifyListeners();
    });
    await _chatRef.where("from", isEqualTo: _user.uid).get().then((value) {
      value.docs.forEach((element) {
        _chats.add(
          Chat()
            ..from = _user
            ..messages = _messages
            ..to = AppUser(),
        );
        notifyListeners();
      });
    });
  }
}
