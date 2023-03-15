import 'package:flutter/material.dart';

import '../../constants.dart';

class BottomNavBarCustom extends StatelessWidget {
  const BottomNavBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomCenter,
      color: Consts.secondary,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_sharp,
                size: 25,
                color: Consts.primary,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.group,
                size: 25,
                color: Colors.white54,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 25,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
