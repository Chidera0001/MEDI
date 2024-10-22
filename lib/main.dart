import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medi_quick/screens/doctorProfile.dart';
import 'package:medi_quick/screens/firebaseAuth.dart';
import 'package:medi_quick/mainPage.dart';
import 'package:medi_quick/screens/myAppointments.dart';
import 'package:medi_quick/screens/splashScreen.dart';
import 'package:medi_quick/screens/userProfile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyApp({super.key});

  Future<Widget> _getInitialRoute() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return const SplashScreen();
    } else {
      return const MainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialRoute(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: CircularProgressIndicator());
        } else {
          return MaterialApp(
            home: snapshot.data,
            routes: {
              '/login': (context) => const FireBaseAuth(),
              '/home': (context) => const MainPage(),
              '/profile': (context) => const UserProfile(key: ValueKey('UserProfile')), // Provide a key
              '/MyAppointments': (context) => const MyAppointments(),
              '/DoctorProfile': (context) => const DoctorProfile(key: ValueKey('DoctorProfile'), doctor: 'Doctor Name'), // Provide a key and the doctor name
            },
            theme: ThemeData(brightness: Brightness.light),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}