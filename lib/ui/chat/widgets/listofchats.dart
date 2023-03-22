import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:securesocialmedia/model/contact.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/messaging/messaging.dart';

import '../../constants.dart';

FirebaseFirestore app = FirebaseFirestore.instance;

class ListOfChats extends StatefulWidget {
  const ListOfChats({
    super.key,
  });

  @override
  State<ListOfChats> createState() => _ListOfChatsState();
}

class _ListOfChatsState extends State<ListOfChats> {
  List<ContactModel> userDatas = [];
  void setUserData() async {
    var buffer = await app
        .collection("users")
        .where("uid", isNotEqualTo: auth.currentUser!.uid)
        .get();
    buffer.docs.forEach((element) {
      userDatas.add(ContactModel()
        ..username = element['name']
        ..profileImage = element['url']
        ..uid = element['uid']
        ..email = element['email']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 200, bottom: 15),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Consts.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: AppService.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                setUserData();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageChatPage(
                              contact: userDatas[index],
                              to: snapshot.data!.docs[index]['uid'],
                            ),
                          ),
                        );
                      },
                      minVerticalPadding: 20,
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              snapshot.data!.docs[index]['url'],
                            ),
                          ),
                          shape: BoxShape.circle,
                          color: Consts.primary,
                        ),
                        child: snapshot.hasData
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Consts.primary, width: 2),
                                    shape: BoxShape.circle,
                                    color: Consts.secondary,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      title: Text(
                        snapshot.data!.docs[index]['name'],
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        "",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "tap to chat",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Consts.secondary,
                  ),
                );
              }
            }),
      ),
    );
  }
}
