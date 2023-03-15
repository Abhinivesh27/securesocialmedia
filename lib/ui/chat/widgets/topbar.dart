import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/model/contact.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/messaging/messaging.dart';

import '../../constants.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Consts.bg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //recent chats

          CircleImageButton(),
          //search bar
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 3,
                    blurRadius: 2),
              ],
            ),
            height: 60,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  fillColor: Consts.primary,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  label: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey.shade300,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Search",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: StreamBuilder(
          stream: AppService.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageChatPage(
                          contact: ContactModel()
                            ..profileImage = snapshot.data!.docs[index]['url']
                            ..username = snapshot.data!.docs[index]['name'],
                          to: snapshot.data!.docs[index]['uid'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              NetworkImage(snapshot.data!.docs[index]['url']),
                        ),
                        shape: BoxShape.circle,
                        color: Consts.primary),
                  ),
                ),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Consts.secondary,
              ));
            }
          }),
    );
  }
}
