import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../model/contact.dart';
import '../../constants.dart';

class LeftMessage extends StatelessWidget {
  const LeftMessage({
    super.key,
    required this.contact,
    required this.message,
  });

  final ContactModel contact;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  contact.profileImage,
                ),
              ),
              shape: BoxShape.circle,
              color: Consts.primary,
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Consts.bg,
            ),
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
