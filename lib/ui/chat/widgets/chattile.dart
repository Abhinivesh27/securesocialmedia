import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/chat/widgets/messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/message.dart';
import '../../../model/user.dart';

class ChatTile extends StatelessWidget {
  final AppUser from;
  final AppUser to;
  final List<Message> messages;
  const ChatTile({
    super.key,
    required this.from,
    required this.to,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingPage(
              from: from,
              to: to,
              messages: messages,
            ),
          ),
        );
      },
      title: Text(
        to.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        radius: 25,
        child: Icon(Icons.person_2),
      ),
      subtitle: Row(children: [
        from.uid == Provider.of<AppService>(context).nowUser.uid
            ? SizedBox()
            : Icon(Icons.done),
        SizedBox(width: 5),
        Text(
          messages.last.message.toString(),
          style: TextStyle(
            fontSize: 18,
          ),
        )
      ]),
      trailing: Text(messages.last.time.toString()),
    );
  }
}
