import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class RightMessage extends StatelessWidget {
  const RightMessage({
    super.key,
    required this.message,
    required this.type,
  });
  final String message;
  final bool type;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: Consts.secondary,
              ),
              child: type
                  ? Container(
                      constraints:
                          BoxConstraints(maxHeight: 150, maxWidth: 200),
                      child: Image.network(
                        message,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Consts.primary,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
