import 'package:flutter/material.dart';
import 'package:securesocialmedia/ui/messaging/messaging.dart';

import '../../constants.dart';

class ListOfChats extends StatelessWidget {
  const ListOfChats({
    super.key,
  });

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
        child: ListView.builder(
          itemCount: PlaceholderData.contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageChatPage(
                      contact: PlaceholderData.contacts[index],
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
                      PlaceholderData.contacts[index].profileImage,
                    ),
                  ),
                  shape: BoxShape.circle,
                  color: Consts.primary,
                ),
                child: PlaceholderData.contacts[index].online
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            border: Border.all(color: Consts.primary, width: 2),
                            shape: BoxShape.circle,
                            color: Consts.secondary,
                          ),
                        ),
                      )
                    : Container(),
              ),
              title: Text(
                PlaceholderData.contacts[index].username,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                PlaceholderData.contacts[index].time,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                PlaceholderData.contacts[index].message,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
