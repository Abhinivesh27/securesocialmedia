import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securesocialmedia/service/service.dart';
import 'package:securesocialmedia/ui/chat/chat.dart';
import 'package:securesocialmedia/ui/splash/splash.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => AppService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatPage(),
      ),
    );
  }
}
