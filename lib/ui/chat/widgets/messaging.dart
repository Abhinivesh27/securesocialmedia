import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/model/user.dart';
import 'package:securesocialmedia/service/service.dart';

import '../../../model/message.dart';

class MessagingPage extends StatelessWidget {
  final AppUser from;
  final AppUser to;
  final List<Message> messages;
  const MessagingPage(
      {super.key,
      required this.from,
      required this.to,
      required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(to.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ...List.generate(
                Provider.of<AppService>(context, listen: true).messages.length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: index / 2 != 0
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              Provider.of<AppService>(context, listen: true)
                                  .messages[index]
                                  .message,
                            ),
                          ),
                        ],
                      ),
                    ))
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(left: 30),
        child: TextField(
          decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
        ),
      ),
    );
  }
}
