import 'package:flutter/material.dart';
import 'package:securesocialmedia/model/contact.dart';

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

          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) => Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        PlaceholderData.contacts[index].profileImage,
                      ),
                    ),
                    shape: BoxShape.circle,
                    color: Consts.primary),
              ),
            ),
          ),
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
