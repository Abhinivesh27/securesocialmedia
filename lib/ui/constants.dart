import 'package:flutter/material.dart';
import 'package:securesocialmedia/model/contact.dart';

class Consts {
  static Color primary = Colors.white;
  static Color secondary = Colors.redAccent.shade200;
  static Color bg = Colors.grey.shade200;
}

class PlaceholderData {
  static List<ContactModel> contacts = [
    ContactModel()
      ..profileImage =
          "http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTUHhgvrnnW7o1YI99qPkrB5g5HJ31yW4NUBRn1clO9X2d3GbCpvyO65DefpJuH89w8qf-LUI_R0gOtjuI"
      ..username = "Kit Harington"
      ..message = "Where're you going"
      ..time = "23:09"
      ..online = true,
    ContactModel()
      ..profileImage =
          "http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRKJNiOaWFCkcb2qQ_zMitV7QpsYiWgDNjZVWmQEsLxAMkrLr_2MsZXY3-wUIPLPC_hV8Q3Y-Fp_vmK9XA"
      ..username = "Tom"
      ..message = "i'm done"
      ..time = "21:28",
    ContactModel()
      ..profileImage =
          "https://people.com/thmb/pzxY5GquwpKVdX5heGDH2NXfEjE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(732x659:734x661)/nikolaj-coster-waldau-2000-5fdb3f8e7efb4455a37042a268941ead.jpg"
      ..username = "Nik Coaster"
      ..message = "Hey....!"
      ..time = "18:35"
      ..online = true,
    ContactModel()
      ..profileImage =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9_yjizatvJDNvBS97g7pZ5_s1AQyGxgM8LLAOLP2sRL21IJDA"
      ..username = "GVP Music Falls"
      ..message = "Oh god, that's not right"
      ..time = "18:22"
      ..online = true,
    ContactModel()
      ..profileImage =
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD2u4FwyXrxtPGu5BBDfbK9jyVBrtJOy9H58JU--FodTtAoLHvyhKbY7BgEXuNEGcxew4&usqp=CAU"
      ..username = "Jorah Diaz"
      ..message = "on the way"
      ..time = "18:21",
    ContactModel()
      ..profileImage =
          "http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRHQu2KT8tcWkbuKyuBmk5jx6LH4Cn8p4jerXoFF-6ZjDJURJX0wEI9WAZs74owbmiy_2fjARrK4p9iTqA"
      ..username = "Braine Issac"
      ..message = "Everyboady needs knowledge"
      ..time = "13:01",
  ];
}
