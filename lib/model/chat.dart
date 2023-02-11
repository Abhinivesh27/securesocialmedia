import 'package:securesocialmedia/model/message.dart';
import 'package:securesocialmedia/model/user.dart';

class Chat {
  AppUser from = AppUser();
  AppUser to = AppUser();
  List<Message> messages = [];
}
