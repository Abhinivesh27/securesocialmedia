import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/service/service.dart';

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
              onPressed: () {
                Provider.of<AppService>(context, listen: false)
                    .updateTabIndex(0);
              },
              icon: Icon(
                Icons.chat_sharp,
                size: 25,
                color:
                    Provider.of<AppService>(context, listen: true).tabIndex == 0
                        ? Consts.primary
                        : Colors.white54,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<AppService>(context, listen: false)
                    .updateTabIndex(1);
              },
              icon: Icon(
                Icons.group,
                size: 25,
                color:
                    Provider.of<AppService>(context, listen: true).tabIndex == 1
                        ? Consts.primary
                        : Colors.white54,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<AppService>(context, listen: false)
                    .updateTabIndex(2);
              },
              icon: Icon(
                Icons.settings,
                size: 25,
                color:
                    Provider.of<AppService>(context, listen: true).tabIndex == 2
                        ? Consts.primary
                        : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
