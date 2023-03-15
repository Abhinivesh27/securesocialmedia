import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securesocialmedia/model/contact.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/constants.dart';

import 'widgets/left.dart';
import 'widgets/right.dart';

class MessageChatPage extends StatefulWidget {
  final ContactModel contact;
  const MessageChatPage({super.key, required this.contact});

  @override
  State<MessageChatPage> createState() => _MessageChatPageState();
}

class _MessageChatPageState extends State<MessageChatPage> {
  String uid = "WyGqbFjGjzezzbPPPXWAj01kMCz1";
  var messages = AppService.getMessages();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                                      "Yesterday",
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
                                snapshot.data!.docs.length,
                                (index) => snapshot.data!.docs[index]['from'] ==
                                        uid
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
                                        ),
                                      )
                                    : GestureDetector(
                                        onLongPress: () {
                                          HapticFeedback.vibrate();
                                          AppService.deleteMessage(
                                              snapshot.data!.docs[index]['id']);
                                        },
                                        child: LeftMessage(
                                            contact: widget.contact,
                                            message: snapshot.data!.docs[index]
                                                ['text']),
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
            trailing: IconButton(
                onPressed: () {
                  AppService.writeMessages(
                      uid, "7VYss67k2ubUnZqIratAkZwNGmc2", _controller.text);
                  _controller.clear();
                },
                icon: Icon(
                  Icons.send,
                )),
          ),
        ));
  }
}
