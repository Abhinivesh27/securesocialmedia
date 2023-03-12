import 'package:flutter/material.dart';
import 'package:securesocialmedia/ui/constants.dart';

import 'widgets/topbar.dart';

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
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                color: Consts.secondary,
                child: Text("Hello"),
              ),
              //two
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Consts.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              //three
              TopBar(),
            ],
          ),
        ),
      ),
    );
  }
}
