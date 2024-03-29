import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/model/contact.dart';
import 'package:securesocialmedia/model/user.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/constants.dart';

import 'widgets/left.dart';
import 'widgets/right.dart';

class MessageChatPage extends StatefulWidget {
  final ContactModel contact;
  final String to;
  const MessageChatPage({super.key, required this.contact, required this.to});

  @override
  State<MessageChatPage> createState() => _MessageChatPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _MessageChatPageState extends State<MessageChatPage> {
  bool harmfull = false;

  TextEditingController _controller = TextEditingController();
  bool isPhoto = false;
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secureScreen();
    setState(() {
      isPhoto = false;
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    harmfull = Provider.of<AppService>(context, listen: false).isHarmfull;
    var messages = AppService.getMessages();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
          ),
        ),
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Consts.primary,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            widget.contact.username,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.contact.profileImage,
                  ),
                ),
                shape: BoxShape.circle,
                color: Consts.primary,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Consts.primary,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: messages,
            builder: (context, snapshot) {
              //log(snapshot.data!.docs.length.toString() + "  Data length");
              return SingleChildScrollView(
                  child: snapshot.hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      color: Consts.secondary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //message builind list

                            ...List.generate(
                              snapshot.data!.docs
                                  .where((element) =>
                                      element['users'].contains(widget.to))
                                  .length,
                              (index) => snapshot.data!.docs[index]['from'] ==
                                      auth.currentUser!.uid
                                  ? GestureDetector(
                                      onDoubleTap: () {
                                        HapticFeedback.vibrate();
                                        AppService.deleteMessage(snapshot
                                            .data!.docs[index]['id']
                                            .toString());
                                      },
                                      child: RightMessage(
                                        message: snapshot.data!.docs[index]
                                            ['text'],
                                        type: snapshot.data!.docs[index]
                                            ['type'],
                                      ),
                                    )
                                  : GestureDetector(
                                      onLongPress: () {
                                        log(snapshot.data!.docs
                                            .where((element) =>
                                                element['to'] == widget.to)
                                            .toList()[index]['to']
                                            .toString());

                                        log(auth.currentUser!.uid +
                                            " Current uid " +
                                            "Current index " +
                                            index.toString());
                                        // HapticFeedback.vibrate();
                                        // AppService.deleteMessage(
                                        //     snapshot.data!.docs[index]['id']);
                                      },
                                      child: LeftMessage(
                                        contact: widget.contact,
                                        message: snapshot.data!.docs[index]
                                            ['text'],
                                        type: snapshot.data!.docs[index]
                                            ['type'],
                                      ),
                                    ),
                            )
                            //message 1
                            // LeftMessage(
                            //   contact: contact,
                            //   message: "Hello !! What's up?",
                            // ),
                            // //message 2
                            // RightMessage(
                            //   message: "Hello! Kit",
                            // ),
                            // RightMessage(
                            //   message: "I am doing great! How are you today?",
                            // ),
                            // LeftMessage(
                            //     contact: contact, message: "Hmm, everything is fine"),
                            // LeftMessage(
                            //     contact: contact,
                            //     message:
                            //         "Now a days i'm focusing on travelling. In\nthe last summer, I visited Erode"),
                            // RightMessage(message: "WOW! Amazing city"),
                            // RightMessage(
                            //     message:
                            //         "Erode is a city in Tamil Nadu,India\nknown for its textileindustries,\ntemples,and natural attractions like the\nBhavani Sagar Dam."),

                            // LeftMessage(contact: contact, message: "Great!"),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: Consts.secondary,
                          ),
                        ));
            }),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          title: SizedBox(
            child: TextField(
              // "Type something",
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type something",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Consts.bg,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              AppService.writeMessages(
                  auth.currentUser!.uid, widget.to, _controller.text, false);
              _controller.clear();
            },
            onDoubleTap: () {
              setState(() {
                isPhoto = !isPhoto;
                Provider.of<AppService>(context, listen: false)
                    .updateMessageType(isPhoto);
              });
              Future.delayed(Duration(seconds: 2));
              Provider.of<AppService>(context, listen: false)
                  .uploadImage(widget.to);
            },
            child: isPhoto ? Icon(Icons.photo_camera) : Icon(Icons.send),
          ),
        ),
      ),
      floatingActionButton:
          Text(harmfull ? "Harmfull Images are not allowed" : ""),
    );
  }
}
