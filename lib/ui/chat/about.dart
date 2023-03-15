import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/splash/splash.dart';

FirebaseFirestore app = FirebaseFirestore.instance;

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  String url = "";
  void getImage() async {
    try {
      var buffer = await app
          .collection("users")
          .doc(Provider.of<AppService>(context, listen: false).nowUser.uid)
          .get();
      setState(() {
        url = buffer['url'];
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 300, bottom: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //profile pic
          GestureDetector(
            onTap: () {
              getImage();
              Provider.of<AppService>(context, listen: false).uploadImage();

              getImage();
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(url),
            ),
          ),
          //user name
          Text(
            Provider.of<AppService>(context, listen: true).nowUser.username,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          //email
          Text(
            Provider.of<AppService>(context, listen: true).nowUser.email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                Provider.of<AppService>(context, listen: false).logoutUser();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SplashScreen()));
              },
              icon: Icon(Icons.logout),
              label: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ))
        ],
      ),
    );
  }
}
