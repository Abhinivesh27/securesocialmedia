import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/chat/about.dart';
import 'package:securesocialmedia/ui/constants.dart';

import 'widgets/botnavbar.dart';
import 'widgets/listofchats.dart';
import 'widgets/topbar.dart';

List<Widget> bodyItems = [
  ListOfChats(),
  AboutSection(),
  Container(
    child: Text(
      "Settings page",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
  )
];

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 40,
              ),
            ),
          ],
          elevation: 0,
          foregroundColor: Consts.secondary,
          backgroundColor: Consts.bg,
        ),
        backgroundColor: Consts.primary,
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Consts.primary,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              //one
              BottomNavBarCustom(),
              //two
              bodyItems[
                  Provider.of<AppService>(context, listen: true).tabIndex],
              //three
              TopBar(),
            ],
          ),
        ),
      ),
    );
  }
}
