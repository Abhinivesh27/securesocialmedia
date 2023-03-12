import 'package:flutter/material.dart';

import '../../constants.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Consts.bg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
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
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Consts.primary),
                child: Icon(
                  Icons.add,
                  color: Consts.secondary,
                  size: 60,
                ),
              ),
            ),
          ),
          //search bar
          Container(
            width: MediaQuery.of(context).size.width,
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
